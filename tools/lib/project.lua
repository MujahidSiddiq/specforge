-- specforge -- project folders: create, read and check project.md.

return function(U, Y)
  local P = {}

  P.APPROACHES = U.set({ "design-info", "rtl" })

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
      design_info = text(cfg, "inputs.design_info", "inputs/"),
      rtl = text(cfg, "inputs.rtl", "inputs/rtl/"),
      rtl_top = text(cfg, "inputs.rtl_top"),
      notes = text(cfg, "inputs.notes", "inputs/notes/"),
      out = text(cfg, "output.dir", "output"),
      file_name = text(cfg, "output.file_name"),
      combined = cfg.value["output.combined_markdown"] ~= false,
      title = text(cfg, "document.title"),
      short_name = text(cfg, "document.short_name"),
      subtitle = text(cfg, "document.subtitle", "High-Level Specification"),
      author = text(cfg, "document.author"),
      organization = text(cfg, "document.organization", ""),
      revision = text(cfg, "document.revision", "0.1"),
      status = text(cfg, "document.status", "Draft"),
      date = text(cfg, "document.date"),
      language = text(cfg, "document.language", "en-GB"),
      min_pages = tonumber(text(cfg, "page_budget.min", "10")),
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
    if p.type ~= "high-level-spec" then bad[#bad + 1] = "document_type must be high-level-spec (is '" .. p.type .. "')" end
    if not P.APPROACHES[p.approach] then bad[#bad + 1] = "approach must be design-info or rtl (is '" .. p.approach .. "')" end
    if p.approach == "rtl" and not p.rtl_top then bad[#bad + 1] = "inputs.rtl_top is empty (required for rtl)" end
    if not p.min_pages or not p.max_pages then bad[#bad + 1] = "page_budget.min and max must be numbers" end
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
    p.file_name = p.file_name or ((p.short_name or "Document") .. "_High-Level_Specification")
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

  function P.create(root, dir, o)
    if dir:lower() == root:lower() or U.inside(dir, root) then
      U.fail("create the project outside the specforge folder")
    end
    if U.is_file(dir .. "/project.md") then U.fail("%s already has a project.md; nothing was changed", dir) end
    if not P.APPROACHES[o.approach or ""] then U.fail("--approach must be design-info or rtl") end
    if o.approach == "rtl" and not o.top then U.fail("--top <module> is required for --approach rtl") end

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
    put("rtl_top", o.top)
    if o.input then
      local rel = U.relative(dir, o.input) .. "/"
      put(o.approach == "rtl" and "rtl" or "design_info", rel)
      if not U.is_dir(U.abs(o.input)) then U.warn("the input folder does not exist yet: " .. o.input) end
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
    U.mkdir(dir .. "/chapters")
    U.mkdir(dir .. "/figures")
    if not o.input then U.mkdir(dir .. (o.approach == "rtl" and "/inputs/rtl" or "/inputs")) end
    return made
  end

  return P
end
