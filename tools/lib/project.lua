-- specforge -- project folders: create, read and check project.md.

return function(U, Y, I)
  local P = {}

  P.APPROACHES = U.set({ "design-info", "rtl" })

  P.DIAGRAMS = U.set({ "detailed", "high-level" })

  -- document_type -> defaults; high-level-spec is the name used by 0.2.
  P.TYPES = {
    ["design-spec"] = { subtitle = "Design Specification", file = "_Design_Specification" },
    ["high-level-spec"] = { subtitle = "High-Level Specification", file = "_High-Level_Specification" },
  }

  function P.version(root) return U.trim(U.split(U.read(root .. "/VERSION"), "\n")[1]) end

  local function text(cfg, key, default)
    local v = cfg.value[key]
    if v == nil or v == "" then return default end
    if type(v) == "table" then U.fail("project.md: %s must be a single value", key) end
    return tostring(v)
  end

  -- strict: also require the document information (needed for a build).
  function P.load(root, dir, strict)
    local file = dir .. "/project.md"
    if not U.is_file(file) then U.fail("%s has no project.md: create the project with 'specforge new'", dir) end
    local cfg = Y.read(file, false)
    local p = {
      dir = dir,
      version = text(cfg, "specforge_version"),
      type = text(cfg, "document_type", ""),
      approach = text(cfg, "approach", ""),
      diagrams = text(cfg, "diagrams"),
      design_info = text(cfg, "inputs.design_info", "inputs/"),
      rtl = text(cfg, "inputs.rtl", "inputs/rtl/"),
      rtl_top = text(cfg, "inputs.rtl_top"),
      notes = text(cfg, "inputs.notes", "inputs/notes/"),
      out = text(cfg, "output.dir", "output"),
      file_name = text(cfg, "output.file_name"),
      combined = cfg.value["output.combined_markdown"] ~= false,
      title = text(cfg, "document.title"),
      short_name = text(cfg, "document.short_name"),
      subtitle = text(cfg, "document.subtitle"),
      author = text(cfg, "document.author"),
      organization = text(cfg, "document.organization", ""),
      revision = text(cfg, "document.revision", "0.1"),
      status = text(cfg, "document.status", "Draft"),
      date = text(cfg, "document.date"),
      language = text(cfg, "document.language", "en-GB"),
      min_pages = tonumber(text(cfg, "page_budget.min", "1")),
      max_pages = tonumber(text(cfg, "page_budget.max", "15")),
      related = {},
    }

    local rel = cfg.value["document.related_documents"]
    if type(rel) == "table" then
      for _, r in ipairs(rel) do if r ~= "" then p.related[#p.related + 1] = tostring(r) end end
    elseif type(rel) == "string" and rel ~= "" then
      p.related[1] = rel
    end

    local bad = {}
    local kind = P.TYPES[p.type]
    if not kind then bad[#bad + 1] = "document_type must be design-spec (is '" .. p.type .. "')" end
    kind = kind or P.TYPES["design-spec"]
    p.subtitle = p.subtitle or kind.subtitle
    -- a 0.2 project has no diagram level; its document stays as it was
    p.diagrams_shown = p.diagrams ~= nil
    if p.type == "high-level-spec" then p.diagrams = p.diagrams or "high-level" end
    if p.diagrams and not P.DIAGRAMS[p.diagrams] then
      bad[#bad + 1] = "diagrams must be detailed or high-level (is '" .. p.diagrams .. "')"
    elseif strict and not p.diagrams then
      bad[#bad + 1] = "diagrams is empty: set detailed or high-level"
    end
    if not P.APPROACHES[p.approach] then bad[#bad + 1] = "approach must be design-info or rtl (is '" .. p.approach .. "')" end
    if p.approach == "rtl" and not p.rtl_top then bad[#bad + 1] = "inputs.rtl_top is empty (required for rtl)" end
    if not p.min_pages or not p.max_pages or p.max_pages < 1 or p.max_pages ~= math.floor(p.max_pages) then
      bad[#bad + 1] = "page_budget.max must be a whole number of pages"
    end
    if not p.language:match("^[%a%d%-]+$") then bad[#bad + 1] = "document.language must be a language tag such as en-GB" end
    if strict then
      for _, k in ipairs({ "title", "short_name", "author" }) do
        if not p[k] then bad[#bad + 1] = "document." .. k .. " is empty" end
      end
    end

    -- project.md may come from someone else: output stays inside the project
    p.out_dir = U.join(dir, p.out)
    if U.is_absolute(p.out) or not U.inside(p.out_dir, dir) then
      bad[#bad + 1] = "output.dir must be a folder inside the project"
    end
    p.file_name = p.file_name or ((p.short_name or "Document") .. kind.file)
    if p.file_name:find('[/\\:*?"<>|%c]') or p.file_name:match("^%.") then
      bad[#bad + 1] = "output.file_name (or short_name) has characters a file name cannot have"
    end

    if #bad > 0 then U.fail("project.md: " .. table.concat(bad, "; ")) end

    local current = P.version(root)
    if p.version and p.version ~= current then
      U.warn(string.format("project.md was set up for specforge %s; this is specforge %s. Check CHANGELOG.md.", p.version, current))
    end
    return p
  end

  -- The folder of the approach's main input.
  function P.input_dir(p)
    return U.join(p.dir, p.approach == "rtl" and p.rtl or p.design_info)
  end

  local KINDS = {
    ["design-info"] = { name = "input", pattern = "%.md$", what = "Markdown files (*.md)" },
    rtl = { name = "input", pattern = "%.s?vh?$", what = "RTL files (*.sv, *.svh, *.v, *.vh)" },
    notes = { name = "notes", pattern = "%.md$" },
  }

  -- Stops on an input or notes folder that is missing, empty or not separate
  -- from the project: the AI reads everything in it as design input, so it
  -- must never hold project files.
  function P.check_folder(root, dir, folder, kind, out_dir)
    local k = KINDS[kind]
    if U.is_file(folder) then U.fail("the %s must be a folder, and this is a file: %s", k.name, folder) end
    if not U.is_dir(folder) then U.fail("the %s folder does not exist: %s", k.name, folder) end

    if U.same(folder, dir) or U.inside(dir, folder) then
      U.fail("the %s folder contains the project: %s. Keep design files in their own folder, next to the project", k.name, folder)
    end
    local own = { dir .. "/build", dir .. "/chapters", dir .. "/figures", out_dir or dir .. "/output" }
    for _, d in ipairs(own) do
      if U.same(folder, d) or U.inside(folder, d) then
        U.fail("the %s folder is a folder that specforge writes to: %s", k.name, folder)
      end
    end
    if U.same(folder, root) or U.inside(root, folder) then
      U.fail("the %s folder contains specforge itself: %s", k.name, folder)
    end
    -- also found this way: another project, or this one reached by a different path
    for _, rel in ipairs(U.walk(folder, "project%.md$")) do
      if U.basename(rel):lower() == "project.md" and U.read(folder .. "/" .. rel):find("\nspecforge_version:") then
        U.fail("the %s folder contains a specforge project (%s/%s). Keep design files in their own folder", k.name, folder, rel)
      end
    end

    local files = U.walk(folder, k.pattern)
    if #files == 0 and k.what then U.fail("no %s in the input folder %s", k.what, folder) end
    for _, rel in ipairs(files) do U.read(folder .. "/" .. rel) end -- every file must be readable text
  end

  -- The folders of an existing project, checked.
  function P.check_inputs(root, p)
    local input = P.input_dir(p)
    P.check_folder(root, p.dir, input, p.approach, p.out_dir)
    local notes
    if p.approach == "rtl" then
      I.check_top(I.scan(input), p.rtl_top, input)
      local folder = U.join(p.dir, p.notes)
      local unused = U.same(folder, U.join(p.dir, "inputs/notes")) and not U.is_dir(folder)
      if not unused then
        P.check_folder(root, p.dir, folder, "notes", p.out_dir)
        notes = folder
      end
    end
    return input, notes
  end

  P.LAYOUT = { rtl = "project_rtl", ["design-info"] = "project_description", output = "specforge_output" }

  -- Fills approach, input, notes and top from the folders next to the
  -- project when they are not given:
  --   <workspace>/project_rtl/          RTL (the top module is found)
  --   <workspace>/project_description/  Markdown; with RTL, the intent notes
  -- Returns lines that say what was found.
  function P.detect(dir, o)
    local parent = U.dirname(dir)
    local rtl, desc = parent .. "/" .. P.LAYOUT.rtl, parent .. "/" .. P.LAYOUT["design-info"]
    local said = {}
    if not o.approach and not o.input then
      if U.is_dir(rtl) then
        o.approach, o.input = "rtl", rtl
        if U.is_dir(desc) and not o.notes then o.notes = desc end
      elseif U.is_dir(desc) then
        o.approach, o.input = "design-info", desc
      else
        U.fail("give --approach, or put the RTL in %s or the Markdown description in %s", rtl, desc)
      end
      said[#said + 1] = "Found " .. U.basename(o.input) .. ": approach " .. o.approach
        .. (o.notes and ", with " .. U.basename(o.notes) .. " as notes on purpose and intent" or "")
    elseif o.approach and not o.input then
      local folder = parent .. "/" .. (P.LAYOUT[o.approach] or "")
      if U.is_dir(folder) then
        o.input = folder
        said[#said + 1] = "Found " .. U.basename(folder)
      end
    end
    if o.approach == "rtl" and o.input and not o.top then
      local folder = U.abs(o.input)
      if U.is_dir(folder) then
        local tops = I.tops(I.scan(folder))
        if #tops ~= 1 then
          U.fail("give --top: the top module could be %s", #tops > 0 and table.concat(tops, ", ") or "(no module found)")
        end
        o.top = tops[1]
        said[#said + 1] = "Top module: " .. o.top .. " (the only module that no other module uses; give --top to choose another)"
      end
    end
    return said
  end

  function P.create(root, dir, o)
    if dir:lower() == root:lower() or U.inside(dir, root) then
      U.fail("create the project outside the specforge folder")
    end
    if U.is_file(dir .. "/project.md") then U.fail("%s already has a project.md; nothing was changed", dir) end
    local said = P.detect(dir, o)
    if not P.APPROACHES[o.approach or ""] then U.fail("--approach must be design-info or rtl") end
    if o.approach == "rtl" and not o.top then U.fail("--top <module> is required for --approach rtl") end
    if o.diagrams and not P.DIAGRAMS[o.diagrams] then U.fail("--diagrams must be detailed or high-level") end
    if o.pages and not (o.pages:match("^%d+$") and tonumber(o.pages) >= 1) then
      U.fail("--pages must be a whole number of pages, at least 1")
    end

    if o.short and o.short:find('[/\\:*?"<>|%c]') then
      U.fail('--short becomes part of the file name and cannot contain / \\ : * ? " < > |')
    end
    -- everything is checked before anything is created
    if o.input then
      local input = U.abs(o.input)
      P.check_folder(root, dir, input, o.approach)
      if o.approach == "rtl" then I.check_top(I.scan(input), o.top, input) end
    end
    if o.notes then P.check_folder(root, dir, U.abs(o.notes), "notes") end

    local lines = U.split(U.read(root .. "/config-templates/project.md"), "\n")
    local function put(key, v)
      if not v then return end
      if v:find('["\r\n]') then U.fail("the value of %s cannot contain a double quote or a line break", key) end
      for i, line in ipairs(lines) do
        local lead = line:match("^(%s*)" .. key .. ":")
        if lead then
          lines[i] = lead .. key .. ': "' .. v .. '"'
          return
        end
      end
      U.fail("config-templates/project.md has no key %s", key)
    end

    put("specforge_version", P.version(root))
    put("approach", o.approach)
    put("diagrams", o.diagrams)
    if o.pages then
      local done = false
      for i, line in ipairs(lines) do
        local lead, rest = line:match("^(%s*)max:(.*)$")
        if lead and not done then
          lines[i] = lead .. "max: " .. o.pages .. (rest:match("%s+#.*$") or "")
          done = true
        end
      end
      if not done then U.fail("config-templates/project.md has no page_budget.max") end
    end
    put("rtl_top", o.top)
    if o.input then
      local rel = U.relative(dir, o.input) .. "/"
      put(o.approach == "rtl" and "rtl" or "design_info", rel)
    end
    if o.notes then put("notes", U.relative(dir, o.notes) .. "/") end
    put("title", o.title)
    put("short_name", o.short)
    put("author", o.author)

    local made = {}
    local function place(rel, content)
      local to = dir .. "/" .. rel
      if U.is_file(to) then U.warn(rel .. " already exists and was left as it is"); return end
      U.write(to, content)
      made[#made + 1] = rel
    end
    place("project.md", table.concat(lines, "\n"))
    place("style.md", U.read(root .. "/config-templates/style.md"))
    for _, name in ipairs({ "clarifications", "status", "revision-history" }) do
      place(name .. ".md", U.read(root .. "/templates/" .. name .. ".md"))
    end
    place("colour-record.md", U.read(root .. "/styles/colour-record-template.md"))
    place(".gitignore", "build/\n")
    for _, line in ipairs(said) do U.say(line) end
    U.mkdir(dir .. "/chapters")
    U.mkdir(dir .. "/figures")
    if not o.input then U.mkdir(dir .. (o.approach == "rtl" and "/inputs/rtl" or "/inputs")) end
    return made
  end

  return P
end
