# high-level-spec

A **high-level specification** (HLS) says *what* a design does: its
purpose, its organization into major blocks, its interfaces, and its
behaviour as seen at those interfaces. It does not say *how* the design
implements that behaviour: internal storage, pointer arithmetic,
algorithms step by step, signal-level timing of internal paths. Those
belong in a detailed design specification.

A reader of the HLS (an architect, an integrator, a verification lead, a
new team member) should, after 10 to 15 pages, know what the design is for,
what it is made of, how to connect to it, and how it behaves in every
operating condition, including the exceptional ones.

| Task | Read |
|---|---|
| Planning the outline and the page budget (workflow step 4) | `rules/01-outline.md`, `rules/02-page-budget.md` |
| Writing a chapter | `rules/03-content.md` |
| Reviewing a draft or releasing it | `rules/04-acceptance.md` |

How the document is written, drawn and built is defined by the
`latex-document` guide.

## Rules that always apply

1. **What, not how.** Every statement describes behaviour visible at a
   block boundary or at the design's interfaces. When the inputs contain
   implementation detail, the HLS states its effect and leaves the detail
   out (or refers to the detailed specification, if there is one).
2. **Complete at its level.** Every major block, every interface group and
   every operating condition in the inputs appears in the HLS. Leaving out
   detail is intended; leaving out a behaviour is an error.
3. **The page budget is a requirement.** The outline allocates pages
   before drafting; the draft is fitted to the budget, not the budget to
   the draft. Exceeding `page_budget.max` needs the user's approval.
4. **The outline is approved before drafting.** The outline (chapters,
   sections, pages, figures, tables, sources) is written to the project's
   `outline.md` and approved by the user.
5. **Nothing invented.** A behaviour that the inputs do not settle is a
   question in `clarifications.md`; if it stays open, it is an open point
   in the document.
