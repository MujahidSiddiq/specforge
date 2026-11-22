# Changelog

All changes to specforge are listed here, newest first. Versions follow
semantic versioning: a major version for changes that alter existing
documents, a minor version for new features, a patch version for fixes.

## 0.2.0 (2026-11-22)

### Changed (action needed for 0.1.0 projects)

- One tool for Windows, Linux and macOS (`specforge.cmd`, `specforge.sh`)
  replaces the PowerShell scripts. Change build commands accordingly.
- The five skills became guides behind one root skill. Reinstall the
  plugin; the old skill names no longer exist.
- An unknown style key or wrong kind of value is an error.
- `toolchain.tex_bin` is ignored: a project cannot choose the programs
  that run. Put the TeX folder on PATH instead.
- Figures may use only the allowed commands.

### Added

- `START-HERE.md`, `AGENTS.md` and `specforge-chat.md` for any code agent,
  cowork or chat assistant; commands `new`, `doctor`, `chat-pack`,
  `unpack`, `bundle`; usage documents in `docs/`; test suite.

### Fixed

- Code spans with `%`, `#`, braces or backslashes broke the build, printed
  wrongly or ran as LaTeX.
- Copying the skill into a project could not find the build tools.
- A `|` inside a code span split a table cell.
- Configuration values could inject LaTeX or write outside the project.
- The RTL inventory cut parameter values at a nested parenthesis and took
  function arguments for ports.
- Extra spaces in the footer and other generated document values.

### Also in this version

- Tested end to end on the `design-info` approach.
- `high-level-spec` rule 02: the page estimate counts 2 front-matter pages
  for a first revision; calibration table of the first two projects added.

## 0.1.0 (2026-11-21)

- Framework skeleton: README, architecture, version, changelog.
- Configuration templates `project.md` and `style.md`.
- Record templates: clarification register, revision history, review record.
- Style defaults (`styles/style-defaults.md`): every styled element with its
  default value, taken from the reference high-level specification.
- Base style rules (`styles/colour-guide.md`), copied unchanged from the
  Design Documentation Color Schemes guide.
- Colour specification record template, with the contrast ratios of the
  default style.
- LaTeX toolchain (`latex/`): document template and preamble driven by the
  style keys, TikZ style library, and the build tools `build.ps1`,
  `style2tex.ps1` (merge, accent derivation, contrast check), `md2tex.ps1`,
  `build-figures.ps1` and `sf-common.ps1`.
- `md2tex.ps1` checks the numbering of table and figure captions and warns
  about references to chapters, sections, tables and figures that do not
  exist.
- Skill `latex-document`: source organization, writing, tables, figures and
  timing diagrams, style and colour, build and verification.
- Skill `high-level-spec`: generic outline, page budget with allocation,
  calibration and estimate, content per chapter, acceptance criteria.
- Template `templates/outline.md`.
- Shared rules (`shared/`): clarification rules, information checklist for
  a high-level specification.
- Template `templates/analysis.md` (analysis report of the intake step).
- Skill `intake-design-info`: extraction and checks for Markdown design
  information.
- Skill `intake-rtl`: extraction from SystemVerilog/Verilog, intent
  questions, language notes, and the reading aid `rtl-inventory.ps1`.
- Skill `hls-orchestrator`: project setup and resume, dispatch to the
  intake and document-type skills, workflow with approval gates, change
  handling, status file.
- Template `templates/status.md`; checklists `intake.md`, `pre-build.md`,
  `pre-release.md`.
- Plugin packaging: `.claude-plugin/plugin.json` and a one-plugin
  `marketplace.json`. The plugin version must equal `VERSION`.
- Fix: the title-page field list no longer ends with a row break (it added
  an empty row and moved the fields up).
- Tested by rebuilding the reference high-level specification with the
  default style: 15 pages, identical text and pagination; see the test
  project's README.
- Tested end to end on the `rtl` approach: a high-level specification
  written from RTL only (intake, 12 questions, outline, draft, build).
  Findings fixed in the framework:
  - Timing figures (`fig-wave-*`, `fig-timing-*`) are set justified, not
    ragged-right, which shifted the rows of tikz-timing tables.
  - New row style `sfclock` for the clock of a timing diagram.
  - Rule 04 of `latex-document`: clock row, timing wrap, `\sig{}` for every
    signal name in a figure.
  - Calibration: estimate 14.7 pages, result 13 (front matter 2 pages with a
    one-row revision history; longest behaviour chapter 2.5 pages).
