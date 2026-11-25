-- specforge -- merges the style defaults with a project's overrides.
--
-- Returns the values and the generated LaTeX files:
--   sf-class.tex    \documentclass line
--   sf-config.tex   every value as a macro: headings.chapter.size_pt becomes
--                   \sfHeadingsChapterSizePt; a true/false value becomes a
--                   conditional, body.ragged_right -> \ifsfBodyRaggedRight
--   sf-setup.tex    geometry, colours, fonts, captions, PDF properties
--   style-report.md overrides, derived colours, contrast checks
--
-- Colours can be given three ways in style.md:
--   colours:    plain names (text, block_fill, waveform ...), see PLAIN
--   overrides:  colour tokens (colour.text_primary ...) or any element key
--               (diagrams.block.fill ...), as a token name or #RRGGBB
--
-- style.md may come from another person or another AI, so every value that
-- reaches LaTeX unescaped is checked against what it may contain.

return function(U, Y, C)
  local S = {}

  local CHOICES = {
    ["page.paper"] = { "a4", "letter" },
    ["page.front_matter_numbering"] = { "roman", "Roman", "arabic" },
    ["page.body_numbering"] = { "roman", "Roman", "arabic" },
    ["captions.label_separator"] = { "period", "colon", "space", "quad", "endash" },
    ["header_footer.font_size"] = { "tiny", "scriptsize", "footnotesize", "small", "normalsize", "large" },
    ["captions.font_size"] = { "tiny", "scriptsize", "footnotesize", "small", "normalsize", "large" },
  }

  -- colour-guide.md Section 3.2
  local PAIRS = {
    { "text_primary", "bg_page", 4.5, "Body text, headings, table text" },
    { "text_primary", "bg_subtle", 4.5, "Table header text, boundary labels" },
    { "text_primary", "accent_subtle", 4.5, "Text on a highlighted element" },
    { "text_secondary", "bg_page", 4.5, "Captions, header, footer, sub-labels" },
    { "warn_fg", "bg_page", 4.5, "PENDING label" },
    { "warn_fg", "warn_bg", 4.5, "OPEN POINT label" },
    { "text_primary", "warn_bg", 4.5, "Open-point text" },
    { "info_fg", "info_bg", 4.5, "Information label" },
    { "error_fg", "error_bg", 4.5, "Error label" },
    { "border_strong", "bg_page", 3.0, "Block outlines, table outer rules" },
    { "border_strong", "bg_subtle", 3.0, "Boundary and ports" },
    { "text_secondary", "bg_subtle", 3.0, "Wires over the boundary fill" },
    { "accent_primary", "bg_page", 3.0, "Chapter rule, highlight" },
    { "accent_primary", "bg_subtle", 3.0, "Highlight over the boundary fill" },
    { "accent_primary", "accent_subtle", 3.0, "Highlighted entry outline" },
  }

  -- Plain colour names of style.md -> the key they set.
  local PLAIN = {
    text = "colour.text_primary", secondary_text = "colour.text_secondary",
    background = "colour.bg_page", light_background = "colour.bg_subtle",
    lines = "colour.border_strong", light_lines = "colour.border_subtle",
    accent = "colour.accent_primary", headings = "headings.colour", captions = "captions.colour",
    table_header = "tables.header_fill",
    block_fill = "diagrams.block.fill", block_border = "diagrams.block.draw",
    boundary_fill = "diagrams.boundary.fill", boundary_border = "diagrams.boundary.draw",
    wires = "diagrams.wire.colour", highlight = "diagrams.highlight.colour",
    waveform = "timing.signal_colour", clock = "timing.clock_colour", waveform_grid = "timing.grid_colour",
    state_fill = "state_machines.state.fill", state_border = "state_machines.state.draw",
    transitions = "state_machines.transition.colour", reset_arrow = "state_machines.reset.colour",
  }
  S.PLAIN = PLAIN

  -- Element colours, checked as they are used (colour-guide.md Section 3.2).
  -- A name without a dot is a colour token.
  local ELEMENT_PAIRS = {
    { "headings.colour", "bg_page", 4.5, "Headings" },
    { "captions.colour", "bg_page", 4.5, "Captions" },
    { "captions.label_colour", "bg_page", 4.5, "Caption labels" },
    { "text_primary", "tables.header_fill", 4.5, "Table header text" },
    { "text_primary", "callouts.note.fill", 4.5, "Highlighted statement" },
    { "callouts.open_point.label_colour", "callouts.open_point.fill", 4.5, "OPEN POINT label" },
    { "text_primary", "diagrams.block.fill", 4.5, "Block names" },
    { "text_primary", "diagrams.boundary.fill", 4.5, "Labels inside the boundary" },
    { "diagrams.block.draw", "diagrams.boundary.fill", 3.0, "Block outlines" },
    { "diagrams.boundary.draw", "bg_page", 3.0, "Boundary outline" },
    { "diagrams.wire.colour", "bg_page", 3.0, "Wires" },
    { "diagrams.wire.colour", "diagrams.boundary.fill", 3.0, "Wires inside the boundary" },
    { "diagrams.highlight.colour", "diagrams.boundary.fill", 3.0, "Highlighted path" },
    { "timing.signal_colour", "bg_page", 3.0, "Waveforms" },
    { "timing.clock_colour", "bg_page", 3.0, "Clock waveform" },
    { "text_primary", "state_machines.state.fill", 4.5, "State names" },
    { "state_machines.state.draw", "bg_page", 3.0, "State outlines" },
    { "state_machines.transition.colour", "bg_page", 3.0, "Transitions" },
    { "state_machines.reset.colour", "bg_page", 3.0, "Reset entry" },
  }

  local HF_WORDS = {
    title = "\\DocTitle", short_name = "\\DocShortTitle", chapter = "\\leftmark",
    page = "\\thepage", none = "",
  }
  local PLACEHOLDERS = {
    revision = "\\DocRevision{}", status = "\\DocStatus{}", date = "\\DocDate{}",
    title = "\\DocTitle{}", short_name = "\\DocShortTitle{}", page = "\\thepage{}",
  }

  local function plain_names(over, errors)
    local any = false
    for path in pairs(over.group) do
      if path:match("^colours%.") then errors[#errors + 1] = "'" .. path .. "' must be a colour, not a group" end
    end
    for _, path in ipairs(over.order) do
      local name = path:match("^colours%.(.+)$")
      if name then
        local key = PLAIN[name]
        if not key then
          local names = {}
          for n in pairs(PLAIN) do names[#names + 1] = n end
          table.sort(names)
          errors[#errors + 1] = "unknown colour name '" .. name .. "' (names: " .. table.concat(names, ", ") .. ")"
        elseif over.value["overrides." .. key] ~= nil then
          errors[#errors + 1] = "colours." .. name .. " and overrides." .. key .. " set the same colour"
        else
          over.value["overrides." .. key] = over.value[path]
          over.order[#over.order + 1] = "overrides." .. key
          any = true
        end
      elseif not path:match("^overrides%.") then
        errors[#errors + 1] = "'" .. path .. "' is not allowed: use colours or overrides"
      end
    end
    return any
  end

  local function merge(def, over, errors)
    local v, changed = {}, {}
    for k, x in pairs(def.value) do v[k] = x end
    plain_names(over, errors)
    for path in pairs(over.group) do
      local key = path:match("^overrides%.(.+)$")
      if key and not def.group[key] then
        if def.value[key] ~= nil then errors[#errors + 1] = "'" .. key .. "' takes a value, not a group"
        else errors[#errors + 1] = "unknown key '" .. key .. "'" end
      end
    end
    for _, path in ipairs(over.order) do
      local key = path:match("^overrides%.(.+)$")
      if key then
        local base, x = def.value[key], over.value[path]
        local problem
        if def.group[key] then
          problem = "'" .. key .. "' must be a group of keys"
        elseif base == nil then
          problem = "unknown key '" .. key .. "'"
        elseif type(base) ~= type(x) then
          local kind = { number = "a number", boolean = "true or false", table = "a list", string = "text" }
          -- a bare number is acceptable where text is expected
          if type(base) == "string" and type(x) == "number" then x = U.num(x)
          else problem = "'" .. key .. "' must be " .. kind[type(base)] end
        end
        if problem then errors[#errors + 1] = problem
        else v[key] = x; changed[#changed + 1] = key end
      end
    end
    table.sort(errors)
    return v, changed
  end

  local function validate(def, v, errors)
    for _, key in ipairs(def.order) do
      local x, base = v[key], def.value[key]
      if key:match("^colour%.") then
        if type(x) ~= "string" or not x:match("^#%x%x%x%x%x%x$") then errors[#errors + 1] = key .. " must be #RRGGBB" end
      elseif key:match("^fonts%.") and type(x) == "string" then
        if x:find("[^%w ._*%-]") then errors[#errors + 1] = key .. " may contain only letters, digits, space . _ * -" end
      elseif CHOICES[key] then
        if not U.set(CHOICES[key])[x] then
          errors[#errors + 1] = key .. " must be one of: " .. table.concat(CHOICES[key], ", ")
        end
      elseif type(base) == "string" and def.value["colour." .. base] ~= nil then
        if def.value["colour." .. x] == nil and not x:match("^#%x%x%x%x%x%x$") then
          errors[#errors + 1] = key .. " must be #RRGGBB or the name of a colour token"
        end
      end
    end
    local size = v["page.class_font_size_pt"]
    if size ~= 10 and size ~= 11 and size ~= 12 then errors[#errors + 1] = "page.class_font_size_pt must be 10, 11 or 12" end
  end

  -- colour-guide.md Section 6.1: the overridden accent is used as given; the
  -- tokens that are not overridden themselves follow its hue.
  local function derive(v, changed, report)
    local is = U.set(changed)
    if not is["colour.accent_primary"] then return 0 end
    local hue, done = C.hue(v["colour.accent_primary"]), {}

    if not is["colour.accent_subtle"] then
      v["colour.accent_subtle"] = C.from_oklch(0.965, 0.02, hue)
      done[#done + 1] = "accent_subtle"
    end
    if not is["colour.accent_strong"] then
      local light, c = 0.60, nil
      while light > 0.10 do
        c = C.from_oklch(light, 0.08, hue)
        if C.contrast(c, v["colour.bg_page"]) >= 7 and C.contrast(c, v["colour.accent_subtle"]) >= 4.5 then break end
        light = light - 0.005
      end
      v["colour.accent_strong"] = c
      done[#done + 1] = "accent_strong"
    end
    if not is["colour.accent_secondary"] then
      local light, c = 0.85, nil
      while light < 0.99 do
        c = C.from_oklch(light, 0.06, hue)
        if C.contrast(v["colour.text_primary"], c) >= 7 then break end
        light = light + 0.005
      end
      v["colour.accent_secondary"] = c
      done[#done + 1] = "accent_secondary"
    end

    local hits = {}
    for _, s in ipairs({ { "Information", 250 }, { "Warning", 67 }, { "Error", 26 }, { "Positive", 159 } }) do
      local d = math.abs(hue - s[2])
      if math.min(d, 360 - d) < 30 then hits[#hits + 1] = s[1] end
    end
    report[#report + 1] = "## Accent\n"
    report[#report + 1] = string.format("Accent hue: %.0f degrees (OKLCH). Derived tokens: %s.",
      hue, #done > 0 and table.concat(done, ", ") or "none")
    report[#report + 1] = "Hue collisions: " .. (#hits > 0
      and table.concat(hits, ", ") .. " -- do not use the accent where that meaning is possible (colour-guide.md Section 6.1, step 2).\n"
      or "none\n")
    return #done
  end

  local function macro_name(key)
    local out = {}
    for part in key:gmatch("[^._]+") do out[#out + 1] = part:sub(1, 1):upper() .. part:sub(2) end
    return "sf" .. table.concat(out)
  end

  -- A #RRGGBB element colour is defined as its own colour, named after its key.
  local function own_colour(key) return "sfc" .. macro_name(key):sub(3) end

  local function hex_of(v, name)
    local x = name:find(".", 1, true) and v[name] or name
    if type(x) == "string" and x:match("^#") then return x end
    return v["colour." .. x]
  end

  local function text_value(v, key, x)
    if v["colour." .. x] ~= nil then return (x:gsub("_", "")) end
    if x:match("^#%x%x%x%x%x%x$") then return own_colour(key) end
    if key:match("^header_footer%.header_[lr]") and key:match("_[a-z]+$") and not key:match("_rule")
      or key:match("^header_footer%.footer_[lr]") and not key:match("_rule") then
      if HF_WORDS[x] then return HF_WORDS[x] end
      local out, at = {}, 1
      while true do
        local a, b, word = x:find("{([%a_]+)}", at)
        if not a then break end
        out[#out + 1] = U.tex(x:sub(at, a - 1))
        out[#out + 1] = PLACEHOLDERS[word] or U.tex(x:sub(a, b))
        at = b + 1
      end
      return table.concat(out) .. U.tex(x:sub(at))
    end
    if key:match("font_size$") then return "\\" .. x end
    return U.tex(x)
  end

  local function config_tex(def, v)
    local out = {
      "% GENERATED by specforge -- do not edit.",
      "% Every style value as a macro; see styles/style-defaults.md for the keys.",
    }
    for _, key in ipairs(def.order) do
      if not key:match("^colour%.") and not key:match("^fonts%.") then
        local x, name = v[key], macro_name(key)
        if not name:match("^%a+$") then U.fail("style key '%s' cannot be a macro name", key) end
        if type(x) == "boolean" then
          out[#out + 1] = string.format("\\newif\\if%s \\%s%s", name, name, tostring(x))
        else
          local s
          if type(x) == "number" then s = U.num(x)
          elseif type(x) == "table" then
            local items = {}
            for i, item in ipairs(x) do items[i] = U.tex(tostring(item)) end
            s = table.concat(items, ",")
          else
            s = text_value(v, key, x)
          end
          out[#out + 1] = "\\def\\" .. name .. "{" .. s .. "}"
        end
      end
    end
    return table.concat(out, "\n") .. "\n"
  end

  local function font(v, cmd, family, faces, extra)
    local opts = {}
    for _, f in ipairs(faces) do
      if v["fonts." .. f[2]]:match("^%*") then opts[1] = "Extension=.otf" end
    end
    for _, f in ipairs(faces) do
      local x = v["fonts." .. f[2]]
      if x ~= "" then opts[#opts + 1] = f[1] .. "=" .. x end
    end
    if extra then opts[#opts + 1] = extra end
    return cmd .. "{" .. family .. "}[" .. table.concat(opts, ",") .. "]"
  end

  local function setup_tex(def, v)
    local n = U.num
    local out = {
      "% GENERATED by specforge -- do not edit.",
      string.format("\\geometry{%spaper,margin=%smm,headheight=%spt,headsep=%smm,footskip=%smm}", v["page.paper"],
        n(v["page.margin_mm"]), n(v["page.head_height_pt"]), n(v["page.head_sep_mm"]), n(v["page.foot_skip_mm"])),
    }
    for _, key in ipairs(def.order) do
      local token = key:match("^colour%.(.+)$")
      if token then
        out[#out + 1] = string.format("\\definecolor{%s}{HTML}{%s}   %% %s", (token:gsub("_", "")), v[key]:sub(2):upper(), token)
      end
    end
    for _, key in ipairs(def.order) do
      local x = v[key]
      if not key:match("^colour%.") and type(x) == "string" and x:match("^#%x%x%x%x%x%x$") then
        out[#out + 1] = string.format("\\definecolor{%s}{HTML}{%s}   %% %s", own_colour(key), x:sub(2):upper(), key)
      end
    end
    out[#out + 1] = "\\pagecolor{bgpage}"
    out[#out + 1] = "\\color{textprimary}"
    local main = { { "UprightFont", "main_upright" }, { "ItalicFont", "main_italic" },
      { "BoldFont", "main_bold" }, { "BoldItalicFont", "main_bold_italic" } }
    out[#out + 1] = font(v, "\\setmainfont", v["fonts.main"], main)
    out[#out + 1] = font(v, "\\setsansfont", v["fonts.main"], main)
    out[#out + 1] = font(v, "\\setmonofont", v["fonts.mono"],
      { { "UprightFont", "mono_upright" }, { "BoldFont", "mono_bold" } }, "Scale=" .. n(v["fonts.mono_scale"]))
    out[#out + 1] = font(v, "\\newfontfamily\\headingfont", v["fonts.heading"],
      { { "UprightFont", "heading_upright" }, { "BoldFont", "heading_upright" }, { "ItalicFont", "heading_italic" } })
    out[#out + 1] = string.format(
      "\\captionsetup{font={%s,color=%s},labelfont={%scolor=%s},labelsep=%s,justification=RaggedRight,singlelinecheck=false,skip=%spt}",
      v["captions.font_size"], text_value(v, "captions.colour", v["captions.colour"]), v["captions.label_bold"] and "bf," or "",
      text_value(v, "captions.label_colour", v["captions.label_colour"]), v["captions.label_separator"], n(v["captions.skip_pt"]))
    out[#out + 1] = string.format(
      "\\hypersetup{hidelinks=%s,pdftitle={\\DocTitle{} --- \\DocSubtitle},pdfauthor={\\DocAuthor},pdfsubject={\\DocSubtitle},pdflang={\\DocLanguage},pdfdisplaydoctitle=%s,bookmarksnumbered=%s}",
      tostring(v["pdf.hide_links"]), tostring(v["pdf.display_title"]), tostring(v["pdf.bookmarks_numbered"]))
    return table.concat(out, "\n") .. "\n"
  end

  function S.make(root, project)
    local def = Y.read(root .. "/styles/style-defaults.md", true)
    local file = project .. "/style.md"
    local over = U.is_file(file) and Y.read(file, true) or { value = {}, group = {}, order = {} }

    local errors = {}
    local v, changed = merge(def, over, errors)
    if #errors == 0 then validate(def, v, errors) end
    if #errors > 0 then U.fail("style.md: " .. table.concat(errors, "; ")) end

    local report = { "# Style report (generated)\n", "## Overrides from style.md\n" }
    for _, key in ipairs(changed) do
      local x = v[key]
      local shown = type(x) == "table" and table.concat(x, ", ") or type(x) == "number" and U.num(x) or tostring(x)
      report[#report + 1] = "- `" .. key .. "`: " .. shown
    end
    if #changed == 0 then report[#report + 1] = "None: the default style is used." end
    report[#report + 1] = ""
    local derived = derive(v, changed, report)

    report[#report + 1] = "## Contrast\n"
    report[#report + 1] = "| Use | Foreground | Background | Ratio | Required | Result |"
    report[#report + 1] = "|---|---|---|---:|---:|---|"
    local failed = {}
    local checked = 0
    for _, list in ipairs({ PAIRS, ELEMENT_PAIRS }) do
      for _, p in ipairs(list) do
        local fg, bg = hex_of(v, p[1]), hex_of(v, p[2])
        if not fg or not bg then U.fail("internal: unknown style key in a contrast pair: %s / %s", p[1], p[2]) end
        local r = C.contrast(fg, bg)
        checked = checked + 1
        if r < p[3] then failed[#failed + 1] = string.format("%s on %s: %.2f < %s", p[1], p[2], r, U.num(p[3])) end
        report[#report + 1] = string.format("| %s | `%s` %s | `%s` %s | %.2f | %s | %s |",
          p[4], p[1], fg, p[2], bg, r, U.num(p[3]), r >= p[3] and "pass" or "FAIL")
      end
    end

    return {
      value = v,
      failed = failed,
      summary = string.format("Style: %d override(s), %d derived token(s), %d of %d contrast pairs pass.",
        #changed, derived, checked - #failed, checked),
      files = {
        ["sf-class.tex"] = string.format("\\documentclass[%dpt,%spaper,oneside]{report}\n",
          math.floor(v["page.class_font_size_pt"]), v["page.paper"]),
        ["sf-config.tex"] = config_tex(def, v),
        ["sf-setup.tex"] = setup_tex(def, v),
        ["style-report.md"] = table.concat(report, "\n") .. "\n",
      },
    }
  end

  return S
end
