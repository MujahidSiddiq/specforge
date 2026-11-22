# Install on a computer

specforge itself needs no installation: copy the folder anywhere. A
computer that builds the PDF needs LuaLaTeX.

## What has been tested

| System | State |
|---|---|
| Windows 11, MiKTeX 25.12 | Tested |
| Windows with TeX Live | Not tested |
| Linux with TeX Live | Not tested |
| macOS with MacTeX | Not tested |

On an untested system, start with `doctor --build`; it shows whether it
works there.

## 1. Install LaTeX (only if it is missing)

| System | Install | Packages to check |
|---|---|---|
| Windows | MiKTeX from <https://miktex.org>, or TeX Live | `sourcesans`, `sourcecodepro`, `tikz-timing`, `preview` |
| Linux | TeX Live, preferably the full installation | the same; distribution packages may group them differently |
| macOS | MacTeX from <https://tug.org/mactex/> | the same |

The figure previews also need `pdftocairo`. MiKTeX includes it. On Linux
and macOS it is part of poppler. Without it the PDF still builds.

If `doctor` reports a missing package or font, install it with the package
manager of the TeX distribution (MiKTeX Console, or `tlmgr install <name>`
for TeX Live) and run `doctor` again.

## 2. Copy specforge

Use a clone of the repository or extract the release zip, for example to
`D:\specforge` or `~/specforge`. Keep it outside your design projects.

## 3. Check the computer

Windows (PowerShell):

```powershell
& "D:\specforge\specforge.cmd" doctor --build
```

Linux or macOS:

```sh
sh ~/specforge/specforge.sh doctor --build
```

It must say `This computer can build specforge documents.` A MiKTeX line
`major issue: So far, you have not checked for MiKTeX updates` is only a
reminder and can be ignored.

## 4. Create a project

Make one project folder for each design, outside specforge.

From Markdown design information:

```powershell
& "D:\specforge\specforge.cmd" new "D:\designs\fifo\spec" --approach design-info --input "D:\designs\fifo\design-info" --title "Example FIFO" --short FIFO --author "Your Name"
```

From RTL:

```powershell
& "D:\specforge\specforge.cmd" new "D:\designs\fifo\spec" --approach rtl --input "D:\designs\fifo\rtl" --top fifo_top --title "Example FIFO" --short FIFO --author "Your Name"
```

`project.md` and `style.md` in the new folder can be edited afterwards.
The input folder is stored as a path relative to the project, so move both
together when you change computers.
