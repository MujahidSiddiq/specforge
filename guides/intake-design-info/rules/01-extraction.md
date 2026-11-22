# 01 - Extraction

## What to extract

Use the groups of `<specforge>/shared/hls-information-checklist.md`:

| Group | Look for |
|---|---|
| Structure | Module and block names, what each block does, which block contains which, connections |
| Interfaces | Signal and port names, widths, directions, who drives and who uses them, when they are valid |
| Behaviour | "When X, then Y" statements, sequences, conditions, cycle relationships, outputs per condition |
| Boundary cases | Empty, full, overflow, wrap, ignore, "never", "cannot occur" |
| Exceptional conditions | Reset, flush, cancel, error, priority, simultaneous events |
| Parameters | Configurable values, defaults, minimums, ranges |
| Constraints | "Must", "is guaranteed", "is never", assumptions on the environment, limitations |
| Document wishes | Figure descriptions, terms to use or avoid, required sections |

## How to record

- One fact per row, in the user's terms. Keep the input's names exactly;
  note obvious typos as findings instead of correcting them silently.
- Every fact has a source: file name and section heading (or line, for
  files without headings).
- Facts from the inputs are **confirmed**. A fact the assistant infers
  (for example "the output is therefore registered") is a **suggestion**
  and becomes a question.
- Figure descriptions given by the user are recorded in full: blocks,
  positions, connections, labels, style. They are drawn as described.

## Reading unstructured input

- A statement can be spread over several paragraphs or files; combine it,
  and cite every source.
- Tables in the inputs are facts row by row.
- Examples and scenarios in the inputs are behaviour too: extract the rule
  each one shows, and check it against the stated rules (an example that
  contradicts a rule is a finding).
- Instructions to the assistant ("draw the figure like this", "do not use
  the word X") are document wishes, not design facts.
