-- specforge -- RTL inventory for SystemVerilog and Verilog: a reading aid.
--
-- Works on tokens, with comments, strings and attributes removed. It does
-- not expand macros or `include, and evaluates no parameter or generate
-- condition: every item taken into an analysis is confirmed in the source.

return function(U)
  local I = {}

  local KEYWORDS = U.set({
    "module", "macromodule", "endmodule", "package", "endpackage", "interface", "endinterface",
    "program", "class", "function", "endfunction", "task", "endtask", "if", "else", "for", "foreach",
    "while", "repeat", "forever", "do", "case", "casez", "casex", "endcase", "begin", "end", "fork",
    "join", "assign", "always", "always_ff", "always_comb", "always_latch", "initial", "final",
    "return", "input", "output", "inout", "logic", "wire", "reg", "bit", "tri", "var", "int", "integer",
    "genvar", "parameter", "localparam", "typedef", "import", "export", "generate", "endgenerate",
    "assert", "assume", "cover", "property", "endproperty", "sequence", "endsequence", "unique",
    "unique0", "priority", "enum", "struct", "union", "modport", "default", "signed", "unsigned",
    "static", "automatic", "void", "wait", "disable", "defparam",
  })
  local DIRECTIONS = U.set({ "input", "output", "inout" })
  local PLAIN_TYPES = U.set({ "wire", "logic", "reg", "var", "bit", "tri" })
  local STATEMENT_START = U.set({ ";", ")", "begin", "end", "else", "generate", "endgenerate",
    "endcase", "endfunction", "endtask", "endproperty", "endsequence" })

  local function is_id(s) return s ~= nil and s:match("^[%a_\\`][%w_$]*") ~= nil and not KEYWORDS[s] end

  function I.tokens(text)
    local out, i, line, n = {}, 1, 1, #text
    local function newlines(s) local _, k = s:gsub("\n", ""); line = line + k end
    while i <= n do
      local c, two = text:sub(i, i), text:sub(i, i + 1)
      if c == "\n" then
        line, i = line + 1, i + 1
      elseif c:match("%s") then
        i = i + 1
      elseif two == "//" then
        i = text:find("\n", i, true) or n + 1
      elseif two == "/*" then
        local e = text:find("*/", i + 2, true)
        local stop = e and e + 1 or n
        newlines(text:sub(i, stop))
        i = stop + 1
      elseif two == "(*" and not text:match("^%(%*%s*%)", i) then
        local e = text:find("*)", i + 2, true)
        local stop = e and e + 1 or n
        newlines(text:sub(i, stop))
        i = stop + 1
      elseif c == '"' then
        local j = i + 1
        while j <= n and text:sub(j, j) ~= '"' and text:sub(j, j) ~= "\n" do
          j = j + (text:sub(j, j) == "\\" and 2 or 1)
        end
        out[#out + 1] = { s = text:sub(i, j), line = line }
        i = j + 1
      else
        local word = text:match("^[%a_$`][%w_$]*", i) or text:match("^\\%S+", i)
          or text:match("^%d*'[sS]?[bBoOdDhH][%x_xXzZ?]+", i) or text:match("^%d[%w_.]*", i)
          or (two == "::" and two) or c
        out[#out + 1] = { s = word, line = line }
        i = i + #word
      end
    end
    return out
  end

  -- Index of the bracket that closes the one at i.
  local function matching(t, i, last)
    local depth = 0
    for j = i, last do
      local s = t[j].s
      if s == "(" or s == "[" or s == "{" then depth = depth + 1
      elseif s == ")" or s == "]" or s == "}" then
        depth = depth - 1
        if depth == 0 then return j end
      end
    end
    return last
  end

  -- Parts of t[a..b] between top-level commas.
  local function parts(t, a, b)
    local out, from, i = {}, a, a
    while i <= b do
      local s = t[i].s
      if s == "(" or s == "[" or s == "{" then i = matching(t, i, b)
      elseif s == "," then out[#out + 1] = { from, i - 1 }; from = i + 1 end
      i = i + 1
    end
    if from <= b then out[#out + 1] = { from, b } end
    return out
  end

  local function joined(t, a, b)
    local out, prev = {}, nil
    for i = a, b do
      local s = t[i].s
      if prev and prev:match("[%w_$]$") and s:match("^[%w_$]") then out[#out + 1] = " " end
      out[#out + 1] = s
      prev = s
    end
    return table.concat(out)
  end

  local function statement_end(t, i, last)
    while i <= last do
      local s = t[i].s
      if s == "(" or s == "[" or s == "{" then i = matching(t, i, last)
      elseif s == ";" then return i end
      i = i + 1
    end
    return last + 1
  end

  -- Last identifier outside brackets, before an '='.
  local function declared_name(t, a, b)
    local at, i = nil, a
    while i <= b do
      local s = t[i].s
      if s == "=" then break end
      if s == "(" or s == "[" or s == "{" then i = matching(t, i, b)
      elseif is_id(s) then at = i end
      i = i + 1
    end
    return at
  end

  local function read_ports(t, a, b, info)
    local dir, width
    for _, part in ipairs(parts(t, a, b)) do
      local x, y = part[1], part[2]
      if x <= y then
        local has_dir = DIRECTIONS[t[x].s]
        local from = has_dir and x + 1 or x
        local name = declared_name(t, from, y)
        if name then
          if has_dir or name > from then
            local lead = from
            while lead < name and PLAIN_TYPES[t[lead].s] do lead = lead + 1 end
            width = lead < name and joined(t, lead, name - 1) or "1"
            dir = has_dir and t[x].s or (name > from and t[from].s ~= "[" and "interface" or dir)
          end
          if dir then
            local shown = width
            if t[name + 1] and name < y and t[name + 1].s == "[" then shown = width .. " " .. joined(t, name + 1, y) end
            info.ports[#info.ports + 1] = { dir = dir, name = t[name].s, width = shown, line = t[name].line }
          end
        end
      end
    end
  end

  local function read_params(t, a, b, kind, info)
    for _, part in ipairs(parts(t, a, b)) do
      local x, y = part[1], part[2]
      if t[x] and (t[x].s == "parameter" or t[x].s == "localparam") then kind = t[x].s; x = x + 1 end
      local name = declared_name(t, x, y)
      if name then
        local eq = name + 1
        while eq <= y and t[eq].s ~= "=" do eq = eq + 1 end
        info.params[#info.params + 1] = {
          kind = kind, name = t[name].s, line = t[name].line,
          value = eq < y and joined(t, eq + 1, y) or "(no default)",
        }
      end
    end
  end

  -- One or more instances starting at i; returns the index of the ';'.
  local function read_instances(t, i, last, info)
    local kind, j = t[i].s, i + 1
    if t[j] and t[j].s == "#" and t[j + 1] and t[j + 1].s == "(" then j = matching(t, j + 1, last) + 1 end
    local found = {}
    while t[j] and j <= last and is_id(t[j].s) do
      local name = t[j]
      j = j + 1
      while t[j] and t[j].s == "[" do j = matching(t, j, last) + 1 end
      if not t[j] or t[j].s ~= "(" then return nil end
      j = matching(t, j, last) + 1
      -- the line of the instance is the line its declaration starts on
      found[#found + 1] = { type = kind, name = name.s, line = #found == 0 and t[i].line or name.line }
      if not t[j] then return nil end
      if t[j].s == ";" then
        for _, f in ipairs(found) do info.instances[#info.instances + 1] = f end
        return j
      end
      if t[j].s ~= "," then return nil end
      j = j + 1
    end
    return nil
  end

  local function read_unit(t, u)
    local info = { ports = {}, params = {}, instances = {}, clocks = {}, enums = {}, arrays = {} }
    local i, last = u.name_at + 1, u.last
    if u.kind == "package" then
      i = statement_end(t, i, last) + 1
    else
      while i <= last and t[i].s ~= ";" do
        if t[i].s == "#" and t[i + 1] and t[i + 1].s == "(" then
          local e = matching(t, i + 1, last)
          read_params(t, i + 2, e - 1, "parameter", info)
          i = e
        elseif t[i].s == "(" then
          local e = matching(t, i, last)
          -- a Verilog-1995 header lists names only; the body has the directions
          read_ports(t, i + 1, e - 1, info)
          i = e
        end
        i = i + 1
      end
      i = i + 1
    end

    local routine = 0
    while i <= last do
      local s, nxt = t[i].s, t[i + 1] and t[i + 1].s
      local prev = t[i - 1].s
      if (s == "function" or s == "task") and prev ~= "import" and prev ~= "extern" then
        routine = routine + 1
      elseif s == "endfunction" or s == "endtask" then
        routine = math.max(0, routine - 1)
      elseif routine == 0 then
        if DIRECTIONS[s] then
          local e = statement_end(t, i, last)
          read_ports(t, i, e - 1, info)
          i = e
        elseif s == "parameter" or s == "localparam" then
          local e = statement_end(t, i, last)
          read_params(t, i + 1, e - 1, s, info)
          i = e
        elseif (s == "always_ff" or s == "always") and nxt == "@" and t[i + 2] and t[i + 2].s == "(" then
          local e = matching(t, i + 2, last)
          local sens = joined(t, i + 3, e - 1)
          if sens:find("edge") then info.clocks[#info.clocks + 1] = { sens = sens, line = t[i].line } end
          i = e
        elseif s == "enum" then
          local j = i + 1
          while j <= last and t[j].s ~= "{" and t[j].s ~= ";" do j = j + 1 end
          if t[j] and t[j].s == "{" then
            local e, values = matching(t, j, last), {}
            for _, part in ipairs(parts(t, j + 1, e - 1)) do values[#values + 1] = joined(t, part[1], part[2]) end
            info.enums[#info.enums + 1] = { line = t[i].line, values = table.concat(values, ", "),
              name = t[e + 1] and t[e + 1].s or "(unnamed)" }
            i = e
          end
        elseif (s == "logic" or s == "reg" or s == "bit" or s == "wire") and prev ~= "enum" then
          local e = statement_end(t, i, last)
          for _, part in ipairs(parts(t, i + 1, e - 1)) do
            local name = declared_name(t, part[1], part[2])
            if name and name < part[2] and t[name + 1].s == "[" then
              local dims, j = {}, name + 1
              while j <= part[2] and t[j].s == "[" do
                local k = matching(t, j, part[2])
                dims[#dims + 1] = joined(t, j, k)
                j = k + 1
              end
              info.arrays[#info.arrays + 1] = { name = t[name].s, dims = table.concat(dims), line = t[name].line }
            end
          end
          i = e
        elseif is_id(s) and (STATEMENT_START[prev] or prev == ":" or (t[i - 2] and t[i - 2].s == ":")) then
          i = read_instances(t, i, last, info) or i
        end
      end
      i = i + 1
    end
    return info
  end

  function I.scan(dir)
    local files = U.walk(dir, "%.s?vh?$")
    if #files == 0 then U.fail("no RTL files (*.sv, *.svh, *.v, *.vh) in %s", dir) end
    local res = { dir = dir, units = {}, by_name = {}, directives = {}, duplicates = {} }
    local ends = { module = "endmodule", macromodule = "endmodule", package = "endpackage", interface = "endinterface" }
    for _, file in ipairs(files) do
      local t = I.tokens(U.read(dir .. "/" .. file))
      local i = 1
      while i <= #t do
        local s, prev = t[i].s, i > 1 and t[i - 1].s or ""
        if s == "`include" or s == "`define" or s == "`ifdef" or s == "`ifndef" then
          res.directives[#res.directives + 1] = {
            what = s .. " " .. (t[i + 1] and t[i + 1].s or ""), file = file, line = t[i].line,
          }
        end
        if ends[s] and prev ~= "virtual" and prev ~= "extern" and t[i + 1] then
          local at = i + 1
          if t[at].s == "automatic" or t[at].s == "static" then at = at + 1 end
          if t[at] and is_id(t[at].s) then
            local last = at
            while last < #t and t[last].s ~= ends[s] do
              last = last + 1
              local d = t[last].s
              if d == "`include" or d == "`define" or d == "`ifdef" or d == "`ifndef" then
                res.directives[#res.directives + 1] = {
                  what = d .. " " .. (t[last + 1] and t[last + 1].s or ""), file = file, line = t[last].line,
                }
              end
            end
            local u = { kind = s == "macromodule" and "module" or s, name = t[at].s, file = file,
              line = t[i].line, name_at = at, last = last - 1 }
            u.info = read_unit(t, u)
            if res.by_name[u.name] then res.duplicates[#res.duplicates + 1] = u
            else res.by_name[u.name] = u; res.units[#res.units + 1] = u end
            i = last
          end
        end
        i = i + 1
      end
    end
    return res
  end

  function I.check_top(res, top, dir)
    local u = res.by_name[top]
    if u and u.kind == "module" then return end
    if u then U.fail("the top '%s' is a %s, not a module", top, u.kind) end
    local names = {}
    for _, m in ipairs(res.units) do
      if m.kind == "module" and #names < 20 then names[#names + 1] = m.name end
    end
    U.fail("top module '%s' not found in %s (modules there: %s)", top, dir or res.dir,
      #names > 0 and table.concat(names, ", ") or "none")
  end

  function I.markdown(res, top)
    I.check_top(res, top)
    local out = {}
    local function add(s) out[#out + 1] = s end
    local function tick(s) return "`" .. tostring(s):gsub("|", "\\|") .. "`" end
    local function at(u, line) return u.file .. ":" .. (line or u.line) end

    add("# RTL inventory")
    add("")
    add("Generated by specforge for top " .. tick(top) .. ". A reading aid: confirm every item in the source.")
    add("")
    add("## Files and units")
    add("")
    add("| Unit | Kind | File:line |")
    add("|---|---|---|")
    for _, u in ipairs(res.units) do add("| " .. tick(u.name) .. " | " .. u.kind .. " | " .. at(u) .. " |") end
    add("")
    for _, u in ipairs(res.duplicates) do
      add("Defined more than once (the first definition is used): " .. tick(u.name) .. " at " .. at(u))
      add("")
    end

    add("## Hierarchy")
    add("")
    add("- " .. tick(top) .. " -- " .. at(res.by_name[top]))
    local in_tree, tree, external, ext_seen = {}, {}, {}, {}
    local function visit(name, indent, path)
      local u = res.by_name[name]
      if not in_tree[name] then in_tree[name] = true; tree[#tree + 1] = u end
      path[name] = true
      for _, inst in ipairs(u.info.instances) do
        local child = res.by_name[inst.type]
        local row = indent .. "- " .. tick(inst.name) .. " : " .. tick(inst.type)
        if child then
          add(row .. " -- " .. at(u, inst.line))
          if path[inst.type] then add(indent .. "  - (recursive instance)") else visit(inst.type, indent .. "  ", path) end
        else
          add(row .. " (not found in the RTL folder) -- " .. at(u, inst.line))
          if not ext_seen[inst.type] then ext_seen[inst.type] = true; external[#external + 1] = tick(inst.type) end
        end
      end
      path[name] = nil
    end
    visit(top, "  ", {})
    add("")

    local unused = {}
    for _, u in ipairs(res.units) do
      if u.kind == "module" and not in_tree[u.name] then unused[#unused + 1] = tick(u.name) end
      if u.kind == "package" then tree[#tree + 1] = u end
    end
    if #unused > 0 then add("Modules not under the top: " .. table.concat(unused, ", ")); add("") end
    if #external > 0 then
      add("Instantiated types not found (external IP, primitives or misdetections): " .. table.concat(external, ", "))
      add("")
    end
    if #res.directives > 0 then
      add("## Preprocessor directives (not evaluated)")
      add("")
      for _, d in ipairs(res.directives) do add("- " .. tick(d.what) .. " -- " .. d.file .. ":" .. d.line) end
      add("")
    end

    for _, u in ipairs(tree) do
      local x = u.info
      add("## " .. u.kind .. " " .. tick(u.name) .. " (" .. at(u) .. ")")
      add("")
      if #x.ports > 0 then
        add("| Port | Direction | Type / width | Line |")
        add("|---|---|---|---|")
        for _, p in ipairs(x.ports) do add("| " .. tick(p.name) .. " | " .. p.dir .. " | " .. tick(p.width) .. " | " .. p.line .. " |") end
        add("")
      end
      if #x.params > 0 then
        add("| Parameter | Kind | Value | Line |")
        add("|---|---|---|---|")
        for _, p in ipairs(x.params) do add("| " .. tick(p.name) .. " | " .. p.kind .. " | " .. tick(p.value) .. " | " .. p.line .. " |") end
        add("")
      end
      if #x.clocks > 0 then
        add("Sequential blocks (sensitivity):")
        for _, c in ipairs(x.clocks) do add("- " .. tick("@(" .. c.sens .. ")") .. " at line " .. c.line) end
        add("")
      end
      if #x.enums > 0 then
        add("Enumerated types (possible state machines):")
        for _, e in ipairs(x.enums) do add("- " .. tick(e.name) .. " = { " .. e.values .. " } -- line " .. e.line) end
        add("")
      end
      if #x.arrays > 0 then
        add("Arrays (possible storage):")
        for _, a in ipairs(x.arrays) do add("- " .. tick(a.name) .. " " .. tick(a.dims) .. " -- line " .. a.line) end
        add("")
      end
    end
    return table.concat(out, "\n") .. "\n"
  end

  return I
end
