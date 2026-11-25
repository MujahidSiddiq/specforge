#!/bin/sh
# specforge launcher for Linux and macOS.
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd) || exit 1
texlua=$(command -v texlua 2>/dev/null)
if [ -z "$texlua" ] && [ -x /Library/TeX/texbin/texlua ]; then
  texlua=/Library/TeX/texbin/texlua
fi
if [ -z "$texlua" ]; then
  echo "ERROR: texlua was not found. Install TeX Live or MacTeX, see USER-GUIDE.md" >&2
  exit 1
fi
exec "$texlua" "$here/tools/specforge.lua" "$@"
