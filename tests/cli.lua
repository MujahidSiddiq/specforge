-- Tests of the command line, each command as its own process.
-- Called by tests/run.lua.

return function(U, test, work, ROOT)
  local texlua = U.which("texlua")
  if not texlua then U.fail("texlua not found") end
  local base = work .. "/cli"
  local serial = 0

  local function run(...)
    return U.run(texlua, { ROOT .. "/tools/specforge.lua", ... }, work)
  end
  local function fresh()
    serial = serial + 1
    local dir = base .. "/case " .. serial
    U.mkdir(dir)
    return dir
  end
  -- The command fails and creates no project.
  local function refused(name, project, code)
    test(name .. ": refused", code ~= 0, "exit code 0")
    test(name .. ": nothing created", not U.is_file(project .. "/project.md"))
  end

  U.write(base .. "/info/a.md", "# A\n")
  U.write(base .. "/rtl/a.sv", "package a_pkg; endpackage\nmodule top(input clk); endmodule\n")
  U.write(base .. "/empty/notes.txt", "not Markdown\n")
  local info, rtl = base .. "/info", base .. "/rtl"

  -- bugs 1 and 2: no launcher that hands the arguments to a shell
  test("no batch launcher", #U.list(ROOT, "%.[cC][mM][dD]$") == 0 and #U.list(ROOT, "%.[bB][aA][tT]$") == 0)
  if U.windows then
    local d = fresh() .. "/p"
    local code = run("new", d, "--approach", "design-info", "--title", "A&B %OS% C^D E|F G>H", "--short", "T", "--author", "T")
    test("special characters kept", code == 0 and U.read(d .. "/project.md"):find('title: "A&B %OS% C^D E|F G>H"', 1, true))
  end

  -- bug 3: a lost empty value must not take the next option
  local p = fresh() .. "/p"
  refused("option as a value", p, run("new", p, "--approach", "design-info", "--title", "--short", "T", "--author", "T"))
  p = fresh() .. "/p"
  refused("blank value", p, run("new", p, "--approach", "design-info", "--title", " ", "--short", "T"))
  p = fresh() .. "/p"
  refused("extra value", p, run("new", p, "--approach", "design-info", "--title", "A", "B"))
  p = fresh() .. "/p"
  refused("option given twice", p, run("new", p, "--approach", "design-info", "--title", "A", "--title", "B"))

  -- bug 5: the project and the inputs are separate
  local d = fresh()
  U.write(d .. "/a.md", "# A\n")
  p = d .. "/spec"
  refused("input contains the project", p, run("new", p, "--approach", "design-info", "--input", d))
  d = fresh()
  U.write(d .. "/a.md", "# A\n")
  refused("input is the project", d, run("new", d, "--approach", "design-info", "--input", d))
  d = fresh()
  U.write(d .. "/build/a.md", "# A\n")
  refused("input is the build folder", d, run("new", d, "--approach", "design-info", "--input", d .. "/build"))

  local function configured(approach, key, value, top)
    local dir = fresh() .. "/spec"
    local code
    if approach == "rtl" then code = run("new", dir, "--approach", "rtl", "--input", rtl, "--top", top, "--title", "T", "--short", "T", "--author", "T")
    else code = run("new", dir, "--approach", "design-info", "--input", info, "--title", "T", "--short", "T", "--author", "T") end
    test("valid project is created (" .. approach .. ")", code == 0)
    local text = U.read(dir .. "/project.md"):gsub("\n  " .. key .. ":[^\n]*", "\n  " .. key .. ": " .. value, 1)
    U.write(dir .. "/project.md", text)
    return dir
  end
  local function no_pack(name, dir)
    test(name .. ": refused", run("chat-pack", dir) ~= 0, "exit code 0")
    test(name .. ": no pack written", not U.is_file(dir .. "/build/chat-pack.md"))
  end
  no_pack("pack of the project's parent", configured("design-info", "design_info", '".."'))
  no_pack("pack of the project itself", configured("design-info", "design_info", '"."'))
  no_pack("pack of notes that contain the project", configured("rtl", "notes", '".."', "top"))

  d = fresh()
  U.write(d .. "/all/a.md", "# A\n")
  U.write(d .. "/all/other/project.md", '```yaml\nspecforge_version: "0.2.0"\n```\n')
  p = d .. "/spec"
  refused("input contains another project", p, run("new", p, "--approach", "design-info", "--input", d .. "/all"))

  -- bug 6: bad inputs stop at once
  p = fresh() .. "/p"
  refused("input does not exist", p, run("new", p, "--approach", "design-info", "--input", base .. "/no-such-folder"))
  p = fresh() .. "/p"
  refused("input is a file", p, run("new", p, "--approach", "design-info", "--input", info .. "/a.md"))
  p = fresh() .. "/p"
  refused("no Markdown", p, run("new", p, "--approach", "design-info", "--input", base .. "/empty"))
  p = fresh() .. "/p"
  refused("no RTL", p, run("new", p, "--approach", "rtl", "--top", "top", "--input", base .. "/empty"))
  p = fresh() .. "/p"
  refused("wrong top", p, run("new", p, "--approach", "rtl", "--top", "wrong", "--input", rtl))
  p = fresh() .. "/p"
  refused("top is a package", p, run("new", p, "--approach", "rtl", "--top", "a_pkg", "--input", rtl))
  p = fresh() .. "/p"
  refused("notes do not exist", p, run("new", p, "--approach", "rtl", "--top", "top", "--input", rtl, "--notes", base .. "/none"))
  no_pack("pack with a wrong notes path", configured("rtl", "notes", '"../no-such-notes"', "top"))
  no_pack("pack with zero inputs", configured("design-info", "design_info", '"../../empty"'))
  no_pack("pack with a wrong top", configured("rtl", "rtl_top", '"wrong"', "top"))

  -- the diagram level
  p = fresh() .. "/p"
  refused("unknown --diagrams", p, run("new", p, "--approach", "design-info", "--diagrams", "medium"))
  p = fresh() .. "/p"
  test("--diagrams is written", run("new", p, "--approach", "design-info", "--diagrams", "high-level") == 0
    and U.read(p .. "/project.md"):find('\ndiagrams: "high-level"', 1, true))

  -- the page maximum
  p = fresh() .. "/p"
  refused("--pages not a number", p, run("new", p, "--approach", "design-info", "--pages", "ten"))
  p = fresh() .. "/p"
  refused("--pages zero", p, run("new", p, "--approach", "design-info", "--pages", "0"))
  p = fresh() .. "/p"
  test("--pages is written", run("new", p, "--approach", "design-info", "--pages", "12") == 0
    and U.read(p .. "/project.md"):find("\n  max: 12", 1, true))

  -- the folder layout: <workspace>/specforge, project_rtl or project_description
  local function workspace(parts)
    local ws = fresh() .. "/ws"
    for rel, text in pairs(parts) do U.write(ws .. "/" .. rel, text) end
    return ws
  end
  local function has(dir, text) return U.is_file(dir .. "/project.md") and U.read(dir .. "/project.md"):find(text, 1, true) end

  local ws = workspace({ ["project_description/a.md"] = "# A\n" })
  test("description found", run("new", ws .. "/specforge_output") == 0
    and has(ws .. "/specforge_output", 'approach: "design-info"') and has(ws .. "/specforge_output", 'design_info: "../project_description/"'))

  ws = workspace({ ["project_rtl/a.sv"] = "module leaf(input a); endmodule\nmodule top(input a); leaf u(.a(a)); endmodule\n" })
  test("RTL and its top found", run("new", ws .. "/specforge_output") == 0
    and has(ws .. "/specforge_output", 'rtl_top: "top"') and has(ws .. "/specforge_output", 'rtl: "../project_rtl/"'))

  ws = workspace({ ["project_rtl/a.sv"] = "module top(input a); endmodule\n",
    ["project_rtl/tb/tb.sv"] = "module tb; top dut(.a(1'b0)); endmodule\n", ["project_description/intent.md"] = "# Intent\n" })
  test("RTL with notes, test bench ignored", run("new", ws .. "/specforge_output") == 0
    and has(ws .. "/specforge_output", 'rtl_top: "top"') and has(ws .. "/specforge_output", 'notes: "../project_description/"'))

  ws = workspace({ ["project_rtl/a.sv"] = "module one(input a); endmodule\nmodule two(input a); endmodule\n" })
  refused("two possible tops", ws .. "/specforge_output", run("new", ws .. "/specforge_output"))
  test("a given top is used", run("new", ws .. "/specforge_output", "--top", "two") == 0 and has(ws .. "/specforge_output", 'rtl_top: "two"'))

  ws = workspace({ ["other/a.md"] = "# A\n" })
  refused("nothing to find", ws .. "/specforge_output", run("new", ws .. "/specforge_output"))

  -- without a project folder: specforge_output next to the specforge folder
  ws = workspace({ ["project_description/a.md"] = "# A\n" })
  for _, part in ipairs({ "VERSION", "tools", "config-templates", "templates", "styles" }) do
    if U.is_file(ROOT .. "/" .. part) then U.copy(ROOT .. "/" .. part, ws .. "/specforge/" .. part)
    else for _, rel in ipairs(U.walk(ROOT .. "/" .. part)) do U.copy(ROOT .. "/" .. part .. "/" .. rel, ws .. "/specforge/" .. part .. "/" .. rel) end end
  end
  local code = U.run(texlua, { ws .. "/specforge/tools/specforge.lua", "new", "--diagrams", "detailed", "--pages", "12" }, ws)
  test("default project folder", code == 0 and has(ws .. "/specforge_output", 'design_info: "../project_description/"')
    and has(ws .. "/specforge_output", "max: 12") and has(ws .. "/specforge_output", 'diagrams: "detailed"'))

  -- what worked must still work
  p = fresh() .. "/p"
  test("default inputs folder", run("new", p, "--approach", "design-info", "--title", "T", "--short", "T", "--author", "T") == 0
    and U.is_dir(p .. "/inputs"))
  U.write(p .. "/inputs/a.md", "# A\n")
  test("pack of the default folder", run("chat-pack", p) == 0 and U.is_file(p .. "/build/chat-pack.md"))
  d = fresh()
  U.write(d .. "/design/a.md", "# A\n")
  test("sibling input", run("new", d .. "/design-spec", "--approach", "design-info", "--input", d .. "/design") == 0)
end
