# 05 - Diagram levels

`diagrams` in `project.md` is `detailed` or `high-level`. It decides how
much each block diagram shows. It never changes the text, the tables or
the timing: every signal is in a table in both cases (`03-content.md`).

State machines follow the notation of `latex-document` rule 04 at both
levels; the level only changes how many states and transitions one
diagram shows (below).

## Signals and packets

| Kind | What it is | Drawn as |
|---|---|---|
| Signal | One RTL port or wire, single bit or bus | An arrow with its name. Detailed level: with its width |
| Packet | A SystemVerilog struct type, an interface, or a group of fields that the inputs describe as one packet | **One** `packetarrow` labelled with the packet name. Its fields are never drawn; they are in the packet's table, and the caption or text names that table |
| Information flow | Several signals that serve one purpose (high-level level only) | One `bundlearrow` with a `flowlabel` saying what it carries, for example "write request" |

## Detailed diagrams

- Show every sub-module of the block with its instance and module name.
- Show **every signal** between the sub-modules and at the boundary, each
  with its name and width as in the RTL: `\sig{data_i[31:0]}`, or with the
  parameter: `\sig{data_i[W-1:0]}`. A single bit has no width.
- Show each packet as one `packetarrow`, never its fields.
- Clock and reset may be shown once at the boundary with the note that
  they go to every sequential block, instead of one arrow per block.
- Split a diagram that would become crowded: one diagram per sub-module,
  or one per interface group. Crowded means labels below 8 pt after
  scaling, or more than about 12 signals on one side of a block. Every
  signal still appears in some diagram or table.

## High-level diagrams

- Show the sub-modules with their names.
- Show a signal by name only when the reader needs it to follow the text:
  - handshake and flow-control signals (`valid`, `ready`, `stall`, `full`),
  - signals the behaviour chapters discuss by name,
  - the outputs that are the design's main result.
- Show all other connections as `bundlearrow`s between modules, labelled
  with the kind of information they carry ("configuration", "status",
  "read data").
- Show packets as one `packetarrow` each, as at the detailed level.
- In the text after the diagram, say which arrows group which signals, and
  refer to the interface tables for the complete list.

## State machines at each level

| Level | One diagram shows |
|---|---|
| Detailed | Every state and every transition, with the exact condition (and outputs) as in the RTL or the design information |
| High-level | Every state; transitions with the condition in words ("buffer full") where the exact expression is long. The transition table still gives every exact condition |

A state machine with more than about 10 states is split at both levels:
an overview of the state groups, then one diagram per group.

## Legend

Add a legend whenever a diagram uses more than one kind of arrow (signal,
packet, information flow, control and data, state transition and reset).
