# 02 - Page budget

## Target

The total page count, including the front matter, is between
`page_budget.min` and `page_budget.max` in `project.md` (default 10 to 15).
The build reports the count after every build.

## Allocation

Allocate pages in the outline before drafting. For a target of T pages:

| Part | Pages | Notes |
|---|---|---|
| Front matter | 2 to 3 | Title page; document information, revision history and contents on one or two pages |
| 1 Introduction | 1 | |
| 2 Design Overview | 2 to 3 | About one page per hierarchy diagram with its text |
| 3 Interfaces | 1 to 2 | Grouped interface tables, not one row per signal |
| Behaviour chapters | the rest | About 1 page per chapter; up to 3 for the most complex flow with its worked example |
| Exceptional Conditions | 1 | |
| Constraints, Assumptions and Limitations | 1 | |
| References | 0.5 | May share a page |

The parts other than the behaviour chapters total about 8.5 to 12.5 pages,
which leaves about 2.5 to 6.5 pages for the behaviour chapters within a
15-page budget.

## Reference calibration

The values above were measured on the reference document specforge was
derived from (a 15-page HLS of a design with two major blocks of three
sub-blocks each):

| Part | Pages |
|---|---|
| Front matter | 3 |
| Introduction (with terminology table) | 1 |
| Design Overview (three hierarchy diagrams, parameter table) | 2 |
| Interfaces (12 interface groups in two tables) | 1 |
| Three behaviour chapters | 1, 1, 3 (the last with a worked example of two figures and a table, and a timing diagram) |
| Exceptional Conditions (flush, simultaneous operations) | 1 |
| Constraints, Assumptions and Limitations | 1 |
| References | 1 |
| **Total** | **15**, with 6 figures and 10 tables |

## Estimating the length of a new design

Estimate before writing the outline:

```
pages ≈ F                          front matter: 2 for a first revision, 3 when the
                                   revision history has several entries
      + 1                          introduction
      + 0.6 × D + 0.3              design overview; D = hierarchy diagrams (+0.3 for the parameter table)
      + 0.5 + 0.05 × G             interfaces; G = interface groups (external and internal)
      + Σ (1 + 1.5 × E + 0.5 × W)  behaviour chapters; E = worked examples, W = timing diagrams in the chapter
      + 1                          exceptional conditions
      + 1                          constraints, assumptions and limitations
      + 0.5                        references
```

For the reference document (F = 3, D = 3, G = 12, three behaviour chapters
with E = 1 and W = 1 in one of them) this gives 14.7 pages; the result was
15.

Calibration from the first two projects built with specforge (both first
revisions, F = 2):

| Project | Estimate | Result |
|---|---:|---:|
| High-level specification from RTL | 13.7 | 13 |
| High-level specification from design information | 13.7 | 13 |

Both came out about 0.7 pages below the estimate because short chapters
share pages; no factor is changed for that yet.

Record the estimate in `outline.md`. If it exceeds `page_budget.max`, apply
the techniques below in the outline, and if it still exceeds the budget,
ask the user whether to raise the budget or to drop content (and which).
After each document, compare the estimate with the result and note
systematic differences in specforge's `CHANGELOG.md`, so the factors improve
over time.

## Fitting the budget

Apply in this order, stopping when the document fits:

1. Write tighter: one statement per fact; no repetition between chapters;
   refer back instead of explaining again.
2. Group interfaces: one table row per interface group, not per signal;
   leave widths and timing to the detailed specification.
3. Merge an end-to-end scenario into the behaviour chapter it illustrates
   instead of a separate scenarios chapter.
4. Limit timing diagrams to the one flow where cycle order matters most.
5. Use the compact layout defaults: chapters run on, front matter on one
   page, contents with chapters only, no lists of figures or tables,
   figures scaled to under half a page (all are the style defaults).
6. Drop optional sections (see `01-outline.md`).
7. Ask the user.

A document below `page_budget.min` is not padded: check that nothing from
the inputs is missing, and report the shortfall.
