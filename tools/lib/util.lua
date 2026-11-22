-- specforge -- file, path, text and process helpers.
-- Runs on texlua, which ships with every LuaLaTeX installation.

local lfs = lfs or require("lfs")
local U = {}

U.windows = os.type == "windows"

-- An expected, user-facing error (no stack trace).
function U.fail(fmt, ...)
  error({ specforge = select("#", ...) > 0 and string.format(fmt, ...) or fmt }, 0)
end

U.warnings = 0
function U.warn(msg)
  U.warnings = U.warnings + 1
  io.stdout:write("WARNING: ", msg, "\n")
end
function U.say(msg) io.stdout:write(msg, "\n") end

-- ---- Text ---------------------------------------------------------------

function U.trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

-- Splits on a single character, keeping empty fields.
function U.split(s, sep)
  local out, from = {}, 1
  while true do
    local at = s:find(sep, from, true)
    if not at then out[#out + 1] = s:sub(from); return out end
    out[#out + 1] = s:sub(from, at - 1)
    from = at + #sep
  end
end

function U.set(list)
  local out = {}
  for _, v in ipairs(list) do out[v] = true end
  return out
end

function U.len(s) return utf8.len(s) or #s end

-- A number as LaTeX and Markdown expect it: 22, 0.88, never 22.0.
function U.num(n) return string.format("%.14g", n) end

local tex_char = {
  ["\\"] = "\\textbackslash{}", ["&"] = "\\&", ["%"] = "\\%", ["$"] = "\\$",
  ["#"] = "\\#", ["_"] = "\\_", ["{"] = "\\{", ["}"] = "\\}",
  ["~"] = "\\textasciitilde{}", ["^"] = "\\textasciicircum{}",
}

-- Literal text for LaTeX, in one pass so that no escape is escaped again.
function U.tex_literal(s) return (tostring(s):gsub("[\\&%%$#_{}~^]", tex_char)) end

-- Prose for LaTeX: literal, plus the dashes as LaTeX ligatures.
function U.tex(s)
  return (U.tex_literal(s):gsub("\226\128\148", "---"):gsub("\226\128\147", "--"))
end

-- ---- Paths (always with forward slashes) --------------------------------

function U.slashes(p)
  p = p:gsub("^\\\\%?\\", "")
  if U.windows then p = p:gsub("\\", "/") end
  return p
end

function U.is_absolute(p)
  return p:match("^/") ~= nil or p:match("^\\") ~= nil or p:match("^%a:") ~= nil
end

function U.normalize(p)
  p = U.slashes(p)
  local prefix = p:match("^%a:/") or p:match("^//") or p:match("^/") or ""
  local parts = {}
  for part in p:sub(#prefix + 1):gmatch("[^/]+") do
    if part == ".." then
      if #parts > 0 and parts[#parts] ~= ".." then parts[#parts] = nil
      elseif prefix == "" then parts[#parts + 1] = part end
    elseif part ~= "." then
      parts[#parts + 1] = part
    end
  end
  local out = prefix .. table.concat(parts, "/")
  return out == "" and "." or out
end

function U.join(a, b)
  if U.is_absolute(b) then return U.normalize(b) end
  return U.normalize(a .. "/" .. b)
end

function U.abs(p)
  if U.is_absolute(p) then return U.normalize(p) end
  return U.join(U.slashes(lfs.currentdir()), p)
end

function U.dirname(p) return U.slashes(p):match("^(.*)/[^/]*$") or "." end
function U.basename(p) return U.slashes(p):match("([^/]*)$") end

local function key(p) return U.windows and p:lower() or p end

-- True when child is strictly inside parent.
function U.inside(child, parent)
  parent = parent:gsub("/+$", "") -- "C:/" and "/"
  return #child > #parent + 1 and key(child):sub(1, #parent + 1) == key(parent) .. "/"
end

-- True when both are the same path as written (links are not resolved).
function U.same(a, b) return key((a:gsub("/+$", ""))) == key((b:gsub("/+$", ""))) end

-- Path of target relative to the folder base; absolute on another drive.
function U.relative(base, target)
  local b, t = U.split(U.abs(base), "/"), U.split(U.abs(target), "/")
  if key(b[1]) ~= key(t[1]) then return U.abs(target) end
  local i = 1
  while b[i] and t[i] and key(b[i]) == key(t[i]) do i = i + 1 end
  local out = {}
  for _ = i, #b do out[#out + 1] = ".." end
  for j = i, #t do out[#out + 1] = t[j] end
  return #out == 0 and "." or table.concat(out, "/")
end

-- ---- Files ----------------------------------------------------------------

local function mode(p) return lfs.attributes(p, "mode") end
function U.is_file(p) return mode(p) == "file" end
function U.is_dir(p) return mode(p) == "directory" end
function U.mtime(p) return lfs.attributes(p, "modification") end

function U.mkdir(p)
  p = U.normalize(p)
  if U.is_dir(p) then return end
  local parent = U.dirname(p)
  if parent ~= "." and parent ~= p and parent ~= "" and not parent:match("^%a:$") then U.mkdir(parent) end
  local ok, err = lfs.mkdir(p)
  if not ok and not U.is_dir(p) then U.fail("cannot create folder %s: %s", p, tostring(err)) end
end

function U.read_bytes(p)
  local f, err = io.open(p, "rb")
  if not f then U.fail("cannot read %s: %s", p, tostring(err)) end
  local s = f:read("*a")
  f:close()
  return s
end

local function from_utf16(s, little)
  local out, i = {}, 3
  local function unit()
    local a, b = s:byte(i, i + 1)
    i = i + 2
    if not b then return nil end
    return little and a + b * 256 or a * 256 + b
  end
  while true do
    local u = unit()
    if not u then break end
    if u >= 0xD800 and u < 0xDC00 then
      local low = unit() or 0xDC00
      u = 0x10000 + (u - 0xD800) * 0x400 + (low - 0xDC00)
    end
    out[#out + 1] = utf8.char(u)
  end
  return table.concat(out)
end

-- Text as UTF-8 with LF line ends. Accepts a byte-order mark and UTF-16,
-- which Windows editors and shells write.
function U.read(p)
  local s = U.read_bytes(p)
  if s:sub(1, 2) == "\255\254" then s = from_utf16(s, true)
  elseif s:sub(1, 2) == "\254\255" then s = from_utf16(s, false)
  elseif s:sub(1, 3) == "\239\187\191" then s = s:sub(4) end
  if not utf8.len(s) then U.fail("%s is not UTF-8 text: save it as UTF-8", p) end
  return (s:gsub("\r\n", "\n"))
end

function U.write(p, s)
  U.mkdir(U.dirname(p))
  local f, err = io.open(p, "wb")
  if not f then U.fail("cannot write %s: %s (is it open in another program?)", p, tostring(err)) end
  f:write(s)
  f:close()
end

function U.copy(from, to) U.write(to, U.read_bytes(from)) end

-- Names of the files in a folder that match a Lua pattern, sorted.
function U.list(dir, pattern)
  local out = {}
  if not U.is_dir(dir) then return out end
  for name in lfs.dir(dir) do
    if name:match(pattern or ".") and U.is_file(dir .. "/" .. name) then out[#out + 1] = name end
  end
  table.sort(out, function(a, b)
    if a:lower() ~= b:lower() then return a:lower() < b:lower() end
    return a < b
  end)
  return out
end

-- Relative paths of all files below a folder, sorted. Skips dot-folders and
-- does not follow symbolic links.
function U.walk(dir, pattern)
  local out = {}
  local function visit(rel)
    local here = rel == "" and dir or dir .. "/" .. rel
    for name in lfs.dir(here) do
      if name:sub(1, 1) ~= "." then
        local r = rel == "" and name or rel .. "/" .. name
        local full = dir .. "/" .. r
        local link = lfs.symlinkattributes and lfs.symlinkattributes(full, "mode") == "link"
        if not link then
          if U.is_dir(full) then visit(r)
          elseif name:lower():match(pattern or ".") then out[#out + 1] = r end
        end
      end
    end
  end
  if U.is_dir(dir) then visit("") end
  table.sort(out, function(a, b) return a:lower() < b:lower() end)
  return out
end

-- ---- Temporary work folders -----------------------------------------------

local created = {}
local seeded = false

function U.tempdir()
  if not seeded then
    math.randomseed(os.time() + math.floor(os.clock() * 1e6))
    seeded = true
  end
  local base = U.slashes(os.getenv("TEMP") or os.getenv("TMPDIR") or "/tmp"):gsub("/+$", "")
  for _ = 1, 100 do
    local d = string.format("%s/specforge-%d-%06d", base, os.time(), math.random(0, 999999))
    if lfs.mkdir(d) then created[d] = true; return d end
  end
  U.fail("cannot create a temporary folder in %s", base)
end

-- Deletes a folder, and only one that tempdir() created in this run.
function U.remove_tempdir(d)
  if not created[d] then U.fail("refusing to delete %s", tostring(d)) end
  local function remove(p)
    for name in lfs.dir(p) do
      if name ~= "." and name ~= ".." then
        local full = p .. "/" .. name
        local link = lfs.symlinkattributes and lfs.symlinkattributes(full, "mode") == "link"
        if not link and U.is_dir(full) then remove(full) else os.remove(full) end
      end
    end
    lfs.rmdir(p)
  end
  remove(d)
  created[d] = nil
end

-- ---- Programs --------------------------------------------------------------

-- Absolute path of a program: the folder of the TeX binaries first, then
-- PATH. The current folder is never searched, so a project cannot supply
-- the program that gets run.
function U.which(name)
  local file = U.windows and name .. ".exe" or name
  local dirs = { kpse.var_value("SELFAUTOLOC") }
  for _, d in ipairs(U.split(os.getenv("PATH") or "", U.windows and ";" or ":")) do
    d = d:gsub('"', "")
    if d ~= "" and d ~= "." and U.is_absolute(d) then dirs[#dirs + 1] = d end
  end
  for _, d in ipairs(dirs) do
    local p = U.slashes(d):gsub("/+$", "") .. "/" .. file
    if U.is_file(p) then return p end
  end
  return nil
end

-- Runs a program without a shell; returns its exit code.
function U.run(exe, args, cwd)
  local cmd = { [0] = exe, (U.basename(exe):gsub("%.exe$", "")) }
  for _, a in ipairs(args) do cmd[#cmd + 1] = a end
  local back = lfs.currentdir()
  if cwd and not lfs.chdir(cwd) then U.fail("cannot enter %s", cwd) end
  io.stdout:flush()
  local code = os.spawn(cmd)
  if cwd then lfs.chdir(U.slashes(back)) end
  return code
end

return U
