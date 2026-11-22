# Clarification register

One row per question. Questions are short, numbered and come with a proposed
default. An answer is never removed; a changed answer gets a new row that
supersedes the old one.

| Status | Meaning |
|---|---|
| `open` | Asked, not answered |
| `answered` | Answered by the user; the answer is used |
| `default` | The user accepted the proposed default |
| `superseded` | Replaced by a later question (named in Answer) |
| `withdrawn` | No longer needed (reason in Answer) |

| ID | Date | Source | Question | Proposed default | Status | Answer | Used in |
|---|---|---|---|---|---|---|---|
| Q-1 | | | | | open | | |

**Source** names where the question comes from: an input file and section,
an RTL file and line, or a review finding.
**Used in** names the sections, tables and figures that depend on the
answer, so that a later change can be traced.
