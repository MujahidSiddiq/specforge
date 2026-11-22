# latex-document

The methodology and rules for producing a specforge document as a PDF. The
document-type guide (for example `high-level-spec`) decides *what* the
document contains; this guide decides *how* it is written, drawn, built and
checked.

The rules are split by topic. Read the files that match the task:

| Task | Read |
|---|---|
| Setting up or reorganizing a project's files | `rules/01-source-organization.md` |
| Writing or editing chapter text | `rules/02-writing.md` |
| Adding or changing a table | `rules/03-tables.md` |
| Adding or changing a figure or timing diagram | `rules/04-figures-and-diagrams.md` |
| Changing the look of the document | `rules/05-style.md` |
| Building, checking or releasing the PDF | `rules/06-build-and-verification.md` |

## Core rules (apply to every task)

1. **Content comes only from approved sources.** Every statement traces to
   an input file, an RTL location or an answered question in
   `clarifications.md`. Unconfirmed content is an open point, never prose.
2. **Markdown chapters are the source.** The PDF and the combined Markdown
   are generated from `chapters/` and `figures/` by
   `specforge build`. Generated files are never edited by hand.
3. **One value, one place.** Document information lives in `project.md`,
   revisions in `revision-history.md`, every style value in the style keys.
   Chapters and figures never contain a hard-coded colour, font or size.
4. **Figures are native TikZ.** No screenshots, no external images, no
   generated bitmaps.
5. **A clean compile is not the end.** A document is complete only after
   the checks of `rules/06-build-and-verification.md`, including a look at
   the rendered pages.
6. **Changes are approved first.** Any change to an approved document is
   proposed with its impact (sections, tables, figures) and made only after
   the user agrees; it is then listed in `revision-history.md`.
