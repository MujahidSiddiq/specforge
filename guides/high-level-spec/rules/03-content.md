# 03 - Content per chapter

## 1 Introduction

- **Purpose and scope:** what the design is for, where it sits in the
  surrounding system, and what this document covers. State explicitly what
  is out of scope (for example internal implementation, which belongs in
  the detailed specification).
- **Relationship with other documents:** when a detailed or parent
  specification exists: this document says *what*, the other says *how*;
  name the document and its revision.
- **Terminology:** a table of the terms the reader needs, defined in one
  sentence each.

## 2 Design Overview

- One **hierarchy diagram** per level: the top level with its major blocks,
  then one diagram per major block with its sub-blocks. Together the
  diagrams establish the complete hierarchy down to the level the HLS
  describes, and no further.
- Each diagram shows the blocks, the main connections between them
  (grouped, not every signal) and the external interfaces at the boundary.
  It distinguishes external from internal interfaces, and control from
  data where that helps.
- After each diagram, describe each block in a few sentences: its
  responsibility, what it receives, what it provides.
- **Configuration parameters:** a table with name, meaning, default or
  minimum value, and the constraints on the value.
- Do not repeat the same architecture in later chapters; later figures are
  behavioural (examples, timing), not further block diagrams.

## 3 Interfaces

- Group the external signals by function (for example clock and reset,
  input transactions, control, status, outputs). For each group: direction,
  purpose, and the condition under which it carries valid information.
- Describe the interfaces between the major blocks the same way.
- State the responsibility on each side: what the sender guarantees, what
  the receiver does in response.
- Signal names may appear where the reader needs them; full signal lists
  with widths belong in the detailed specification (or, without one, in a
  compact table here).

## Behaviour chapters

For each flow:

- **Trigger:** the interface event or condition that starts it.
- **Effect:** what changes in the design's visible state and outputs, in
  order.
- **Timing:** only at the level the user of the design must know ("in the
  same cycle", "from the next cycle", "after N cycles"). Internal
  cycle-by-cycle timing belongs in the detailed specification.
- **Boundary cases:** empty, full, wrap-around, no-op cases of this flow,
  each with its outcome.
- **Interaction:** how this flow hands over to other flows.
- A worked example or timing diagram only where the prose is not enough;
  see `01-outline.md`.

## Exceptional Conditions

- Reset: what is reset and to what; what is not reset and why that is safe.
- Flush or cancel: what is discarded, what is kept, when normal operation
  resumes.
- Full, empty, overflow and underflow conditions not already covered in a
  flow, with the outcome of each.
- Simultaneous operations: a table of the combinations the interfaces
  allow, with the priority or the combined outcome of each, and the
  combinations the environment guarantees never to occur.

## Constraints, Assumptions and Limitations

- **Assumptions and guarantees:** what the design requires of its
  environment (input protocols, combinations that never occur) and what it
  guarantees in return.
- **Open points:** every open point in the document, with its ID and a
  one-line summary, or the statement that none remain.
- **Known limitations:** behaviours that are by design not handled or not
  detected, with their effect, so that the reader can judge the risk.

## References

The input documents (with revision or date) and related documents. For the
`rtl` approach: the RTL files and the version (commit or tag) the document
describes.

## Level of detail: in or out

| In the HLS | Out of the HLS (detailed specification) |
|---|---|
| Block responsibilities | Internal storage organization |
| Interface groups, direction, purpose | Every signal with width and encoding |
| Behaviour visible at block boundaries | Pointer arithmetic, internal state machines |
| Outcome of boundary cases | Algorithms step by step |
| Timing the user of the design must know | Internal cycle-by-cycle timing |
| Configuration parameters and limits | Derived widths and internal constants |
