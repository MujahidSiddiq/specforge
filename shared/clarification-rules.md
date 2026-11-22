# Clarification rules

Shared by the intake guides and the orchestrator. The user is the design
authority: the assistant documents and organizes the design and never makes
design decisions.

## Kinds of information

Every piece of information has exactly one of these states. Keep them
apart, in the analysis report and in the document.

| State | Meaning | Appears in the document as |
|---|---|---|
| Confirmed | Stated in an input, or answered by the user | Fact |
| Derived | Read from RTL, not yet confirmed (rtl approach) | Fact, once confirmed; until then a question |
| Pending | Missing, ambiguous or contradictory | Open point, if still open at release |
| Suggestion | The assistant's recommendation | Nothing, until the user approves it |
| Approved assumption | An assumption the user accepted | Stated as an assumption |

A suggestion or a derived fact never becomes design information without
the user's approval.

## When to ask

Ask when the answer changes what the document says: a missing behaviour, a
contradiction, an ambiguous statement, an unclear name, an RTL behaviour
whose intent is not known. Do not ask when the inputs already answer the
question, or when the answer would not change the document.

## How to ask

- **Short and numbered.** One decision per question, in one or two
  sentences.
- **With a proposed default.** Every question offers the answer the
  assistant would choose, so the user can accept it with one word. The
  default is marked as a proposal, never written into the document before
  the user accepts it.
- **With the reason when it is not obvious:** what in the inputs raised the
  question (file and section, or RTL file and line) and what it affects.
- **Grouped by topic**, most blocking first. Ask the questions that block
  the outline in one batch; ask questions that affect only one section
  when that section is drafted.
- **Not too many at once.** About ten per batch; more means the inputs need
  a conversation first.

Example:

```
3. When `flush` and `push` are both high in one cycle, does the push take
   effect? Input: design-info/control.md, Section 2.4 lists both but not
   their priority. Proposed default: flush wins and the push is discarded.
```

## Recording

- Every question goes into the project's `clarifications.md` with its ID,
  source, proposed default and status, before it is asked.
- Answers are recorded with their date. "Yes" to a default records the
  default as the answer, with status `default`.
- An answer is never deleted. A changed answer gets a new row that
  supersedes the old one.
- **Used in** lists the sections, tables and figures that depend on the
  answer, so a later change can be traced.
- Instructions the user gives about the document itself (words to avoid,
  style changes, page budget) are recorded too.

## After an answer

Update the analysis report and, if drafting has started, the affected
sections. A new answer that contradicts approved content is handled as a
change: impact first, the user's approval, then the edit and a revision
history entry.
