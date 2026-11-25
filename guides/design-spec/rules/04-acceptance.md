# 04 - Acceptance criteria

A draft is ready for the user's review when all of these hold. Report any
that do not, with the reason.

## Coverage

- [ ] Every block in the inputs appears in a hierarchy diagram and is
      described.
- [ ] Every external signal and every interface between blocks is in a
      table with width, direction and description.
- [ ] Every packet has a table of its fields.
- [ ] Every state machine has a state diagram and a transition table with
      its reset state.
- [ ] Every storage element is described.
- [ ] Every operation and condition in the inputs is covered by a
      behaviour chapter, a block chapter or the Exceptional Conditions
      chapter, with its timing as far as the inputs give it.
- [ ] Every boundary case named in the inputs has its outcome stated.
- [ ] Every combination of simultaneous operations the interfaces allow is
      covered (outcome or guarantee that it does not occur).

## Correctness

- [ ] Every statement traces to an input or to an answered question in
      `clarifications.md`; nothing is invented.
- [ ] Unconfirmed content appears only as open points, and every open point
      is listed in the constraints chapter.
- [ ] Names, terms and numbers are the same in text, tables and figures.
- [ ] No chapter contradicts another.

## Diagram level and length

- [ ] Every diagram follows the chosen level (`05-diagram-levels.md`).
- [ ] The text is complete regardless of the diagram level.
- [ ] The page count is at most `page_budget.max`, or the user approved
      the reported minimum length.
- [ ] No content was left out to fit the page maximum without the user's
      approval.

## Form

- [ ] The build is clean and the visual check is done
      (`latex-document`, `rules/06-build-and-verification.md`).
- [ ] The outline in `outline.md` matches the document (chapters, sections,
      figures, tables).
- [ ] `revision-history.md` describes the change set.
