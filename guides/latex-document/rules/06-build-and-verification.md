# 06 - Build and verification

## Build

```
specforge build <project> --figures
```

- `START-HERE.md` Section 2 gives the command line of each system. If you
  cannot run it, ask the user to and work from the messages and PDF.
- Use `--figures` whenever a figure source changed, so the Markdown previews
  stay current. Use `specforge check <project>` for a quick check of the
  Markdown and the numbering without compiling.
- Run the build after every change set, not only at the end.
- The build stops with a message naming the file and line for
  configuration errors, unknown style keys, failed contrast, unsupported
  Markdown and wrong heading or caption numbers. Fix the cause; never work
  around a check.

## Checks after every build

### 1. Build output

| Message | Action |
|---|---|
| `Clean build` | none |
| `Overfull`, `Underfull ... badness 10000` | Fix the text or table that overflows; the log names the line in `build/sf-body.tex`, which maps back to a chapter |
| `undefined`, `multiply defined` | Fix the reference or label |
| `Missing character` | The font lacks a character: replace it or choose a font that has it |
| Warning `'Table N.M' does not exist` | Fix the reference in the chapter |
| Page count above the budget | Shorten (see the document-type guide), or ask the user before exceeding it |
| Page count below the budget | Check that nothing is missing; do not pad |

### 2. Visual check

Render the pages and look at them:

```
pdftocairo -png -r 60 <output>.pdf <scratch folder>/page
```

Check, at least on the title page, the front matter, every page with a
figure or table, and a representative text page:

- Nothing runs past the margins; tables and figures fit.
- Figures are readable at normal size; labels do not overlap lines or each
  other.
- No large empty areas except before a chapter that starts a new page; no
  heading alone at the foot of a page; a figure is near its first
  reference.
- Header, footer and page numbers are right; the front matter is complete.

Fix what you find and build again. **A document is not complete merely
because it compiles.**

### 3. Technical check

- All confirmed information from the inputs and `clarifications.md` is in
  the document; nothing unconfirmed is written as fact.
- Names and terms are the same everywhere (text, tables, figures).
- No section contradicts another.
- Every open point in the text is listed in the constraints chapter, and
  every listed one is still open.
- Assumptions are stated as assumptions.

### 4. Records

- `revision-history.md` has a row for the change set, naming the sections
  changed and the clarification IDs or review findings behind it.
- `colour-record.md` is current if a colour override changed.
- The checklist `<specforge>/checklists/pre-release.md` is completed before a
  revision is released.

## Delivering

Report to the user: the PDF and Markdown paths, the page count against the
budget, the warnings left (with reasons), and what was not checked.
