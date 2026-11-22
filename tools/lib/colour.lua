-- specforge -- contrast (WCAG 2) and OKLCH colour functions.

local C = {}

local function linear(c)
  if c <= 0.04045 then return c / 12.92 end
  return ((c + 0.055) / 1.055) ^ 2.4
end

local function gamma(c)
  if c <= 0.0031308 then return 12.92 * c end
  return 1.055 * c ^ (1 / 2.4) - 0.055
end

local function linear_rgb(hex)
  local r, g, b = hex:match("^#(%x%x)(%x%x)(%x%x)$")
  return linear(tonumber(r, 16) / 255), linear(tonumber(g, 16) / 255), linear(tonumber(b, 16) / 255)
end

local function to_hex(r, g, b)
  local function byte(v) return math.max(0, math.min(255, math.floor(v * 255 + 0.5))) end
  return string.format("#%02X%02X%02X", byte(r), byte(g), byte(b))
end

local function luminance(hex)
  local r, g, b = linear_rgb(hex)
  return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

function C.contrast(a, b)
  local x, y = luminance(a), luminance(b)
  return (math.max(x, y) + 0.05) / (math.min(x, y) + 0.05)
end

function C.hue(hex)
  local r, g, b = linear_rgb(hex)
  local l = (0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b) ^ (1 / 3)
  local m = (0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b) ^ (1 / 3)
  local s = (0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b) ^ (1 / 3)
  local ok_a = 1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s
  local ok_b = 0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s
  local h = math.atan(ok_b, ok_a) * 180 / math.pi
  return h < 0 and h + 360 or h
end

-- #RRGGBB of an OKLCH colour; chroma is reduced until it is inside sRGB.
function C.from_oklch(light, chroma, hue)
  local function inside(v) return v >= -0.0001 and v <= 1.0001 end
  local ch = chroma
  while ch >= 0 do
    local a, b = ch * math.cos(hue * math.pi / 180), ch * math.sin(hue * math.pi / 180)
    local l = (light + 0.3963377774 * a + 0.2158037573 * b) ^ 3
    local m = (light - 0.1055613458 * a - 0.0638541728 * b) ^ 3
    local s = (light - 0.0894841775 * a - 1.2914855480 * b) ^ 3
    local r = 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s
    local g = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s
    local bl = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
    if inside(r) and inside(g) and inside(bl) then
      local function out(v) return gamma(math.max(0, math.min(1, v))) end
      return to_hex(out(r), out(g), out(bl))
    end
    ch = ch - 0.002
  end
  local grey = gamma(light ^ 3)
  return to_hex(grey, grey, grey)
end

return C
