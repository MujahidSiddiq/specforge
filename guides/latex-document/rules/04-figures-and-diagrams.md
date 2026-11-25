# 04 - Figures and diagrams

## General

- Every figure is a native TikZ drawing in `figures/NAME.tex`, editable
  through its source and sharp at any zoom. No screenshots or external
  images.
- Draw a figure only when it shows something more clearly than text or a
  table. The document-type guide says which figures a document needs, and
  its diagram-level rule (`design-spec`, rule 05) says how much each block
  diagram shows.
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
| Bundle of signals, information flow | `bundle`, `bundlearrow` |
| Packet (struct, interface): one arrow, never its fields | `packet`, `packetarrow` |
| Highlighted path | `hlarrow` (always labelled) |
| Junction | `junction`, `djunction` |
| Signal name, width | `siglabel`, `widthlabel` |
| What an information flow carries, in words | `flowlabel` |
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

## State machine diagrams

A state machine is drawn as a state diagram, never as a block diagram.

| Element | Notation | Style |
|---|---|---|
| State | A **circle** with the state name as in the inputs. Never a box | `fsmstate` |
| Outputs that depend on the state only | Inside the circle, below the name, at most two short lines | `\fsmout{...}` |
| Reset state | An arrow from a filled dot, labelled with the reset condition | `fsmresetdot`, `fsmreset` |
| Transition | A filled-head arrow labelled `condition`, or `condition / outputs` when outputs also depend on inputs | `fsmtrans`, `fsmcond` |
| Signals into or out of the machine (only when the figure shows them) | Dashed arrows | `fsminput`, `fsmoutput` |
| Legend | Whenever more than one kind of arrow is drawn | `\fsmlegend{(x,y)}` or `\fsmlegendio{(x,y)}` |

Shape of each transition:

- **Straight** between neighbouring states when it is the only transition
  between them and crosses nothing.
- **Curved** when two states have transitions in both directions: give
  both `bend left=20`, so that they bend apart and never overlap.
- **Curved** around a state or label that lies in the way (`bend left=40`,
  or `out=` and `in=` angles).
- A **loop** (`loop above`, `loop below`, `loop left`, `loop right`) only
  for a staying condition that the reader needs, for example one with
  outputs. "Otherwise the state is kept" is said once in the caption
  instead of drawing a loop at every state.
- When conditions of one state can be true at the same time, prefix each
  label with its priority: `1: start`, `2: abort`.

Layout:

- The reset state is on the left or at the top. The main sequence runs
  left to right or clockwise; return paths run below or right to left.
- All states have the same size. Leave at least 2.6 cm between the centres
  of neighbouring states, so that labels fit.
- Every label is next to its arrow (`auto`, or `above`/`below`), with the
  `fsmcond` background so that it stays readable over other lines.
- Place the legend below or beside the states, clear of every arrow and
  label.
- At most about 10 states in one diagram (see `design-spec`, rule 05).
- The transition table in the text gives every exact condition; the
  caption names it.

Example:

```latex
\begin{tikzpicture}
  \node[fsmstate] (idle) at (0,0)   {IDLE};
  \node[fsmstate] (run)  at (3.6,0) {RUN\fsmout{busy=1}};
  \node[fsmresetdot] (rst) at (-1.6,0) {};
  \draw[fsmreset] (rst) -- node[fsmcond, above] {reset} (idle);
  \draw[fsmtrans] (idle) to[bend left=20] node[fsmcond, above] {start} (run);
  \draw[fsmtrans] (run)  to[bend left=20] node[fsmcond, below] {done / irq=1} (idle);
  \fsmlegend{(-1.6,-1.8)}
\end{tikzpicture}
```

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
