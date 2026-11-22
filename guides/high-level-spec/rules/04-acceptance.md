# 04 - Acceptance criteria

A draft is ready for the user's review when all of these hold. Report any
that do not, with the reason.

## Coverage

- [ ] Every major block in the inputs appears in a hierarchy diagram and is
      described in Chapter 2.
- [ ] Every external interface group appears in Chapter 3 with direction,
      purpose and validity condition.
- [ ] Every operation and condition in the inputs is covered by a
      behaviour chapter or the Exceptional Conditions chapter.
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

## Level and length

- [ ] No implementation detail beyond the "in the HLS" column of
      `03-content.md`.
- [ ] The page count is within `page_budget`, or the user approved the
      exception.
- [ ] No architecture is repeated: later figures are behavioural.

## Form

- [ ] The build is clean and the visual check is done
      (`latex-document`, `rules/06-build-and-verification.md`).
- [ ] The outline in `outline.md` matches the document (chapters, sections,
      figures, tables).
- [ ] `revision-history.md` describes the change set.
