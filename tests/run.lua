-- specforge test suite:  texlua tests/run.lua
-- Builds the fixture and feeds bad input to the converter, checks and tools.

kpse.set_program_name("lualatex")
local lfs = lfs or require("lfs")
local here = arg[0]:gsub("\\", "/"):match("^(.*)/[^/]+$") or "."
if not (here:match("^/") or here:match("^%a:")) then
  here = lfs.currentdir():gsub("^\\\\%?\\", ""):gsub("\\", "/") .. "/" .. here
end
local function module(name, ...)
  local m = dofile(here .. "/../tools/lib/" .. name .. ".lua")
  if type(m) == "function" then return m(...) end
  return m
end
local U = module("util")
local Y = module("yaml", U)
local C = module("colour")
local I = module("inventory", U)
local P = module("project", U, Y, I)
local L = module("cli", U)
local S = module("style", U, Y, C)
local M = module("md2tex", U)
local F = module("figcheck", U)
local B = module("build", U, P, S, M, F)
local ROOT = U.normalize(here .. "/..")

local passed, failed, serial = 0, 0, 0
local function test(name, ok, detail)
  if ok then
    passed = passed + 1
  else
    failed = failed + 1
    print("FAIL " .. name .. (detail and ": " .. tostring(detail) or ""))
  end
end
local function refuses(name, fn)
  local ok, err = pcall(fn)
  test(name, not ok and type(err) == "table" and err.specforge,
    ok and "was accepted" or (type(err) == "table" and err.specforge or err))
end
local function has(s, part) return s:find(part, 1, true) ~= nil end

local tmp = U.tempdir()
local work = tmp .. "/work with space"

local function fixture()
  serial = serial + 1
  local to = work .. "/case " .. serial
  local from = ROOT .. "/tests/fixture"
  for _, rel in ipairs(U.walk(from)) do U.copy(from .. "/" .. rel, to .. "/" .. rel) end
  return to
end

local function conversion()
  local x = M.inline("`x}\\textbf{INJECTED`")
  test("code cannot inject", not has(x, "\\textbf{"), x)
  test("plain code is unchanged", M.inline("`data_valid`") == "\\sig{data_valid}")
  test("percent in code", has(M.inline("`50%`"), "50\\%"))
  test("backslash then brace", M.inline("\\{") == "\\textbackslash{}\\{", M.inline("\\{"))
  test("prose cannot inject", not has(M.inline("\\input{secret}"), "\\input"))
  test("pipe in a code cell", #M.cells("| `a | b` | c |") == 2)
  test("escaped pipe", M.cells("| a \\| b | c |")[1] == "a | b")
  local conv = M.converter({ ["page.paper"] = "a4", ["page.margin_mm"] = 22, ["tables.column_sep_pt"] = 6,
    ["figures.max_height_fraction"] = 0.44, ["figures.max_height_fraction_timing"] = 0.62, ["figures.floats_stay_in_chapter"] = true })
  local body = table.concat(conv.convert("# 1. A\n\n- first line\n  goes on\n- second\n\nAfter.\n", "x.md", false, 1), "\n")
  test("one picture is a scalable box", M.single_picture("% c\n\\begin{tikzpicture}\n\\draw (0,0)--(1,1);\n\\end{tikzpicture}\n"))
  test("a picture with text is not", not M.single_picture("\\begin{tikzpicture}\\end{tikzpicture}\n\\par text"))
  test("a timing table is not", not M.single_picture("\\begin{tikztimingtable}\\end{tikztimingtable}"))
  test("wrapped list item stays one item", body:find("\\item first line goes on", 1, true) and select(2, body:gsub("\\item", "")) == 2, body)
  refuses("link injection", function() M.inline("[x](https://a.b/}\\input{y})") end)
  refuses("file link", function() M.inline("[x](file:///etc/passwd)") end)
end

local function configuration()
  local function project(yaml)
    local dir = fixture()
    local base = U.read(dir .. "/project.md"):gsub("page_budget:", function() return yaml .. "\npage_budget:" end)
    U.write(dir .. "/project.md", base)
    return function() P.load(ROOT, dir, true) end
  end
  local function style_raw(text)
    local dir = fixture()
    U.write(dir .. "/style.md", "```yaml\n" .. text .. "\n```\n")
    return function() S.make(ROOT, dir) end
  end
  local function style(yaml)
    local dir = fixture()
    U.write(dir .. "/style.md", "```yaml\noverrides:\n" .. yaml .. "\n```\n")
    return function() S.make(ROOT, dir) end
  end
  refuses("output outside the project", project("output:\n  dir: ../../out"))
  refuses("absolute output", project("output:\n  dir: C:/out"))
  refuses("file name traversal", project("output:\n  file_name: ../x"))
  refuses("duplicate key", project("approach: rtl"))
  test("revision stays text", P.load(ROOT, fixture(), true).revision == "1.10")
  local function typed(kind)
    local dir = fixture()
    U.write(dir .. "/project.md", (U.read(dir .. "/project.md"):gsub("design%-spec", kind)))
    return dir
  end
  local lp = P.load(ROOT, typed("high-level-spec"), true)
  test("0.2 document type still loads", lp.file_name == "EVC_High-Level_Specification" and lp.subtitle == "High-Level Specification")
  local np = P.load(ROOT, fixture(), true)
  test("design specification defaults", np.file_name == "EVC_Design_Specification" and np.subtitle == "Design Specification")
  refuses("unknown document type", function() P.load(ROOT, typed("magic"), true) end)
  local function level(text)
    local dir = fixture()
    U.write(dir .. "/project.md", (U.read(dir .. "/project.md"):gsub("diagrams: detailed", text)))
    return dir
  end
  refuses("unknown diagram level", function() P.load(ROOT, level("diagrams: magic"), true) end)
  local half = fixture()
  U.write(half .. "/project.md", (U.read(half .. "/project.md"):gsub("max: 15", "max: 12.5")))
  refuses("page maximum must be whole", function() P.load(ROOT, half, true) end)
  test("no page minimum by default", P.load(ROOT, level("diagrams: detailed"), true).min_pages == 1)
  refuses("diagram level needed for a build", function() P.load(ROOT, level('diagrams: ""'), true) end)
  test("diagram level may wait until the build", P.load(ROOT, level('diagrams: ""'), false).diagrams == nil)
  test("0.2 projects keep a given level", P.load(ROOT, typed("high-level-spec"), true).diagrams == "detailed")
  refuses("font injection", style("  fonts:\n    main: 'X}\\input{y}'"))
  refuses("font size injection", style("  captions:\n    font_size: 'small\\input{y}'"))
  refuses("separator injection", style("  captions:\n    label_separator: 'x}\\input{y}'"))
  refuses("unknown style key", style("  colour:\n    no_such_key: 1"))
  test("accent override", pcall(style("  colour:\n    accent_primary: '#2F5D8A'")))

  -- colours by plain name, and element colours as #RRGGBB
  local function styled(text)
    local dir = fixture()
    U.write(dir .. "/style.md", "```yaml\n" .. text .. "\n```\n")
    return dir
  end
  local plain = styled("colours:\n  block_fill: '#EAF1F8'\n  waveform: '#123456'\n  state_fill: '#FFF2CC'\noverrides: {}")
  local ok, st = pcall(S.make, ROOT, plain)
  test("plain colour names", ok and st.value["diagrams.block.fill"] == "#EAF1F8" and st.value["timing.signal_colour"] == "#123456",
    not ok and (type(st) == "table" and st.specforge or st) or nil)
  test("element colour defined", ok and st.files["sf-setup.tex"]:find("{sfcDiagramsBlockFill}{HTML}{EAF1F8}", 1, true)
    and st.files["sf-config.tex"]:find("\\def\\sfDiagramsBlockFill{sfcDiagramsBlockFill}", 1, true))
  test("element colours are contrast-checked", ok and #st.failed == 0 and st.summary:find("34 of 34", 1, true), ok and st.summary)
  local function fails(name, text)
    local ok2, st2 = pcall(S.make, ROOT, styled(text))
    test(name, ok2 and #st2.failed > 0, ok2 and st2.summary or (type(st2) == "table" and st2.specforge or st2))
  end
  fails("unreadable block fill fails", "colours:\n  block_fill: '#30343A'\noverrides: {}")
  fails("faint waveform fails", "colours:\n  waveform: '#E0E0E0'\noverrides: {}")
  fails("dark page with dark text fails", "colours:\n  background: '#101010'\noverrides: {}")
  refuses("unknown plain name", style_raw("colours:\n  sky: '#FFFFFF'\noverrides: {}"))
  refuses("plain name and override together", style_raw("colours:\n  text: '#111111'\noverrides:\n  colour:\n    text_primary: '#222222'"))
  refuses("plain colour not hex", style_raw("colours:\n  text: 'blue'\noverrides: {}"))
  refuses("unknown top-level group", style_raw("colour:\n  text: '#111111'"))
  test("dark theme with light text passes", pcall(S.make, ROOT, styled(
    "colours:\n  background: '#14181C'\n  light_background: '#20262C'\n  text: '#E8EDF0'\n  secondary_text: '#B8C2C8'\n"
    .. "  lines: '#8A969E'\n  light_lines: '#3A444C'\n  accent: '#6FBF94'\n  block_fill: '#14181C'\n  state_fill: '#20262C'\n"
    .. "overrides:\n  colour:\n    accent_subtle: '#22332A'\n    warn_fg: '#F0B85A'\n    warn_bg: '#2E2615'\n    info_fg: '#8CC0F0'\n"
    .. "    info_bg: '#16222E'\n    error_fg: '#F08C8C'\n    error_bg: '#2E1616'\n  callouts:\n    note:\n      fill: bg_subtle")))
end

local function figures()
  local bad = {
    input = "\\input{/etc/passwd}",
    lua = "\\directlua{os.exit()}",
    shell = "\\immediate\\write18{x}",
    csname = "\\csname input\\endcsname{x}",
    hat = "^^5cinput{x}",
    catcode = "\\catcode`\\|=0",
    plot_file = "\\draw plot file {x};",
    split_word = "\\draw plot fi%\n   le {x};",
    gnuplot = "\\draw plot function{x};",
    prefix = "\\draw plot[prefix=../] (1,1);",
    library = "\\usetikzlibrary{external}",
    exec = "\\tikzset{/utils/exec={x}}",
    environment = "\\begin{filecontents}{x}",
  }
  for name, text in pairs(bad) do test("figure refuses " .. name, #F.check(text, name) > 0) end
  for _, f in ipairs({ "fig-evc", "fig-wave-evc", "fig-fsm-evc" }) do
    local p = F.check(U.read(ROOT .. "/tests/fixture/figures/" .. f .. ".tex"), f)
    test("figure accepts " .. f, #p == 0, table.concat(p, "; "))
  end
end

local RTL = [[
/* module ghost; endmodule */
package p; localparam int W = $clog2(16 + 1); endpackage
module leaf #(parameter N = 2) (input logic clk, input [N-1:0] a, b, output logic y);
  function logic f(input logic inner); return inner; endfunction
endmodule
module top (clk, a, y);
  input clk;
  input [1:0] a;
  output y;
  leaf u0 (.clk(clk), .a(a), .b(a), .y(y)), u1 (.*);
  generate if (1) begin : g
    leaf #(.N(2)) u2 (.*);
  end endgenerate
endmodule
]]

local function inventory_and_projects()
  local rtl = work .. "/rtl"
  U.write(rtl .. "/a.sv", RTL)
  local res = I.scan(rtl)
  test("a comment is no module", not res.by_name.ghost)
  test("a function argument is no port", #res.by_name.leaf.info.ports == 4)
  test("Verilog-1995 ports", #res.by_name.top.info.ports == 3)
  test("instances", #res.by_name.top.info.instances == 3)
  test("brackets in a value", res.by_name.p.info.params[1].value == "$clog2(16+1)")
  test("top found", table.concat(I.tops(res), ",") == "top")
  refuses("unknown top", function() I.markdown(res, "nothing") end)

  local dir = work .. "/created"
  P.create(ROOT, dir, { approach = "rtl", diagrams = "detailed", top = "top", input = rtl, title = "A & B", short = "AB", author = "T" })
  local p = P.load(ROOT, dir, true)
  test("created project", p.title == "A & B" and p.rtl_top == "top" and P.input_dir(p) == U.normalize(rtl), P.input_dir(p))
  refuses("create twice", function() P.create(ROOT, dir, { approach = "design-info" }) end)
  refuses("create inside specforge", function() P.create(ROOT, ROOT .. "/zz-project", { approach = "design-info" }) end)
  local input, notes = P.check_inputs(ROOT, p)
  test("inputs checked", input == U.normalize(rtl) and notes == nil)


end

local function arguments()
  local function same(name, line, want)
    local got = L.repair(line)
    test(name, got and table.concat(got, "\1") == table.concat(want, "\1"), got and table.concat(got, " | ") or "not recovered")
  end
  local exe = [["C:\Program Files\tex\texlua.exe" "C:\my tools\specforge.lua" ]]
  same("path ending in a backslash", exe .. [[new p --input "C:\my info\" --title "A & B"]],
    { "new", "p", "--input", "C:\\my info\\", "--title", "A & B" })
  same("last argument ends in a backslash", exe .. [[check "C:\my project\"]], { "check", "C:\\my project\\" })
  same("two such paths", exe .. [[new "D:\a b\" --input "D:\c d\" --short T]],
    { "new", "D:\\a b\\", "--input", "D:\\c d\\", "--short", "T" })
  same("a share", exe .. [[check "\\server\my share\spec\"]], { "check", "\\\\server\\my share\\spec\\" })
  same("backslashes doubled by the caller", exe .. [[check "C:\my project\\"]], { "check", "C:\\my project\\" })
  test("a real quote is not guessed", L.repair(exe .. [[new p --title "say \"hi\" now"]]) == nil)
  test("open quote is not guessed", L.repair(exe .. [[new "p]]) == nil)
end

local function command_line()
  dofile(here .. "/cli.lua")(U, test, work, ROOT)
end

-- The examples: the chapters are the same at both diagram levels, and every
-- example builds cleanly within its page maximum.
local function examples()
  for _, name in ipairs({ "arbiter", "packet-fifo" }) do
    local base = ROOT .. "/examples/" .. name
    local d, h = base .. "/specforge_output_detailed/chapters", base .. "/specforge_output_high-level/chapters"
    local same = #U.list(d) > 0 and #U.list(d) == #U.list(h)
    for _, f in ipairs(U.list(d)) do same = same and U.is_file(h .. "/" .. f) and U.read(d .. "/" .. f) == U.read(h .. "/" .. f) end
    test(name .. ": same chapters at both levels", same)
    for _, level in ipairs({ "detailed", "high-level" }) do
      local copy = work .. "/examples/" .. name
      local from = base .. "/specforge_output_" .. level
      for _, rel in ipairs(U.walk(from)) do
        if not rel:match("^build/") and not rel:match("^output/") then U.copy(from .. "/" .. rel, copy .. "/out_" .. level .. "/" .. rel) end
      end
      for _, rel in ipairs(U.walk(base)) do
        if rel:match("^project_") then U.copy(base .. "/" .. rel, copy .. "/" .. rel) end
      end
      local ok, err = pcall(B.run, ROOT, copy .. "/out_" .. level, { pdf = true, figures = false })
      test(name .. " " .. level .. " builds", ok, not ok and (type(err) == "table" and err.specforge or err) or nil)
    end
  end
end

local function full_build()
  local dir = fixture()
  B.run(ROOT, dir, { pdf = true, figures = U.which("pdftocairo") ~= nil })
  local pdf = dir .. "/output/EVC_Design_Specification.pdf"
  test("PDF built", U.is_file(pdf))
  local totext = U.which("pdftotext")
  if not totext then print("pdftotext not found: PDF text not checked"); return end
  U.run(totext, { "-enc", "UTF-8", pdf, work .. "/pdf.txt" })
  local t = U.read_bytes(work .. "/pdf.txt")
  for _, s in ipairs({ "duty_50%", "#(WIDTH)", "{msb,lsb}", "data}", "\\escaped.name", "ready | valid",
    "x}\\textbf{INJECTED", "$clog2(DEPTH)", "[row]", "Diagram level", "count_pkt", "COUNT", "event && !full / inc=1" }) do
    test("PDF shows " .. s, has(t, s))
  end
  test("no doubled hash", not has(t, "##"))
end

local ok, err = pcall(function()
  conversion()
  configuration()
  figures()
  inventory_and_projects()
  arguments()
  command_line()
  examples()
  full_build()
end)
U.remove_tempdir(tmp)
if not ok then
  failed = failed + 1
  print("FAIL suite stopped: " .. tostring(type(err) == "table" and err.specforge or err))
end
print(string.format("%d passed, %d failed", passed, failed))
os.exit(failed == 0 and 0 or 1)
