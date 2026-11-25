# intake-rtl

Turns the RTL of a design into an analysis report and a set of
clarification questions (workflow steps 2 and 3). It writes nothing into
the document itself and never changes the RTL.

## Inputs and outputs

| | Path |
|---|---|
| Reads | `inputs.rtl` folder (`*.sv`, `*.svh`, `*.v`, `*.vh`), top module `inputs.rtl_top` |
| Reads | `inputs.notes` folder (`*.md`, optional): the user's notes on purpose and intent |
| Writes | `<project>/analysis.md`, `<project>/clarifications.md` |
| Writes | `<project>/build/rtl-inventory.md` (generated reading aid) |
| Follows | `<specforge>/shared/clarification-rules.md`, `<specforge>/shared/information-checklist.md` |

## The central rule

**RTL shows what the design does, not what it is meant to do.** Every fact
read from the RTL is **derived**, tagged with its file and line, and
becomes design information only when the user confirms it: in an answer,
or in the notes. The intent (purpose, roles, guarantees, which behaviour is
a feature and which is a defect) always comes from the user.

## Steps

1. **Record the version** of the RTL (commit, tag or date); the document
   describes that version.
2. **Inventory.** Run the reading aid:

   ```
   specforge inventory <project>
   ```

   (`START-HERE.md` Section 2 gives the command line. If you cannot run
   it, ask the user to, or list the same items by reading the RTL.)

   It lists units, the instance hierarchy, ports, parameters, clock and
   reset sensitivity, enumerated types and arrays, each with file:line. It
   is not a parser: confirm everything in the source.
3. **Read the RTL** from the top down, to the depth the high-level
   specification needs (see `rules/01-extraction.md`).
4. **Read the notes**, if any. Statements in the notes are the user's and
   count as confirmed; record each one in `clarifications.md` as an answer
   with the notes file as its source.
5. **Extract** into the analysis report, every fact with `file:line` and the
   state derived or confirmed.
6. **Check** completeness against the information checklist and find what
   the RTL cannot tell (`rules/02-intent-questions.md`).
7. **Summarize the understanding** (report section 2) in plain words: what
   the design appears to do, block by block.
8. **Ask**, most blocking first: always confirm the understanding and the
   block roles, then the intent questions. Record them.
9. **Stop** for the answers; update the report. When nothing blocks the
   outline, hand over to the outline step.

## Language rules

`rules/03-systemverilog-verilog.md` lists the constructs to watch for in
SystemVerilog and Verilog. VHDL is not supported yet.

## When the RTL changes

Re-run the inventory, compare it with the previous one, and list what
changed (ports, hierarchy, parameters, behaviour). Each change that affects
the document is proposed to the user with its impact before the document
is changed; the new RTL version is recorded in the references.
