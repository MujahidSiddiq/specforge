# 04 - Figures and diagrams

## General

- Every figure is a native TikZ drawing in `figures/NAME.tex`, editable
  through its source and sharp at any zoom. No screenshots or external
  images.
- Draw a figure only when it shows something more clearly than text or a
  table. The document-type guide says which figures a document needs.
- Understand the logical relationships first, then arrange the drawing.
  Technical accuracy is never traded for appearance.
- When a figure is described by the user (blocks, positions, connections,
  labels), follow the description; ask about anything ambiguous before
  drawing it.

## What a figure may contain

Figures are checked before they are compiled: only drawing commands, text
commands and the styles of the library are allowed.

- No `\input`, `\usepackage`, `\usetikzlibrary`, file, shell or Lua
  commands, and no environments other than `tikzpicture`, `scope`,
  `tikztimingtable` and `center`.
- Loop variables and macros defined in a figure have one or two letters.
- The list is in `tools/lib/figcheck.lua`. Extending it is a framework
  change that the user approves.

## In a chapter

```markdown
![Top-level block diagram](../figures/fig-top.svg)

**Figure 2.1.** Top-level block diagram of `top_unit`. External ports are
shown as squares on the boundary.
```

- The image line is followed directly by the caption line
  `**Figure N.M.** Caption.`; the caption comes **below** the figure.
  Numbering is per chapter and checked by the build.
- The first sentence of the caption is a short title; it is also the entry
  in the list of figures. Further sentences explain how to read the figure.
- The text refers to the figure before it appears.

## Drawing rules

Use the styles of `latex/tikz/sf-tikz.tex`; never set a colour, line width
or font size directly in a figure.

| Element | Style |
|---|---|
| Top-level boundary | `boundary` |
| Block, interface group | `block`, `ifgroup` |
| External port on a boundary | `port` |
| Connection, with arrow | `wire`, `sigarrow` |
| Control signal (thin) / data or state signal (thick) | `ctrl`/`ctrlarrow`, `data`/`dataarrow` |
| Bundle of signals | `bundle`, `bundlearrow` |
| Highlighted path | `hlarrow` (always labelled) |
| Junction | `junction`, `djunction` |
| Signal name, width | `siglabel`, `widthlabel` |
| Block or module name, sub-label, group title | `blockname`, `modname`, `blocksub`, `grouptitle` |
| Buffer entries, pointer, range | `entry`, `entryhl`, `entrydim`, `entrywarn`, `ptrarrow`, `rangebrace` |

- Signal flows left to right and top to bottom where possible; inputs on
  the left, outputs on the right.
- Avoid crossing connections; when one is unavoidable, draw it without a
  junction dot, and use a dot only where wires really connect.
- Use the input's names for blocks and signals, in the monospace font for
  signals (`\sig{name}`) and modules (`\module{name}`).
- Label text is at least 8 pt (the style default).
- Colour never carries meaning alone: a highlighted path or entry also has
  a label, and control and data signals also differ in line width.
- When a diagram distinguishes kinds of signals (for example control and
  data), it includes a legend.
- Keep the drawing within the text width; the build scales a figure down
  to fit, which shrinks the labels, so draw it at its final size.
- A drawing shared by several documents of one project is kept in one file
  and reused, not copied.

## Timing diagrams

- Use `tikztimingtable` with the style `sfwave`, then `\wavecycles{n}` in
  `\extracode` for the cycle grid and numbers. One clock cycle is two
  timing units; draw the clock as `\sig{clk} & [sfclock]4{HL} \\` for four
  cycles.
- Name the file `fig-wave-*` or `fig-timing-*`: the build then wraps it in
  justified text, because the document's ragged-right setting
  distorts tikz-timing tables (rows shift to the right). Do not wrap it
  yourself.
- Signal names in figure labels are always written with `\sig{...}`; a bare
  underscore stops the build.
- Signals from top to bottom: clock, inputs in causal order, outputs.
- Values that are not specified are drawn as `U` (hatched), never as an
  invented value.
- Bus values are written in the `D{value}` form; use `\wavenote` for a note
  under specific cycles.
- Name the file `fig-wave-<topic>.tex` so it gets the timing height limit.

## Review

A new or significantly changed figure is reviewed before it is final:

1. Draw it and build the PDF.
2. Render the page and look at it (see `06-build-and-verification.md`).
3. Show it to the user and incorporate the feedback.
4. Treat it as approved only after the user confirms.
