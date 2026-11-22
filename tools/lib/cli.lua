-- specforge -- reading the command line.
--
-- Shells lose or merge arguments in two known ways:
--   * Windows PowerShell 5.1 drops an empty value (--title ""), so the next
--     option would be taken as the value. A value never starts with --, is
--     never blank, and no command accepts extra words.
--   * Windows PowerShell 5.1 passes "C:\my folder\" so that the last
--     backslash escapes the quote and the following arguments are merged
--     into that value. The original command line still shows what was meant.

return function(U)
  local L = {}

  -- Splits a Windows command line by the usual rules, except that a
  -- backslash before a quote that is followed by a blank, inside quotes, is
  -- the end of a folder path and not an escaped quote.
  -- Returns nil when the quotes do not pair up.
  function L.split(line)
    local out, i, n = {}, 1, #line
    local function blank(k) return k > n or line:sub(k, k):match("[ \t]") ~= nil end
    while true do
      while i <= n and blank(i) do i = i + 1 end
      if i > n then return out end
      local cur, quoted = {}, false
      while i <= n and (quoted or not blank(i)) do
        local c = line:sub(i, i)
        if c == "\\" then
          local j = i
          while j <= n and line:sub(j, j) == "\\" do j = j + 1 end
          local count = j - i
          if line:sub(j, j) ~= '"' then
            cur[#cur + 1] = ("\\"):rep(count)
          elseif count % 2 == 0 then
            cur[#cur + 1] = ("\\"):rep(count // 2)
          elseif quoted and blank(j + 1) then
            cur[#cur + 1] = ("\\"):rep(count)
            quoted = false
            j = j + 1
          else
            cur[#cur + 1] = ("\\"):rep(count // 2) .. '"'
            j = j + 1
          end
          i = j
        elseif c == '"' then
          quoted = not quoted
          i = i + 1
        else
          cur[#cur + 1] = c
          i = i + 1
        end
      end
      if quoted then return nil end
      out[#out + 1] = table.concat(cur)
    end
  end

  -- The script's arguments as meant, or nil when they cannot be recovered.
  function L.repair(line)
    local words = L.split(line)
    if not words then return nil end
    for k, word in ipairs(words) do
      if U.basename((word:gsub("\\", "/"))):lower() == "specforge.lua" then
        local out = {}
        for j = k + 1, #words do
          if words[j]:find('"', 1, true) then return nil end
          out[#out + 1] = words[j]
        end
        return out
      end
    end
    return nil
  end

  -- The process's own command line as UTF-8 (Windows). The built-in ffi is
  -- used as it is: require() would also search the current folder.
  local function original()
    local ok, text = pcall(function()
      local ffi = package.loaded.ffi
      ffi.cdef("const unsigned short* GetCommandLineW(void);")
      local w = ffi.load("kernel32").GetCommandLineW()
      local out, i = {}, 0
      while tonumber(w[i]) ~= 0 do
        local u = tonumber(w[i])
        if u >= 0xD800 and u < 0xDC00 then
          i = i + 1
          u = 0x10000 + (u - 0xD800) * 0x400 + (tonumber(w[i]) - 0xDC00)
        end
        out[#out + 1] = utf8.char(u)
        i = i + 1
      end
      return table.concat(out)
    end)
    return ok and text or nil
  end

  function L.arguments(given)
    local out, merged = {}, false
    local i = 1
    while given[i] ~= nil do
      out[i] = given[i]
      if given[i]:find('"', 1, true) then merged = true end
      i = i + 1
    end
    if not (merged and U.windows) then return out end
    local line = original()
    local fixed = line and L.repair(line)
    if not fixed then
      U.fail('a value contains a double quote. Remove it, and any \\ at the end of a quoted path (write "C:\\my folder", not "C:\\my folder\\")')
    end
    return fixed
  end

  -- spec = { min, max (number of plain values), options = set, flags = set }
  function L.parse(args, spec)
    local pos, opt, i = {}, {}, 2
    while args[i] ~= nil do
      local word = args[i]
      local name = word:match("^%-%-(.+)$")
      if name then
        local flag = spec.flags and spec.flags[name]
        if not flag and not (spec.options and spec.options[name]) then
          U.fail("unknown option --%s for '%s' (see: specforge help)", name, args[1])
        end
        if opt[name] ~= nil then U.fail("--%s is given more than once", name) end
        if flag then
          opt[name] = true
        else
          i = i + 1
          local value = args[i]
          if value == nil or not value:match("%S") or value:match("^%-%-") then
            U.fail('--%s needs a value. An empty value ("") is not allowed', name)
          end
          opt[name] = value
        end
      else
        if not word:match("%S") then U.fail("an empty value is not allowed (is a variable not set?)") end
        if #pos >= (spec.max or 0) then
          U.fail("unexpected value '%s': put quotes around a value with spaces or commas", word)
        end
        pos[#pos + 1] = word
      end
      i = i + 1
    end
    if #pos < (spec.min or 0) then
      U.fail("%s is missing for '%s' (is a variable not set? see: specforge help)",
        #pos == 0 and "the project folder" or "a file", args[1])
    end
    return pos, opt
  end

  return L
end
