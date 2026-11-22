# specforge LaTeX build

Turns a project's Markdown chapters and TikZ figures into the PDF, using the
merged style (defaults plus the project's `style.md`).

## Build

```
specforge build <project> [--figures]
specforge check <project>
```

- `--figures` also exports every `figures/*.tex` to `figures/*.svg`, so that
  the Markdown chapters show the figures. Run it whenever a figure changes.
- `check` writes only the combined Markdown and runs no LaTeX.

Requirements: LuaLaTeX, which includes `texlua`; `pdftocairo` for the
previews; the fonts named in the style. See `docs/install.md`.

## What the build does

| Step | Output |
|---|---|
| Check `project.md` and `style.md`, derive accent tokens, check contrast | `build/style-report.md` |
| Chapters and front matter to LaTeX, as data only | `build/sf-*.tex` |
| Combined Markdown | `<output.dir>/<file_name>.md` |
| Check figure sources against the allowed commands | errors with file and line |
| Figure previews (`--figures`) | `figures/*.svg` |
| Compile three times in a temporary folder, check log and page count | `build/main.log`, `<output.dir>/<file_name>.pdf` |

The build stops on any configuration error, unknown style key, failed
contrast pair, unsupported Markdown, or heading or caption number out of
sequence, and names the file and line. It warns about every reference in
the text ("Table 3.1", "Section 2.4", "Figure 1.2", "Chapter 5") that names
an item the document does not contain; a reference to another document is
written with that document's name first ("ABC Section 1.2") and is skipped.

## Project files the build reads

| File | Contents |
|---|---|
| `project.md` | Configuration (from `config-templates/`) |
| `style.md` | Style overrides (from `config-templates/`) |
| `revision-history.md` | Revision table (from `templates/`) |
| `chapters/NN_name.md` | One chapter per file, `NN` = 01, 02, ... in reading order |
| `figures/NAME.tex` | One TikZ picture per file (`tikzpicture` or `tikztimingtable`) |

The front matter (document information, revision history) is generated from
`project.md` and `revision-history.md`; there is no front-matter chapter
file.

## Markdown accepted in chapter files

| Markdown | Result |
|---|---|
| `# N. Title`, `## N.M Title`, `### N.M.K Title` | Chapter, section, subsection; numbers are checked |
| Paragraphs, `-` and `1.` lists (nested by two spaces) | Text and lists |
| `**Table N.M.** caption` line, then a table | Table with its caption above |
| `![alt](../figures/NAME.svg)`, then `**Figure N.M.** caption` | Figure from `figures/NAME.tex`, caption below |
| `> **Open point ID.** text` | OPEN POINT callout |
| `> text` | Highlighted statement |
| `` `code` ``, `**bold**`, `*italic*`, `[text](url)` | Inline formatting; code is set in the monospace font |

A `|` inside a table cell is written in backticks or as `\|`. LaTeX in
chapter text is printed as text, never executed.

Code blocks and level-4 headings are rejected. Figures named `fig-wave-*`
or `fig-timing-*` are treated as timing diagrams (larger height limit).

## Template and styles

| Folder | Contents |
|---|---|
| `template/main.tex` | Document skeleton |
| `template/preamble/` | Packages, typography, tables, macros, title page, front matter. Every value comes from a `\sf...` macro generated from the style keys |
| `tikz/sf-tikz.tex` | Diagram styles (`boundary`, `block`, `wire`, `ctrlarrow`, `dataarrow`, `hlarrow`, `port`, ...) and the timing style `sfwave` with `\wavecycles` and `\wavenote` |

Macro names follow the style keys: `headings.chapter.size_pt` becomes
`\sfHeadingsChapterSizePt`, and a true/false key such as
`body.ragged_right` becomes the conditional `\ifsfBodyRaggedRight`.

The tool is in `tools/` at the top of the specforge folder; it runs on
texlua and needs nothing else.
