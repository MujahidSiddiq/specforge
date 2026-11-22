-- specforge -- Markdown chapters to LaTeX.
--
-- All chapter text is data: every character is escaped, inside and outside
-- code spans, so no text can become a LaTeX command. The accepted Markdown
-- is listed in latex/README.md; anything else is an error with file:line.

return function(U)
  local M = {}

  local MASK, STOP = "\1", "\2"
  local SYMBOLS = {
    ["\226\134\146"] = "$\\rightarrow$", ["\226\134\144"] = "$\\leftarrow$",
    ["\226\137\164"] = "$\\le$", ["\226\137\165"] = "$\\ge$", ["\195\151"] = "$\\times$",
  }

  -- Contents of a code span. \detokenize (inside \sig) alters or rejects
  -- % # { } \ and a few others, so those spans are escaped instead.
  function M.code(code)
    if code:find("[\\%%#{}~^$&`]") or code:find("  ", 1, true) or code:find("^ ") then
      return "\\texttt{" .. U.tex_literal(code) .. "}"
    end
    return "\\sig{" .. code .. "}"
  end

  local function is_word(c) return c ~= "" and c:match("[%w_]") ~= nil end

  -- *text* that does not touch a word or a space on the inside.
  local function italics(s)
    local out, done, i = {}, 1, 1
    while true do
      local a = s:find("*", i, true)
      if not a then break end
      local before, after = a > 1 and s:sub(a - 1, a - 1) or "", s:sub(a + 1, a + 1)
      local close
      if before ~= "*" and not is_word(before) and after ~= "" and not after:match("%s") then
        local j = a + 2
        while true do
          local b = s:find("*", j, true)
          if not b then break end
          local nxt = s:sub(b + 1, b + 1)
          if not s:sub(b - 1, b - 1):match("%s") and nxt ~= "*" and not is_word(nxt) then close = b; break end
          j = b + 1
        end
      end
      if close then
        out[#out + 1] = s:sub(done, a - 1) .. "\\emph{" .. s:sub(a + 1, close - 1) .. "}"
        done, i = close + 1, close + 1
      else
        i = a + 1
      end
    end
    return table.concat(out) .. s:sub(done)
  end

  -- moving: headings and captions, which also become PDF bookmarks.
  function M.inline(s, moving, where)
    s = s:gsub("[\1\2]", "")
    local codes, links = {}, {}
    s = s:gsub("`([^`]+)`", function(c)
      codes[#codes + 1] = c
      return MASK .. "C" .. #codes .. STOP
    end)
    s = s:gsub("%[([^%]]+)%]%(([^)%s]+)%)", function(text, url)
      if not (url:match("^https?://") or url:match("^mailto:")) or url:find("[\\{}\"^`<>|\1]") then
        U.fail("%s: a link must be a plain http, https or mailto address: %s", where or "text", url)
      end
      links[#links + 1] = url
      return MASK .. "L" .. #links .. STOP .. text .. MASK .. "E" .. STOP
    end)

    s = U.tex(s)
    for from, to in pairs(SYMBOLS) do s = s:gsub(from, (to:gsub("%%", "%%%%"))) end
    s = s:gsub("%*%*(..-)%*%*", "\\textbf{%1}")
    s = italics(s)

    s = s:gsub(MASK .. "L(%d+)" .. STOP, function(n)
      return "\\href{" .. links[tonumber(n)]:gsub("[%%#&]", "\\%0") .. "}{"
    end)
    s = s:gsub(MASK .. "E" .. STOP, "}")
    s = s:gsub(MASK .. "C(%d+)" .. STOP, function(n)
      local c = codes[tonumber(n)]
      if moving then return "\\texorpdfstring{" .. M.code(c) .. "}{" .. U.tex(c) .. "}" end
      return M.code(c)
    end)
    return s
  end

  -- Cells of a table row. A | inside a code span or written \| is text.
  function M.cells(row)
    local s = U.trim(row):gsub("^|", "")
    local out, cur, i = {}, {}, 1
    while i <= #s do
      local c = s:sub(i, i)
      if c == "\\" and s:sub(i + 1, i + 1) == "|" then
        cur[#cur + 1] = "|"
        i = i + 2
      elseif c == "`" then
        local close = s:find("`", i + 1, true)
        if close then
          cur[#cur + 1] = s:sub(i, close):gsub("\\|", "|")
          i = close + 1
        else
          cur[#cur + 1] = c
          i = i + 1
        end
      elseif c == "|" then
        out[#out + 1] = U.trim(table.concat(cur))
        cur = {}
        i = i + 1
      else
        cur[#cur + 1] = c
        i = i + 1
      end
    end
    local last = U.trim(table.concat(cur))
    if last ~= "" then out[#out + 1] = last end
    return out
  end

  -- Width in mm of the widest piece of a cell that cannot break.
  local function longest_piece(cell)
    local best, i = 0, 1
    while true do
      local a = cell:find("%S", i)
      if not a then return best end
      local close = cell:sub(a, a) == "`" and cell:find("`", a + 1, true)
      local token
      if close and close > a + 1 then
        token, i = cell:sub(a, close), close + 1
      else
        local b = cell:find("%s", a) or #cell + 1
        token, i = cell:sub(a, b - 1), b
      end
      local mm = 0
      if token:sub(1, 1) == "`" then
        for piece in token:gsub("^`+", ""):gsub("`+$", ""):gmatch("[^ ]+") do
          mm = math.max(mm, U.len(piece) * 1.95)
        end
      else
        mm = U.len(token) * 1.75
      end
      best = math.max(best, mm)
    end
  end

  local function plain_length(s) return U.len(U.trim((s:gsub("[`*]", "")))) end

  local function column_widths(head, body, geom)
    local n, weight, minimum, width, fixed = #head, {}, {}, {}, {}
    for c = 1, n do
      local max, longest = plain_length(head[c]) + 2, longest_piece(head[c])
      for _, r in ipairs(body) do
        max = math.max(max, plain_length(r[c]))
        longest = math.max(longest, longest_piece(r[c]))
      end
      weight[c] = math.max(8, math.min(max, 70))
      minimum[c] = math.ceil(longest + 1)
    end
    local avail = geom.text_mm - geom.gap_mm * (n - 1)
    for _ = 1, n do
      local free, sum, changed = avail, 0, false
      for c = 1, n do
        if fixed[c] then free = free - width[c] else sum = sum + weight[c] end
      end
      for c = 1, n do
        if not fixed[c] then
          local w = free * weight[c] / sum
          if w < minimum[c] then width[c], fixed[c], changed = minimum[c], true, true else width[c] = w end
        end
      end
      if not changed then break end
    end
    return width
  end

  local function table_tex(rows, caption, geom)
    local head = M.cells(rows[1].text)
    local sep = rows[2] and M.cells(rows[2].text)
    if not sep or not (sep[1] or ""):match("^:?%-+") or not rows[3] then
      U.fail("%s: a table needs a header row, a separator row and at least one row", rows[1].where)
    end
    local body = {}
    for i = 3, #rows do
      local r = M.cells(rows[i].text)
      if #r > #head then
        U.fail("%s: the row has %d cells, the header %d (write a | inside a cell as \\| )", rows[i].where, #r, #head)
      end
      for c = #r + 1, #head do r[c] = "" end
      body[#body + 1] = r
    end

    local spec, header = {}, {}
    for c, w in ipairs(column_widths(head, body, geom)) do
      spec[c] = string.format("P{%dmm}", math.floor(w))
      header[c] = "\\thd{" .. M.inline(head[c], false, rows[1].where) .. "}"
    end
    -- An unbreakable tabular in a minipage: a longtable next to floating
    -- figures can overflow the page (tables.breakable = false).
    local out = { "\\par\\medskip\\noindent\\begin{minipage}{\\linewidth}" }
    if caption then out[#out + 1] = "\\captionof{table}{" .. M.inline(caption, true, rows[1].where) .. "}" end
    out[#out + 1] = "{\\tblfont"
    out[#out + 1] = "\\begin{tabular}{@{}" .. table.concat(spec) .. "@{}}"
    out[#out + 1] = "\\tbltoprule"
    out[#out + 1] = "\\tblheadrow " .. table.concat(header, " & ") .. " \\\\"
    out[#out + 1] = "\\tblheadrule"
    for i, r in ipairs(body) do
      local cells = {}
      for c = 1, #head do cells[c] = M.inline(r[c], false, rows[i + 2].where) end
      local line = table.concat(cells, " & ")
      -- a row that begins with [ would be read as the option of the \\ before it
      if line:match("^%[") then line = "{}" .. line end
      out[#out + 1] = line .. " \\\\"
      if i < #body then out[#out + 1] = "\\tblrowrule" end
    end
    out[#out + 1] = "\\tblbottomrule"
    out[#out + 1] = "\\end{tabular}}"
    out[#out + 1] = "\\end{minipage}\\par\\medskip"
    return out
  end

  local function is_timing(name) return name:match("^fig%-wave%-") or name:match("^fig%-timing%-") end
  M.is_timing = is_timing

  function M.converter(value)
    local paper = value["page.paper"] == "letter" and 215.9 or 210
    local self = {
      known = {}, refs = {}, figures = {},
      geom = { text_mm = paper - 2 * value["page.margin_mm"], gap_mm = 2 * value["tables.column_sep_pt"] * 0.3515 },
    }
    local max_fig = U.num(value["figures.max_height_fraction"])
    local max_wave = U.num(value["figures.max_height_fraction_timing"])
    local barrier = value["figures.floats_stay_in_chapter"]

    -- "ABC Section 1.2" names another document and is not checked.
    local function find_refs(text, where)
      for _, word in ipairs({ "Chapter", "Section", "Table", "Figure" }) do
        local i = 1
        while true do
          local a, b, number = text:find(word .. " (%d[%d.]*)", i)
          if not a then break end
          i = b + 1
          local before = text:sub(1, a - 1)
          if not is_word(before:sub(-1)) and not before:match("%u%u $") and not before:match("%u%l*%u $")
            and not is_word(text:sub(b + 1, b + 1)) then
            self.refs[#self.refs + 1] = { ref = word .. " " .. number:gsub("%.+$", ""), where = where, at = a }
          end
        end
      end
    end

    function self.convert(text, name, front, chapter)
      local out, lists = {}, {}
      local rows, caption, figure
      local sec, sub, tabs, figs, chapters = 0, 0, 0, 0, 0
      local comment = false

      local function add(s) out[#out + 1] = s end
      local function close_lists()
        for k = #lists, 1, -1 do add("\\end{" .. lists[k].env .. "}") end
        lists = {}
      end
      local function flush_table()
        for _, l in ipairs(table_tex(rows, caption, self.geom)) do add(l) end
        rows, caption = nil, nil
      end

      local function heading(hashes, title, where)
        if front then
          if #hashes == 2 then
            local t = M.inline(title, true, where)
            add("\\section*{" .. t .. "}")
            add("\\markboth{" .. t .. "}{}")
          end
          return
        end
        local function wrong(kind, want) U.fail("%s: %s heading '%s' is not number %s", where, kind, title, want) end
        if #hashes == 1 then
          chapters = chapters + 1
          if chapters > 1 then U.fail("%s: one chapter per file", where) end
          local n, t = title:match("^(%d+)%. (.+)$")
          if tonumber(n) ~= chapter then wrong("chapter", chapter) end
          if barrier then add("\\FloatBarrier") end
          add("\\chapter{" .. M.inline(t, true, where) .. "}")
          self.known["Chapter " .. chapter] = true
          return
        end
        if chapters == 0 then U.fail("%s: the chapter heading must come first", where) end
        if #hashes == 2 then
          sec, sub = sec + 1, 0
          local want = chapter .. "." .. sec
          local n, t = title:match("^(%d+%.%d+) (.+)$")
          if n ~= want then wrong("section", want) end
          add("\\section{" .. M.inline(t, true, where) .. "}")
          self.known["Section " .. want] = true
        elseif #hashes == 3 then
          sub = sub + 1
          local want = chapter .. "." .. sec .. "." .. sub
          local n, t = title:match("^(%d+%.%d+%.%d+) (.+)$")
          if n ~= want then wrong("subsection", want) end
          add("\\subsection{" .. M.inline(t, true, where) .. "}")
          self.known["Section " .. want] = true
        else
          U.fail("%s: heading level 4 is not used in a high-level specification", where)
        end
      end

      local function line_tex(line, where)
        if line:match("^%s*```") then U.fail("%s: code blocks are not supported; use `inline code` or a table", where) end

        if line:match("^|") then
          if not rows then close_lists(); rows = {} end
          if not front then find_refs(line, where) end
          rows[#rows + 1] = { text = line, where = where }
          return
        elseif rows then
          flush_table()
          add("")
        end

        if not line:match("%S") then close_lists(); add(""); return end
        if caption then U.fail("%s: a **Table N.M.** caption line must be followed by its table", where) end
        if not front and not line:match("^#") and not line:match("^%*%*Table %d") and not line:match("^%*%*Figure %d") then
          find_refs(line, where)
        end

        local hashes, title = line:match("^(#+) (.+)$")
        if hashes then close_lists(); heading(hashes, U.trim(title), where); return end

        local tc, tn, tcap = line:match("^%*%*Table (%d+)%.(%d+)%.%*%* (.+)$")
        if tc then
          close_lists()
          tabs = tabs + 1
          local want = chapter .. "." .. tabs
          if tc .. "." .. tn ~= want then U.fail("%s: table caption is numbered %s.%s; it is Table %s", where, tc, tn, want) end
          self.known["Table " .. want] = true
          caption = tcap
          return
        end

        local image = line:match("^!%[[^%]]*%]%(%.%./figures/([%w%-]+)%.svg%)$")
        if image then close_lists(); figure = { name = image, where = where }; return end
        if line:match("^!%[") then U.fail("%s: images must be ![alt](../figures/NAME.svg)", where) end

        local fc, fn, fcap = line:match("^%*%*Figure (%d+)%.(%d+)%.%*%* (.+)$")
        if fc then
          if not figure then U.fail("%s: figure caption without image", where) end
          figs = figs + 1
          local want = chapter .. "." .. figs
          if fc .. "." .. fn ~= want then U.fail("%s: figure caption is numbered %s.%s; it is Figure %s", where, fc, fn, want) end
          self.known["Figure " .. want] = true
          self.figures[#self.figures + 1] = figure
          local wave = is_timing(figure.name)
          local short = fcap:match("^(..-%.)%s") or fcap
          add("\\begin{figure}[htbp]")
          add("  \\centering")
          -- varwidth keeps multi-part figures in vertical mode; ragged-right
          -- text distorts tikz-timing tables, so those are set justified.
          add("  \\adjustbox{max totalheight=" .. (wave and max_wave or max_fig)
            .. "\\textheight,max width=\\linewidth}{\\begin{varwidth}{\\linewidth}"
            .. (wave and "\\justifying" or "\\centering")
            .. "\\input{figures/" .. figure.name .. "}\\end{varwidth}}")
          add("  \\caption[" .. "{" .. M.inline(short, true, where) .. "}]{" .. M.inline(fcap, true, where) .. "}")
          add("\\end{figure}")
          figure = nil
          return
        end
        if figure then U.fail("%s: an image must be followed by its **Figure N.M.** caption line", where) end

        local quote = line:match("^> ?(.*)$")
        if quote then
          close_lists()
          local id, rest = quote:match("^%*%*Open point (.-)%*%*%s*(.*)$")
          if id then
            add("\\openpoint{\\textbf{" .. M.inline(id, false, where) .. "} " .. M.inline(rest, false, where) .. "}")
          else
            add("\\sfnote{" .. M.inline(quote, false, where) .. "}")
          end
          return
        end

        local indent, item = line:match("^(%s*)%- (.*)$")
        local env = "itemize"
        if not indent then
          indent, item = line:match("^(%s*)%d+%. (.*)$")
          env = "enumerate"
        end
        if indent then
          while #lists > 0 and lists[#lists].indent > #indent do
            add("\\end{" .. lists[#lists].env .. "}")
            lists[#lists] = nil
          end
          if #lists > 0 and lists[#lists].indent == #indent and lists[#lists].env ~= env then
            add("\\end{" .. lists[#lists].env .. "}")
            lists[#lists] = nil
          end
          if #lists == 0 or lists[#lists].indent < #indent then
            add("\\begin{" .. env .. "}")
            lists[#lists + 1] = { indent = #indent, env = env }
          end
          local body = M.inline(item, false, where)
          if body:match("^%[") then body = "{}" .. body end
          add("  \\item " .. body)
          return
        end

        close_lists()
        if line:match("^#") then U.fail("%s: heading without a space after #", where) end
        add(M.inline(line, false, where))
      end

      for n, line in ipairs(U.split(text, "\n")) do
        if comment then
          if line:find("-->", 1, true) then comment = false end
        elseif line:match("^%s*<!%-%-") then
          comment = not line:find("-->", 1, true)
        else
          line_tex(line, name .. ":" .. n)
        end
      end

      if comment then U.fail("%s: a <!-- comment is not closed", name) end
      if rows then flush_table() end
      close_lists()
      if figure then U.fail("%s: image without figure caption at the end of the file", name) end
      if caption then U.fail("%s: table caption without a table at the end of the file", name) end
      if not front and chapters ~= 1 then U.fail("%s: the file must contain exactly one chapter heading", name) end
      return out
    end

    function self.check_refs()
      local bad = 0
      for _, r in ipairs(self.refs) do
        if not self.known[r.ref] then
          bad = bad + 1
          U.warn(r.where .. ": '" .. r.ref .. "' does not exist in this document")
        end
      end
      if bad == 0 then
        U.say(string.format("All %d references to chapters, sections, tables and figures resolve.", #self.refs))
      end
    end

    return self
  end

  return M
end
