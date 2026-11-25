# orchestrator

Runs a specforge project from configuration to a released PDF. It decides
which guide does each step, keeps the project's status, and stops at every
approval gate.

## Dispatch

| Setting in `project.md` | Value | Guide |
|---|---|---|
| `approach` | `design-info` | `guides/intake-design-info/GUIDE.md` |
| `approach` | `rtl` | `guides/intake-rtl/GUIDE.md` |
| `document_type` | `design-spec` (or `high-level-spec` from 0.2) | `guides/design-spec/GUIDE.md` |
| (always) | | `guides/latex-document/GUIDE.md` for writing, drawing, building and checking |

An unknown value stops the work with a message that names the supported
values. Project files are relative to the project folder. Framework files
(`guides/`, `shared/`, `templates/`, `checklists/`, `styles/`, `latex/`)
are relative to `<specforge>`, the folder that contains `START-HERE.md`.
Inside a guide, `rules/...` is relative to that guide.

## Starting a session

1. **Find the project.** Follow `START-HERE.md` steps 1 to 3: the
   workspace with `project_rtl` and/or `project_description`, the settings
   from the user's message (diagram level, page maximum, title, short name,
   author, colours), and `specforge new`. An existing
   `specforge_output/project.md` means the work has started.
2. **Read `status.md`** and continue from the step it records. Read the
   open questions in `clarifications.md`.
3. **Check the framework version:** if `specforge_version` differs from
   `<specforge>/VERSION`, read `CHANGELOG.md` for the versions in between,
   tell the user what changed that affects the project, and ask before
   updating `specforge_version`.

## Workflow

| Step | Do | Guide / rules | Gate | Status entry |
|---|---|---|---|---|
| 1 Configure | Check `project.md` and `style.md`: run `specforge check <project>` once chapters exist, else read both files and report errors | `checklists/intake.md` | | Configured |
| 2 Intake | Analyze the inputs; write `analysis.md` | intake guide | | Analyzed |
| 3 Clarify | Ask the questions; record them | `shared/clarification-rules.md` | **Answers** | Clarified (date) |
| 4 Outline | Write `outline.md` with the page estimate | `design-spec` rules 01, 02, 05 | **Approval** | Outline approved (date) |
| 5 Draft | Write chapters and figures, one chapter or a few at a time | `design-spec` rule 03, `latex-document` | Figures reviewed by the user | Drafting: chapters done |
| 6 Build | Run `specforge build <project> --figures`, or ask the user to | `latex-document` rule 06 | | Built (pages) |
| 7 Verify | Build output, visual, technical checks; acceptance criteria | `latex-document` rule 06, `design-spec` rule 04, `checklists/pre-build.md` | | Verified |
| 8 Release | Present the PDF; fix review findings; complete `checklists/pre-release.md`; update the revision history | `templates/review-record.md` | **Approval** | Released (revision, date) |

Steps 2 and 3 repeat until nothing blocks the outline. During drafting,
new questions go back to step 3 for the affected sections only.

## Gates

At a gate, stop and present what the user must decide, as short numbered
questions with proposed defaults. Do not continue past a gate on silence,
on a guess, or on approval given for an earlier step. Record each approval
in `status.md` with its date.

## Changes after approval

A change to an approved outline or document (new input, changed answer,
review finding, user request):

1. List the affected chapters, sections, tables and figures (from the
   "Used in" column of `clarifications.md` and from `outline.md`).
2. Propose the change and its impact; wait for approval.
3. Make the change, rebuild, verify the affected pages.
4. Add a row to `revision-history.md`; update `status.md`.

## Status file

`status.md` (from `templates/status.md`) is the project's memory between
sessions: the current step, the gates passed with dates, the chapters
drafted, open questions, and the next action. Update it at the end of
every step and before stopping for a gate, so that a new session can
resume without re-reading the whole history.

## Version control

If the project folder is under Git, ask once whether the user wants a
commit after each approved step, and commit only if they do, with a message
that names the step or change (for example `docs: approve outline`). Never
commit the `build/` folder, never push unless asked, and never put project
files in the specforge repository.

## Communication

- Report each step in a few lines: what was done, what was found, what is
  needed from the user.
- Ask few, focused questions; keep the user's terminology and any words the
  user asked to avoid (recorded in `clarifications.md`).
- When a step cannot be completed (missing tools, failed build), say so and
  what is needed; never present an unchecked result as finished.
