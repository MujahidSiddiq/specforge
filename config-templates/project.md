# Project configuration

Copy this file into the project folder and fill in the values in the `yaml`
block. Text outside the block is explanation and is ignored. Paths are
relative to the project folder. An empty value (`""`) means "use the
default" where a default is given.

```yaml
specforge_version: "0.2.1"        # framework version this project is built with

document_type: design-spec        # design-spec (0.2 projects: high-level-spec)

approach: design-info             # design-info | rtl

diagrams: ""                      # detailed | high-level (ask the user if not given)

inputs:
  design_info: inputs/            # design-info: folder of Markdown files (*.md)
  rtl: inputs/rtl/                # rtl: folder of RTL files (*.sv, *.svh, *.v, *.vh)
  rtl_top: ""                     # rtl: name of the top module (required for rtl)
  notes: inputs/notes/            # rtl: optional Markdown notes on purpose and intent

output:
  dir: output/                    # PDF and combined Markdown go here
  file_name: ""                   # default: <short_name>_Design_Specification
  combined_markdown: true         # also write one complete Markdown file

document:
  title: ""                       # full design name, e.g. "Example Unit (EXU)"
  short_name: ""                  # short name used in file names, e.g. "EXU"
  subtitle: Design Specification
  author: ""
  organization: ""                # optional; shown on the title page if given
  revision: "0.1"
  status: Draft                   # e.g. Draft, Draft — under review, Released
  date: ""                        # default: date of the build
  language: en-GB                 # PDF language tag
  related_documents: []           # list of "Title, revision, date" strings

page_budget:
  min: 10                         # total pages including front matter
  max: 15

```

## Values

| Key | Required | Notes |
|---|---|---|
| `document_type` | yes | Selects the document-type guide. |
| `diagrams` | yes | `detailed`: every signal with its width. `high-level`: important signals only, other connections as labelled information arrows. The text is the same for both. |
| `approach` | yes | `design-info`: the design is described in Markdown files. `rtl`: the design is given as RTL. |
| `inputs.rtl_top` | for `rtl` | The module the specification describes. |
| `inputs.notes` | no | Answers intent questions in advance for the `rtl` approach. |
| `document.title`, `short_name`, `author` | yes | Used on the title page, in the header and in the PDF metadata. |
| `page_budget` | no | Default 10 to 15 pages. The assistant asks before exceeding `max`. |
