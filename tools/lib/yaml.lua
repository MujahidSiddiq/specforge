-- specforge -- reader for the YAML subset of project.md and style.md.
--
-- Nested groups by indentation, scalars (quoted or bare), inline lists
-- [a, b], block lists (- item), the empty group {} and # comments outside
-- quotes. The result is flat, in file order:
--   doc.value["a.b"]  the value of a key
--   doc.group["a"]    true for a key that holds other keys
--   doc.order         the paths of the values, in file order

return function(U)
  local Y = {}

  local function strip_comment(line)
    local quote
    for i = 1, #line do
      local c = line:sub(i, i)
      if quote then
        if c == quote then quote = nil end
      elseif (c == '"' or c == "'") and (i == 1 or line:sub(i - 1, i - 1):match("[%s%[,]")) then
        quote = c
      elseif c == "#" and (i == 1 or line:sub(i - 1, i - 1):match("%s")) then
        return (line:sub(1, i - 1):gsub("%s+$", ""))
      end
    end
    return (line:gsub("%s+$", ""))
  end

  -- typed: numbers become numbers. Without it they stay text, so that a
  -- revision written 1.10 stays "1.10".
  local function scalar(s, typed)
    s = U.trim(s)
    local inner = s:match('^"(.*)"$') or s:match("^'(.*)'$")
    if inner then return inner end
    if s:match("^%[.*%]$") then
      local list, body = {}, U.trim(s:sub(2, -2))
      local from, quote = 1, nil
      for i = 1, #body do
        local c = body:sub(i, i)
        if quote then
          if c == quote then quote = nil end
        elseif c == '"' or c == "'" then quote = c
        elseif c == "," then
          list[#list + 1] = scalar(body:sub(from, i - 1), typed)
          from = i + 1
        end
      end
      if body ~= "" then list[#list + 1] = scalar(body:sub(from), typed) end
      return list
    end
    if s == "true" then return true end
    if s == "false" then return false end
    if typed and (s:match("^%-?%d+$") or s:match("^%-?%d+%.%d+$")) then return tonumber(s) end
    return s
  end

  function Y.parse(text, source, typed)
    local doc = { value = {}, group = {}, order = {} }
    local open = { { indent = -1, path = "" } }

    local function put(path, v)
      if doc.value[path] == nil then doc.order[#doc.order + 1] = path end
      doc.value[path] = v
    end

    for n, raw in ipairs(U.split(text, "\n")) do
      local line = strip_comment(raw)
      if line:match("%S") then
        local at = string.format("%s: yaml line %d", source, n)
        if line:find("\t") then U.fail("%s: tabs are not allowed", at) end
        local indent = #line:match("^ *")
        local body = line:sub(indent + 1)
        while open[#open].indent >= indent do open[#open] = nil end
        local top = open[#open]
        local item = body:match("^%-%s+(.*)$")
        if item then
          if top.path == "" or top.kind == "group" then U.fail("%s: list item outside a list", at) end
          if top.kind ~= "list" then
            top.kind = "list"
            doc.group[top.path] = nil
            put(top.path, {})
          end
          table.insert(doc.value[top.path], scalar(item, typed))
        else
          local name, rest = body:match("^([%a_][%w_]*):(.*)$")
          if not name or (rest ~= "" and not rest:match("^%s")) then U.fail("%s: cannot read '%s'", at, body) end
          if top.kind == "list" then U.fail("%s: key inside a list", at) end
          top.kind = "group"
          local path = top.path == "" and name or top.path .. "." .. name
          if doc.value[path] ~= nil or doc.group[path] then U.fail("%s: duplicate key '%s'", at, path) end
          rest = U.trim(rest)
          if rest == "" then
            doc.group[path] = true
            open[#open + 1] = { indent = indent, path = path }
          elseif rest == "{}" then
            doc.group[path] = true
          else
            put(path, scalar(rest, typed))
          end
        end
      end
    end
    return doc
  end

  -- The first fenced yaml block of a Markdown file.
  function Y.read(path, typed)
    local block, inside = {}, false
    for _, line in ipairs(U.split(U.read(path), "\n")) do
      if inside then
        if line:match("^```%s*$") then
          return Y.parse(table.concat(block, "\n"), path, typed)
        end
        block[#block + 1] = line
      elseif line:match("^```yaml%s*$") then
        inside = true
      end
    end
    U.fail("%s: no complete yaml block found", path)
  end

  return Y
end
