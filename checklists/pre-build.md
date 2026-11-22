# Checklist: before presenting a build (workflow steps 6 and 7)

## Sources

- [ ] Chapter files are named `NN_name.md`, one chapter each, in order.
- [ ] Every figure in the chapters has its source in `figures/` and an
      up-to-date SVG preview (built with `--figures`).
- [ ] No colour, font or size is set in a chapter or figure.
- [ ] Every open point in the text is listed in the constraints chapter.

## Build

- [ ] The build finishes without errors.
- [ ] No overfull boxes, undefined references or missing characters, or
      each remaining warning is explained.
- [ ] No warnings about references to items that do not exist.
- [ ] The page count is within the budget, or the user approved the
      exception.

## Visual check (rendered pages)

- [ ] Title page and front matter are complete and correct.
- [ ] Every page with a table or figure: nothing past the margins; labels
      readable and not overlapping.
- [ ] No heading alone at the foot of a page; figures near their first
      reference; no large empty areas.
- [ ] Header, footer and page numbers are correct.

## Content

- [ ] The acceptance criteria of the document type are met
      (`guides/high-level-spec/rules/04-acceptance.md`).
- [ ] `outline.md` matches the document.
