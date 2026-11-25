# 02 - Page maximum

## Target

`page_budget.max` in `project.md` is the user's page limit: the total page
count, including the front matter, must not exceed it. There is no
minimum: a small design gives a short document, and nothing is padded.
(`page_budget.min`, from projects of 0.2, only adds a note to the build
output.) The build reports the count after every build.

The limit never removes content (`GUIDE.md`, rule 4). The document is fitted
by writing and layout, and if the complete design does not fit, the user
decides.

## Estimating the length

Estimate before writing the outline, from the counts found in the
analysis:

```
pages ≈ F                              front matter: 2, or 3 when the revision history has several entries
      + 1                              introduction
      + D × L + 0.3                    design overview; D = block diagrams, L = 0.6 high-level, 0.9 detailed
      + 0.5 + S / 30 + 0.25 × K        interfaces; S = signals in tables, K = packets with field tables
      + Σ (1 + 1.5 × E + 0.5 × W)      behaviour chapters; E = worked examples, W = timing diagrams
      + 0.8 × M + 0.15 × R + 0.5 × T   block chapters; M = state machines, R = storage elements, T = timing diagrams
      + 1                              exceptional conditions
      + 1                              constraints, assumptions and limitations
      + 0.5                            references
```

Detailed diagrams count more because crowded ones are split
(`05-diagram-levels.md`). The factors for signals, packets, state machines
and block chapters are first estimates: after each document, compare the
estimate with the result and record the difference in specforge's
`CHANGELOG.md`, so that the factors improve.

Earlier documents, which left signal lists and internal detail out,
measured: 15 pages estimated 14.7; 13 pages estimated 13.7 (twice).

Record the estimate, with the counts used, in `outline.md`.

## Fitting the maximum

If the estimate or a build exceeds the maximum, apply these steps in
order, rebuilding after each, and stop when the document fits:

1. **Write tighter.** One statement per fact; no repetition between
   chapters; refer back instead of explaining again.
2. **Compact tables.** Combine small tables of the same kind; use compact
   description cells; keep every row.
3. **Compact figures.** Draw at the final size with less empty space;
   place a figure next to its first reference so that pages fill; never
   let labels fall below 8 pt.
4. **Compact layout,** through `style.md` overrides, and tell the user
   which ones you set: `page.margin_mm` down to 18,
   `page.class_font_size_pt` 10, `figures.max_height_fraction` down to
   0.38, `front_matter.share_one_page` true.
5. **Report and ask.** Build, and tell the user the smallest page count
   reached with the complete content. Offer the choices: raise the
   maximum, or name content to leave out (which the user chooses). Wait
   for the answer.

Never leave content out, shorten a table or change the diagram level to
meet the maximum without the user's approval.
