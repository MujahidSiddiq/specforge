-- specforge -- checks TikZ figure sources before they are compiled.
--
-- Figures are the only project files that are raw LaTeX, and LuaLaTeX can
-- read and write files. A figure may therefore use only the commands and
-- environments listed here: a list of what is allowed, because a list of
-- what is forbidden is easy to get around.
--
-- This reduces the risk of a figure written by someone else or by an AI. It
-- is not a sandbox: look at figures from a source you do not trust.

return function(U)
  local F = {}

  local COMMANDS = U.set({
    -- pictures and drawing
    "begin", "end", "tikz", "tikzset", "node", "draw", "path", "fill", "filldraw",
    "coordinate", "matrix", "pic", "clip", "shade", "foreach", "pgfmathsetmacro",
    "pgfmathtruncatemacro", "extracode", "wavecycles", "wavenote", "wavefont", "nrows",
    "tablerules", "fsmout", "fsmlegend", "fsmlegendio",
    -- simple programming
    "def", "newcommand", "renewcommand", "relax", "numexpr", "the", "fpeval",
    "ifnum", "ifx", "if", "ifodd", "else", "fi",
    -- text and symbols
    "sig", "param", "module", "pending", "texttt", "textbf", "textit", "textrm", "textsf",
    "textnormal", "emph", "ttfamily", "bfseries", "itshape", "sffamily", "rmfamily",
    "headingfont", "fontsize", "selectfont", "sfsize", "small", "footnotesize", "scriptsize",
    "normalsize", "centering", "justifying", "raggedright", "par", "mbox", "strut", "linebreak",
    "textcolor", "color", "detokenize", "textbackslash", "textasciitilde", "textasciicircum",
    "textunderscore", "ldots", "dots", "quad", "qquad", "vspace", "hspace", "smallskip",
    "medskip", "noindent", "linewidth", "textwidth", "baselineskip",
    -- mathematics
    "rightarrow", "leftarrow", "leftrightarrow", "uparrow", "downarrow", "Rightarrow",
    "times", "cdot", "pm", "le", "leq", "ge", "geq", "ne", "neq", "land", "lor", "lnot", "neg",
    "oplus", "log", "mathrm", "mathit", "mathbf", "text", "frac", "lfloor", "rfloor", "lceil",
    "rceil", "approx", "equiv", "infty",
    -- loop variables with more than two letters
    "txt", "sty", "lbl", "idx", "col", "row", "val", "pos", "name", "label",
  })

  local ENVIRONMENTS = U.set({ "tikzpicture", "scope", "tikztimingtable", "center" })

  local function allowed(word)
    return COMMANDS[word] -- listed
      or #word <= 2 -- loop variables and short macros: \i, \x, \dx, \xL
      or word:match("^sf%u%a+$") ~= nil -- generated style values
  end

  -- Returns a list of problems, empty when the figure is acceptable.
  function F.check(text, name)
    local problems = {}
    local code = {} -- the source without comments
    local line = 1
    local function bad(what) problems[#problems + 1] = string.format("%s:%d: %s", name, line, what) end

    local i, n = 1, #text
    while i <= n do
      local c = text:sub(i, i)
      if c == "\n" then
        line = line + 1
        code[#code + 1] = c
        i = i + 1
      elseif c == "\r" then
        bad("stray carriage return")
        i = i + 1
      elseif c == "%" then
        local e = text:find("\n", i, true)
        -- TeX also drops the line end and the next indentation
        if e then
          line = line + 1
          i = text:find("[^ \t]", e + 1) or n + 1
        else
          i = n + 1
        end
      elseif c == "^" and text:sub(i + 1, i + 1) == "^" then
        bad("^^ character codes are not allowed")
        i = i + 2
      elseif c == "\\" then
        local word = text:match("^%a+", i + 1)
        if word then
          if not allowed(word) then bad("command \\" .. word .. " is not allowed in a figure") end
          i = i + 1 + #word
          if word == "begin" or word == "end" then
            local env = text:match("^[ \t]*{(%a+)}", i)
            if not env or not ENVIRONMENTS[env] then
              bad("\\" .. word .. " allows only: tikzpicture, scope, tikztimingtable, center")
            end
          end
          code[#code + 1] = "\\" .. word .. " "
        else
          local symbol = text:sub(i + 1, i + 1)
          if symbol == "\n" then line = line + 1 end
          code[#code + 1] = " "
          i = i + 2
        end
      else
        code[#code + 1] = c
        i = i + 1
      end
    end

    -- TikZ keys and path operations that reach outside the figure
    local plain = table.concat(code)
    local function reject(pattern, what)
      local at = plain:find(pattern)
      if at then problems[#problems + 1] = name .. ": " .. what .. " is not allowed in a figure" end
    end
    reject("%f[%a]file%s*[{=\"]", "reading or writing a file")
    reject("%f[%a]function%s*[{=]", "plot function (runs gnuplot)")
    reject("%f[%a]gnuplot%f[%A]", "gnuplot")
    reject("/utils/exec", "/utils/exec")
    reject("%f[%a]prefix%s*=", "an output file prefix")
    reject("%f[%a]plot%s*file", "plot file")
    reject("/%.@", "an internal TikZ key")
    return problems
  end

  return F
end
