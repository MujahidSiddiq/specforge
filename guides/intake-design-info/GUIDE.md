# intake-design-info

Turns the user's Markdown design information into an analysis report and a
set of clarification questions (workflow steps 2 and 3). It writes nothing
into the document itself.

## Inputs and outputs

| | Path |
|---|---|
| Reads | `inputs.design_info` folder of `project.md` (all `*.md`, in name order) |
| Writes | `<project>/analysis.md` (from `<specforge>/templates/analysis.md`) |
| Writes | Questions in `<project>/clarifications.md` (from `<specforge>/templates/clarifications.md`) |
| Follows | `<specforge>/shared/clarification-rules.md`, `<specforge>/shared/information-checklist.md` |

The input files are the user's: never edit, rename or reformat them.

## Steps

1. **Inventory.** List every input file with a one-line summary of its
   contents.
2. **Read everything** before writing anything. Inputs are often
   unstructured and may come in pieces; information about one block can be
   spread over several files.
3. **Extract** the facts into the analysis report: structure, interfaces,
   behaviour, parameters, constraints, each with its source (file and
   section). See `rules/01-extraction.md`.
4. **Check** completeness against the information checklist, and
   consistency within and between files. See `rules/02-checks.md`.
5. **Summarize the understanding** in a few sentences (section 2 of the
   report) so the user can confirm it.
6. **Ask** the questions the findings raise, following the clarification
   rules, and record them.
7. **Stop** for the user's answers. Update the report with each answer.
   When nothing blocks the outline, hand over to the outline step
   (design-spec guide).

## Progressive inputs

Inputs may arrive in parts. For each new or changed file: read it, extract
its facts, check it against what is already known (a new statement may
contradict an earlier one or an answered question), update the report, and
ask only the new questions. If drafting has started, list the sections the
new information affects and propose the changes before making them.
