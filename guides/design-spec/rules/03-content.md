# 03 - Content per chapter

Describe everything the inputs give, at the detail they give it. The
diagram level never changes this text.

## 1 Introduction

- **Purpose and scope:** what the design is for, where it sits in the
  surrounding system, and what this document covers.
- **Relationship with other documents:** name any parent or related
  specification and its revision.
- **Terminology:** a table of the terms the reader needs, defined in one
  sentence each.

## 2 Design Overview

- One **hierarchy diagram** per level, from the top level down to the leaf
  modules that the inputs describe. Draw each at the chosen diagram level
  (`05-diagram-levels.md`).
- After each diagram, describe each block: its responsibility, what it
  receives, what it provides, and which chapter describes it further.
- **Configuration parameters:** a table with name, meaning, default value,
  allowed values and the constraints on the value. List the derived values
  (widths, depths) with how each is derived.
- Do not repeat the same organization in later chapters; later figures are
  behavioural (state machines, examples, timing).

## 3 Interfaces

- **Every external signal**, grouped by function (clock and reset,
  transactions, control, status). For each signal: name, width, direction,
  and description, including when it is valid, its reset value if any, and
  the encoding of each value it can take.
- The same for every interface between blocks.
- A **packet** (a SystemVerilog struct, an interface, or a group of fields
  that the inputs describe as one packet) has its own table of fields with
  widths and meaning.
- **Protocols:** handshakes, ordering and latency, with a timing diagram
  for each protocol that has more than one cycle.
- State the responsibility on each side: what the sender guarantees and
  what the receiver does in response.

## Behaviour chapters

For each flow:

- **Trigger:** the interface event or condition that starts it.
- **Effect:** what changes in the design's state and outputs, in order.
- **Timing:** in which cycle each change happens, as far as the inputs
  give it. Use a timing diagram where the order across cycles matters.
- **Priority:** which condition wins when several are true.
- **Boundary cases:** empty, full, wrap-around and no-op cases of the
  flow, each with its outcome.
- **Interaction:** how this flow hands over to other flows.
- A worked example where the prose is hard to follow.

## Block chapters

- **Storage:** every register, array, FIFO and memory: size, what is
  stored, how it is indexed, reset value.
- **State machines:** every state machine, with a state diagram
  (`latex-document`, rule 04) and a transition table:

  | Current state | Condition | Next state | Outputs |
  |---|---|---|---|

  Add a priority column when conditions can be true at the same time.
  Give the encoding of each state and the reset state. Name the outputs
  that depend on the state only and those that also depend on inputs.
- **Datapath:** what is computed, from which inputs, in which cycle;
  algorithms as numbered steps.
- **Internal timing:** cycle by cycle where the inputs give it.

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
  environment and what it guarantees in return.
- **Open points:** every open point in the document, with its ID and a
  one-line summary, or the statement that none remain.
- **Known limitations:** behaviours that are by design not handled or not
  detected, with their effect.

## References

The input documents (with revision or date) and related documents. For the
`rtl` approach: the RTL files and the version (commit or tag) the document
describes.

## What is not in the document

- RTL code. Describe behaviour, do not copy code.
- Anything the inputs do not give: no guessed timing, encoding or width.
  Ask, or write an open point.
