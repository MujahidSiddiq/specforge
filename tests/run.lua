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
local H = module("chat", U, P, I, F)
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
  refuses("diagram level needed for a build", function() P.load(ROOT, level('diagrams: ""'), true) end)
  test("diagram level may wait until the build", P.load(ROOT, level('diagrams: ""'), false).diagrams == nil)
  test("0.2 projects keep a given level", P.load(ROOT, typed("high-level-spec"), true).diagrams == "detailed")
  refuses("font injection", style("  fonts:\n    main: 'X}\\input{y}'"))
  refuses("font size injection", style("  captions:\n    font_size: 'small\\input{y}'"))
  refuses("separator injection", style("  captions:\n    label_separator: 'x}\\input{y}'"))
  refuses("unknown style key", style("  colour:\n    no_such_key: 1"))
  test("accent override", pcall(style("  colour:\n    accent_primary: '#2F5D8A'")))
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
  refuses("unknown top", function() I.markdown(res, "nothing") end)

  local dir = work .. "/created"
  P.create(ROOT, dir, { approach = "rtl", diagrams = "detailed", top = "top", input = rtl, title = "A & B", short = "AB", author = "T" })
  local p = P.load(ROOT, dir, true)
  test("created project", p.title == "A & B" and p.rtl_top == "top" and P.input_dir(p) == U.normalize(rtl), P.input_dir(p))
  refuses("create twice", function() P.create(ROOT, dir, { approach = "design-info" }) end)
  refuses("create inside specforge", function() P.create(ROOT, ROOT .. "/zz-project", { approach = "design-info" }) end)

  local pack, count = H.pack(ROOT, dir, true)
  test("pack has numbered RTL", count == 1 and has(pack, "    1| ") and has(pack, "rtl-inventory.md"))

  local function answer(path, body)
    local f = work .. "/answer.txt"
    U.write(f, "text\n````\n===== BEGIN FILE: " .. path .. " =====\n" .. body .. "\n===== END FILE =====\n````\n")
    return f
  end
  for _, path in ipairs({ "../x.md", "chapters/../../x.md", "C:/x.md", "build/main.tex", "CLAUDE.md", ".git/config" }) do
    refuses("unpack " .. path, function() H.unpack(dir, answer(path, "x")) end)
  end
  refuses("unpack bad figure", function() H.unpack(dir, answer("figures/fig-x.tex", "\\directlua{}")) end)
  H.unpack(dir, answer("chapters/01_intro.md", "# 1. Intro"))
  test("unpack writes", U.read(dir .. "/chapters/01_intro.md") == "# 1. Intro\n")
  U.write(work .. "/cut.txt", "===== BEGIN FILE: status.md =====\nhalf")
  refuses("unpack cut-off answer", function() H.unpack(dir, work .. "/cut.txt") end)
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
  full_build()
end)
U.remove_tempdir(tmp)
if not ok then
  failed = failed + 1
  print("FAIL suite stopped: " .. tostring(type(err) == "table" and err.specforge or err))
end
print(string.format("%d passed, %d failed", passed, failed))
os.exit(failed == 0 and 0 or 1)
