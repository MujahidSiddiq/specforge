-- specforge command line.
--
--   texlua tools/specforge.lua <command> ...
--   specforge.cmd <command> ...           Windows
--   sh specforge.sh <command> ...         Linux, macOS
--
-- texlua ships with every LuaLaTeX installation: nothing else is needed.

kpse.set_program_name("lualatex")

local lfs = lfs or require("lfs")
local here = arg[0]:gsub("\\", "/"):match("^(.*)/[^/]+$") or "."
if not (here:match("^/") or here:match("^%a:")) then
  here = lfs.currentdir():gsub("^\\\\%?\\", ""):gsub("\\", "/") .. "/" .. here
end

-- Modules are loaded by absolute path. require() would also search the
-- current folder, which is usually somebody's project.
local function module(name, ...)
  local m = dofile(here .. "/lib/" .. name .. ".lua")
  if type(m) == "function" then return m(...) end
  return m
end

local U = module("util")
local Y = module("yaml", U)
local C = module("colour")
local P = module("project", U, Y)
local S = module("style", U, Y, C)
local M = module("md2tex", U)
local F = module("figcheck", U)
local I = module("inventory", U)
local B = module("build", U, P, S, M, F)
local H = module("chat", U, P, I, F)
local ROOT = U.dirname(U.normalize(here))

local HELP = [[
specforge <command> ...

  new <project> --approach design-info|rtl [--input <folder>] [--top <module>]
                [--notes <folder>] [--title <text>] [--short <name>] [--author <name>]
        create a project folder; existing files are never overwritten
  check <project>
        check configuration, style, chapters and figures; write the Markdown
  build <project> [--figures]
        check, then build the PDF; --figures also writes the SVG previews
  inventory <project>
  inventory --rtl <folder> --top <module> [--out <file.md>]
        reading aid for SystemVerilog and Verilog RTL
  chat-pack <project> [--no-inputs]
        one file with the project and its inputs, to upload to a chat AI
  unpack <project> <saved-answer.txt>
        write the files contained in a saved chat answer
  doctor [--build]
        check this computer; --build also builds a test document
  bundle [--check]
        regenerate specforge-chat.md (after changing the framework)
  version
]]

local FLAGS = U.set({ "figures", "no-inputs", "build", "check", "help" })
local OPTIONS = {
  new = U.set({ "approach", "input", "top", "notes", "title", "short", "author" }),
  check = {}, build = U.set({ "figures" }), inventory = U.set({ "rtl", "top", "out" }),
  ["chat-pack"] = U.set({ "no-inputs" }), unpack = {}, doctor = U.set({ "build" }),
  bundle = U.set({ "check" }), version = {}, help = {},
}

local function parse(command)
  local pos, opt, i = {}, {}, 2
  while arg[i] ~= nil do
    local name = arg[i]:match("^%-%-(.+)$")
    if name then
      if not OPTIONS[command][name] then U.fail("unknown option --%s for '%s' (see: specforge help)", name, command) end
      if FLAGS[name] then
        opt[name] = true
      else
        i = i + 1
        if arg[i] == nil then U.fail("--%s needs a value", name) end
        opt[name] = arg[i]
      end
    else
      pos[#pos + 1] = arg[i]
    end
    i = i + 1
  end
  return pos, opt
end

local function project_dir(pos)
  if not pos[1] then U.fail("name the project folder") end
  return (U.abs(pos[1]):gsub("/$", ""))
end

local run = {}

function run.help() io.stdout:write(HELP) end

function run.version() U.say("specforge " .. P.version(ROOT)) end

function run.new(pos, opt)
  local dir = project_dir(pos)
  for _, f in ipairs(P.create(ROOT, dir, opt)) do U.say("  " .. f) end
  U.say("Created the project " .. dir)
end

function run.check(pos) B.run(ROOT, project_dir(pos), { pdf = false, figures = false }) end

function run.build(pos, opt) B.run(ROOT, project_dir(pos), { pdf = true, figures = opt.figures }) end

function run.inventory(pos, opt)
  local folder, top, out
  if pos[1] then
    local p = P.load(ROOT, project_dir(pos), false)
    if p.approach ~= "rtl" then U.fail("the approach of this project is %s, not rtl", p.approach) end
    folder, top, out = P.input_dir(p), p.rtl_top, p.dir .. "/build/rtl-inventory.md"
  else
    if not opt.rtl or not opt.top then U.fail("give a project, or --rtl <folder> --top <module>") end
    folder, top, out = U.abs(opt.rtl), opt.top, opt.out and U.abs(opt.out)
  end
  local text = I.markdown(I.scan(folder), top)
  if out then U.write(out, text); U.say("Wrote " .. out) else io.stdout:write(text) end
end

run["chat-pack"] = function(pos, opt)
  local dir = project_dir(pos)
  local text, count = H.pack(ROOT, dir, not opt["no-inputs"])
  local out = dir .. "/build/chat-pack.md"
  U.write(out, text)
  U.say(string.format("Wrote %s (%d input file(s), %d KB)", out, count, math.ceil(#text / 1024)))
  U.say("It contains your design. Upload it only to an AI service you may share that design with.")
end

function run.unpack(pos)
  local dir = project_dir(pos)
  if not pos[2] then U.fail("name the saved answer file") end
  if not U.is_dir(dir) then U.fail("project folder not found: %s", dir) end
  H.unpack(dir, U.abs(pos[2]))
end

function run.bundle(_, opt)
  local path, text = ROOT .. "/specforge-chat.md", H.bundle(ROOT)
  if opt.check then
    if not U.is_file(path) or U.read(path) ~= text then U.fail("specforge-chat.md is out of date: run 'specforge bundle'") end
    U.say("specforge-chat.md is up to date.")
  else
    U.write(path, text)
    U.say(string.format("Wrote %s (%d KB)", path, math.ceil(#text / 1024)))
  end
end

function run.doctor(_, opt)
  local missing = 0
  local function item(ok, label, hint, optional)
    local mark = ok and "ok      " or optional and "optional" or "MISSING "
    U.say(mark .. "  " .. label .. ((not ok and hint) and " -- " .. hint or ""))
    if not ok and not optional then missing = missing + 1 end
  end
  local function found(name, kind)
    local p = kpse.find_file(name, kind)
    return p ~= nil and p ~= ""
  end

  U.say("specforge " .. P.version(ROOT) .. " on " .. tostring(os.type) .. "/" .. tostring(os.name))
  item(U.which("lualatex") ~= nil, "lualatex", "install MiKTeX or TeX Live")
  item(U.which("pdftocairo") ~= nil, "pdftocairo (SVG previews)", "install poppler", true)
  for _, pkg in ipairs({ "geometry", "fontspec", "amsmath", "xcolor", "colortbl", "tabularx", "booktabs",
    "ragged2e", "parskip", "microtype", "enumitem", "titlesec", "fancyhdr", "caption", "float",
    "placeins", "adjustbox", "varwidth", "tikz", "tikz-timing", "hyperref", "bookmark" }) do
    item(found(pkg .. ".sty", "tex"), "LaTeX package " .. pkg, "install it with your TeX package manager")
  end
  item(found("preview.sty", "tex"), "LaTeX package preview (SVG previews)", "install the package preview", true)
  for _, f in ipairs({ "SourceSans3-Regular", "SourceSans3-RegularIt", "SourceSans3-Semibold",
    "SourceSans3-SemiboldIt", "SourceSans3-Bold", "SourceSans3-BoldIt", "SourceCodePro-Regular",
    "SourceCodePro-Semibold" }) do
    item(found(f .. ".otf", "opentype fonts"), "font " .. f, "install the packages sourcesans and sourcecodepro")
  end

  if opt.build then
    U.say("Building the test document ...")
    local tmp = U.tempdir()
    local ok, err = pcall(function()
      local src = ROOT .. "/tests/fixture"
      for _, rel in ipairs(U.walk(src)) do U.copy(src .. "/" .. rel, tmp .. "/project/" .. rel) end
      B.run(ROOT, tmp .. "/project", { pdf = true, figures = U.which("pdftocairo") ~= nil })
    end)
    U.remove_tempdir(tmp)
    item(ok, "test build", type(err) == "table" and err.specforge or tostring(err))
  end

  if missing > 0 then U.fail("%d item(s) missing", missing) end
  U.say("This computer can build specforge documents."
    .. (opt.build and "" or " To prove it, run: specforge doctor --build"))
end

local command = arg[1] or "help"
if command == "--help" or command == "-h" then command = "help" end

local ok, err = pcall(function()
  if not run[command] then U.fail("unknown command '%s' (see: specforge help)", command) end
  run[command](parse(command))
end)

io.stdout:flush()
if not ok then
  local expected = type(err) == "table" and err.specforge
  io.stderr:write("ERROR: ", expected or ("internal error: " .. tostring(err)), "\n")
  os.exit(1)
end
