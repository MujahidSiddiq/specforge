# specforge architecture

## 1. Principles

1. **The framework holds no project data.** Everything specific to a
   design (inputs, answers, chapters, figures, output) lives in the project
   folder. Framework files never name a project.
2. **Nothing is invented.** Every statement in a document comes from the
   inputs or from an answer recorded in the project's clarification
   register. Anything else is asked, or marked as an open point.
3. **The user approves before the document grows.** The workflow stops for
   approval after the analysis and after the outline, and before any change
   to an approved document.
4. **One value, one place.** Every style value has one default (in
   `styles/style-defaults.md`) and at most one override (in the project's
   `style.md`).
5. **Traceable.** Each question, answer and design fact can be traced to its
   source (input file, RTL file and line, or clarification ID).

## 2. Components

| Component | Location | Role |
|---|---|---|
| Configuration templates | `config-templates/` | Copied into each project: `project.md`, `style.md` |
| Style defaults | `styles/style-defaults.md` | Default value of every styled element |
| Base style rules | `styles/colour-guide.md` | Rules for colour, typography, layout and components that every document follows |
| Entry points | `START-HERE.md`, `SKILL.md`, `AGENTS.md`, `specforge-chat.md` | One set of rules for code agents, cowork and chat |
| Orchestrator guide | `guides/orchestrator/` | Runs the workflow and names the guide of each step |
| Intake guides | `guides/intake-design-info/`, `guides/intake-rtl/` | Analyze the inputs of one approach; produce the analysis report and the questions |
| Shared rules | `shared/` | Clarification rules and the information checklist |
| Document-type guide | `guides/high-level-spec/` | Outline, page budget, content and writing rules of a high-level specification |
| LaTeX guide | `guides/latex-document/` | How the PDF is produced and checked |
| LaTeX template | `latex/` | Preamble, title page, TikZ style library |
| Tool | `tools/`, started by `texlua tools/specforge.lua` or `specforge.sh` | Project setup, checks, build, RTL inventory, chat pack and unpack, doctor |
| Tests | `tests/` | `texlua tests/run.lua`; the fixture is also used by `doctor --build` |
| Record templates | `templates/` | Analysis report, clarification register, outline, revision history, review record |
| Checklists | `checklists/` | Checks at intake, before a build, before a release |

## 3. Configuration and precedence

A project folder contains two configuration files, copied from
`config-templates/`:

| File | Contents |
|---|---|
| `project.md` | Document type, approach, input and output paths, document information, page target |
| `style.md` | Style overrides only |

Both files are Markdown with one fenced `yaml` block that holds the values.
Text outside the block is explanation and is ignored.

Each setting is resolved in this order; the first source that gives a value
wins:

1. An explicit instruction from the user in the conversation (recorded in
   the clarification register so that it is not lost).
2. The project's `style.md` or `project.md`.
3. The document-type defaults (for example the page target of a high-level
   specification).
4. The framework defaults in `styles/style-defaults.md`.

An empty or missing override keeps the default. A partial override changes
only the keys it names; every other key keeps its default.

## 4. Workflow

The same workflow serves both approaches; only step 2 differs.

| Step | Name | Output | Gate |
|---|---|---|---|
| 1 | Configure | Merged configuration; configuration errors reported | |
| 2 | Intake and analysis | Analysis report: what the inputs say, gaps, contradictions, ambiguities | |
| 3 | Clarification | Questions in `clarifications.md`, each with a proposed default | **User answers** |
| 4 | Outline and page budget | Chapter and section list with page allocation, figure list | **User approves** |
| 5 | Drafting | Markdown chapters and TikZ figures | |
| 6 | Build | Combined Markdown and PDF | |
| 7 | Verification | Build log check, cross-references, page count against the budget, visual check, checklist | |
| 8 | Review and release | Review findings fixed; revision history updated | **User approves** |

Steps 3 and 4 repeat until nothing blocks the outline. A change to an
approved document goes through an impact analysis (which sections, figures
and tables are affected), is listed in the revision history, and is
approved before it is made.

## 5. Input approaches

| Approach | Inputs | What the analysis derives | What must be asked |
|---|---|---|---|
| `design-info` | Markdown files describing the design | Structure, interfaces and behaviour as described; gaps and contradictions between files | Missing information, contradictions, unclear behaviour |
| `rtl` | RTL files and the top module name; optional Markdown notes | Hierarchy, ports, parameters and widths, state machines, reset behaviour. Each fact is tagged with its file and line | Purpose and intent, block roles, operating scenarios, constraints and limitations. RTL shows what the design does, not why |

Facts from RTL are marked "from RTL" until the user confirms them; the notes
of the `rtl` approach can answer intent questions in advance.

## 6. Project folder layout

```
<project>/
  project.md            configuration (from config-templates/)
  style.md              style overrides (from config-templates/)
  inputs/               design information or RTL (and notes)
  status.md             current step, gates passed, next action (from templates/)
  clarifications.md     question register (from templates/)
  revision-history.md   revision table shown in the front matter (from templates/)
  colour-record.md      colour specification record (from styles/)
  analysis.md           analysis report of step 2
  outline.md            approved outline and page budget
  chapters/             Markdown chapters, one file per chapter
  figures/              TikZ sources and exported SVG previews
  build/                intermediate files (not tracked)
  output/               PDF and combined Markdown
```

## 7. Extending specforge

| Extension | How |
|---|---|
| New document type | Add `guides/<type>/` with its outline, page budget and content rules; add the type name to the `document_type` values in `config-templates/project.md`; update the orchestrator's dispatch table |
| New input approach | Add `guides/intake-<approach>/` producing the same analysis report format; add the value to `approach` |
| New RTL language | Add a rules file under `guides/intake-rtl/rules/` |
| New style element | Add the key and its default to `styles/style-defaults.md`, use it in `latex/`, and document it in `config-templates/style.md` |

After any change run `texlua tests/run.lua` and `specforge bundle`.

Every extension updates `CHANGELOG.md` and, if existing behaviour changes,
the version in `VERSION`.
