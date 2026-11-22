# 02 - What the RTL cannot tell

These items are never taken from the RTL alone. Ask about each one that the
notes do not already answer, with a proposed default derived from the RTL.

| Topic | Question to settle | Proposed default from |
|---|---|---|
| Purpose | What is the design for, and where does it sit in the system? | Module names, header comments |
| Names | What are the blocks called in prose (the specification's names, not the instance names)? | Module and instance names, expanded |
| Roles | Is the derived one-sentence role of each block right? | The analysis |
| Interface groups | Are the proposed groups and their purposes right? | Port names and prefixes |
| Environment guarantees | Which input combinations never occur? Which protocol does the environment follow? | Assertions; logic that assumes it |
| Feature or defect | For every surprising behaviour: is it intended? | None: ask without a default if unsure |
| Unhandled cases | Input combinations the logic does not handle explicitly: intended, guaranteed not to occur, or a gap? | Priority order in the code |
| Reset intent | Are the registers left without reset meant to be don't-care until written? | The code |
| Configuration range | Which parameter values are supported, beyond the default? | Parameter checks, comments |
| Limitations | Are there known limitations to document? | Findings |
| Related documents | Is there a detailed or parent specification to refer to? | None |
| Document wishes | Figures, terms, sections the user wants | None |

## Rules

- **Never document a suspected defect as intended behaviour.** If the RTL
  does something that looks wrong (an output that is never driven, a case
  that corrupts state, a mismatch with a comment), ask. Until it is
  answered, it is an open point, not a statement.
- **A confirmed answer outranks the RTL.** If the user says the intended
  behaviour differs from the RTL, the specification states the intent, and
  the difference is reported to the user as a finding against the RTL.
- **Default to the RTL's behaviour** when proposing a default, and say so
  ("Proposed default: as implemented, `rtl/top.sv:120`").
- **Confirm the understanding first.** The first batch of questions always
  includes the summary of the understanding and the block roles; the rest
  depends on them.
