# 01 - Extraction from RTL

Read top-down from `inputs.rtl_top`. For a high-level specification, the
hierarchy usually matters to two levels below the top; read deeper only to
understand what a block does, not to document how.

## What to extract

| Item | Where to find it | Record |
|---|---|---|
| Hierarchy | Instances in each module | Block tree with instance and module names |
| Block role (derived) | Module header comment, ports, what its outputs depend on | One sentence per block, marked derived |
| Ports | Port list of the top and of each major block | Name, direction, width (as written, with the parameter), driver and users |
| Interface groups | Port names, shared prefixes, handshake pairs (`valid`/`ready`, `req`/`ack`) | Proposed groups, marked derived |
| Parameters | `parameter`, `localparam`, packages | Name, default value, where it is used; derived widths separately |
| Clocks and resets | Sensitivity lists of sequential blocks | Clock(s); reset signal, polarity, synchronous or asynchronous; which registers are reset and which are not |
| Storage | Unpacked arrays, register files, FIFOs | Size, what is stored, how it is indexed (at a high level) |
| State machines | Enumerated state types, `case` on a state register | States and the events that move between them (summarized) |
| Operations | Output and register update logic | For each operation: trigger condition, effect, latency in cycles |
| Priority | Order of `if`/`else` branches, `case` order | Which condition wins when several are true |
| Boundary handling | Full, empty, wrap, overflow logic | Outcome of each case |
| Assertions | `assert`, `assume`, `cover` | Stated assumptions and properties: strong evidence of intent, still confirmed with the user |
| Comments | Header and inline comments | Hints of intent: lower confidence than code, and a comment that disagrees with the code is a finding |

## How to record

- Every fact carries `file:line` (or a line range) as its source and the
  state **derived**.
- Describe behaviour in the terms of the interfaces: "when `push` is high
  and the FIFO is not full, the entry is written in the same cycle and
  the count increases in the next cycle". Do not copy code.
- Keep implementation detail in the report only where it explains a
  behaviour; the specification will state the behaviour, not the code.
- Note dead code, unused ports, unconnected outputs and tied-off inputs as
  findings: they may be intended (reserved) or defects.

## Depth limit

Stop descending when a block's role and its behaviour at its ports are
clear. Internal datapath details below that level are out of scope for a
high-level specification; mention them only as "see the RTL" if the user
wants that.
