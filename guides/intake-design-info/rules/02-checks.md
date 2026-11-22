# 02 - Checks

Each problem found is a finding in section 5 of the analysis report, with
its kind and source, and usually a question.

## Completeness

Walk through `<specforge>/shared/hls-information-checklist.md` and mark each
item given, partly given or missing. Typical gaps:

- A signal without a direction, a width, a driver or a validity condition.
- An operation without its timing at the interfaces.
- A boundary case named but without its outcome (what happens when full?).
- Two events that can occur together with no stated priority.
- Reset or flush that does not say what happens to every state element.
- A block named in one place and never described.

## Contradictions

Compare every pair of statements about the same thing:

- The same signal with two widths, directions or meanings.
- A rule and an example that disagree.
- A block placed differently in two figure descriptions.
- A later file that changes an earlier statement: ask which one holds; do
  not assume the later one wins.
- A statement that contradicts an answered question.

## Ambiguities

- Words that allow more than one reading: "should", "may", "usually",
  "fast", "some", "etc.", "and/or".
- Time words without a reference: "immediately", "then", "after".
- Undefined terms and abbreviations.
- Pronouns whose subject is unclear.

## Naming

- The same thing under two names, or two things under one name.
- Names that clash with conventions the user has stated.

## Suggestions

Improvements the assistant would recommend (a clearer structure, a missing
figure, a better name) are recorded as findings of kind `suggestion`, kept
apart from design facts, and offered to the user; they are adopted only on
approval.
