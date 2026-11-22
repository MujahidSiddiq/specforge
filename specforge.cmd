@echo off
rem specforge launcher for Windows. Finds texlua on PATH or in the usual
rem MiKTeX and TeX Live folders; the current folder is never searched.
setlocal
set "SF_TEXLUA="
for %%I in (texlua.exe) do set "SF_TEXLUA=%%~$PATH:I"
if defined SF_TEXLUA goto run
for %%D in ("%LOCALAPPDATA%\Programs\MiKTeX\miktex\bin\x64" "%ProgramFiles%\MiKTeX\miktex\bin\x64") do if exist "%%~D\texlua.exe" set "SF_TEXLUA=%%~D\texlua.exe"
if defined SF_TEXLUA goto run
for /d %%Y in ("%SystemDrive%\texlive\20*") do if exist "%%~Y\bin\windows\texlua.exe" set "SF_TEXLUA=%%~Y\bin\windows\texlua.exe"
if defined SF_TEXLUA goto run
echo ERROR: texlua was not found. Install MiKTeX or TeX Live, see docs\install.md 1>&2
exit /b 1

:run
"%SF_TEXLUA%" "%~dp0tools\specforge.lua" %*
exit /b %ERRORLEVEL%
