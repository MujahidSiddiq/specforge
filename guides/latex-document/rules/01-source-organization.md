# 01 - Source organization

## Project files

| Path | Contents | Edited by |
|---|---|---|
| `project.md`, `style.md` | Configuration, style overrides | User (assistant on request) |
| `revision-history.md` | One row per change set | Assistant, after each approved change |
| `clarifications.md` | Questions and answers | Assistant; answers from the user |
| `chapters/NN_name.md` | One chapter per file | Assistant |
| `figures/NAME.tex` | One TikZ picture per file | Assistant |
| `figures/NAME.svg` | Preview of the figure, generated | Build (`--figures`) |
| `build/` | Intermediate files, generated | Build; never edited, not tracked |
| `<output.dir>/` | PDF and combined Markdown, generated | Build |

## Chapter files

- File name `NN_short_name.md`: `NN` is two digits from `01`, in reading
  order; `short_name` is lower case with underscores. A file starting with
  `00_` is ignored.
- Exactly one `# N. Title` heading per file, as the first heading. `N` is
  the chapter number and equals the position of the file.
- Sections are `## N.M Title`, subsections `### N.M.K Title`. Numbers are
  consecutive and are checked by the build. Level 4 is not used.
- Renumbering: when a chapter is inserted or removed, rename the files and
  renumber the headings, captions and every reference in the text, then
  build: the build reports any number that no longer matches.
- There is no front-matter chapter: the title page, document information
  and revision history are generated.

## Figure files

- File name `fig-<topic>.tex`, lower case with hyphens. Timing diagrams are
  named `fig-wave-<topic>.tex` or `fig-timing-<topic>.tex`; they get the
  larger height limit.
- Each file contains one `tikzpicture` or one `tikztimingtable` and nothing
  else: no `\begin{figure}`, no caption, no `\label`. Placement and caption
  come from the chapter.
- The same figure file may be used by more than one chapter.

## Markdown subset

Only the constructs listed in `latex/README.md` are used. The build stops
on anything else (code blocks, level-4 headings, images outside
`../figures/`) and names the file and line. In particular:

- Lists nest by two spaces.
- A table caption line comes before the table; a figure caption line comes
  directly after the image line.
- HTML is not used, except `<!-- comments -->`, which the build ignores.

## Front matter and metadata

- Title, short name, subtitle, author, organization, revision, status,
  date, language and related documents come from `project.md`.
- The revision table comes from `revision-history.md`.
- Which front-matter parts appear (document information, revision history,
  contents, lists of figures and tables) is set by the `front_matter` style
  keys.
