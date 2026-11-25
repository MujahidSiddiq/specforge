# design-spec

A **design specification** describes a hardware design completely: its
purpose, its organization, every interface signal, its storage and state
machines, and its behaviour cycle by cycle where the inputs give it. A
reader (an architect, an integrator, a verification engineer, a new team
member) learns from it what the design is for, how to connect to it and
how it behaves in every condition, without reading the RTL.

The user chooses two things that change the form, never the content:

| Setting in `project.md` | Values | Changes |
|---|---|---|
| `diagrams` | `detailed`, `high-level` | Only how much each diagram shows (`rules/05-diagram-levels.md`). The text, tables and timing are the same at both levels |
| `page_budget.max` | a number of pages | The maximum length. The document is fitted by layout, never by leaving content out (`rules/02-page-budget.md`) |

| Task | Read |
|---|---|
| Planning the outline and the page estimate (workflow step 4) | `rules/01-outline.md`, `rules/02-page-budget.md` |
| Writing a chapter | `rules/03-content.md` |
| Planning or drawing any diagram | `rules/05-diagram-levels.md` |
| Reviewing a draft or releasing it | `rules/04-acceptance.md` |

How the document is written, drawn and built is defined by the
`latex-document` guide.

## Rules that always apply

1. **Complete.** Every block, interface signal, parameter, storage
   element, state machine, operation and condition that the inputs give is
   in the document, at the level of detail the inputs give it.
2. **Behaviour, not code.** Describe what the design does and when, in the
   terms of its signals and blocks. Never copy RTL into the document.
3. **The same text at every diagram level.** The `diagrams` setting
   changes diagrams only. Never shorten the text, a table or a timing
   description because the diagrams are high-level.
4. **Fit by layout, not by omission.** The page maximum is met by
   compact writing and layout. If the complete design does not fit, report
   the smallest length you can reach and ask; never drop content on your
   own.
5. **The outline is approved before drafting.** The outline (chapters,
   sections, pages, figures, tables, sources) is written to the project's
   `outline.md` and approved by the user.
6. **Nothing invented.** A behaviour that the inputs do not settle is a
   question in `clarifications.md`; if it stays open, it is an open point
   in the document.

Projects made with specforge 0.2 have `document_type: high-level-spec`.
They still build. Writing new content for such a project follows this
guide; ask the user before changing the type in `project.md`.
