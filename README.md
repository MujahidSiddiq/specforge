# specforge

**specforge lets Claude Code write a design specification of a hardware
design**, as a PDF with diagrams, tables and timing diagrams. Claude Code
reads the instructions in this folder and does the work; you answer its
questions and approve the result.

- From **RTL** (SystemVerilog or Verilog), or from a **design description**
  in Markdown files.
- **Your choices:** the maximum number of pages, **detailed** or
  **high-level** diagrams, and your own colours.
- The description is always complete. The diagram level only changes the
  diagrams: detailed diagrams show every signal with its width;
  high-level diagrams show the important signals and draw the rest as
  labelled information arrows. Packets are drawn as one arrow, never field
  by field. State machines are drawn with circles and curved transitions.

## 1. Prepare a folder

```
my-design/
  specforge/              this repository (git clone)
  project_rtl/            your RTL: .sv, .svh, .v, .vh, in any sub-folders
  project_description/    or your description: .md files
  project_colours.md      optional: your colours
```

Give `project_rtl`, `project_description`, or both. With both, the RTL is
the source and the description explains purpose and intent. Claude Code
creates `specforge_output/` next to them, with the PDF in
`specforge_output/output/`.

## 2. Start Claude Code with this prompt

Open a terminal in `my-design`, start `claude`, and send:

```text
Write a design specification of my design with specforge.
Read START-HERE.md in the specforge folder and follow it.
Pages: at most 15. Diagrams: detailed.
```

Change the page number, and write `Diagrams: high-level` if you prefer.
Anything you leave out, Claude Code asks for.

Claude Code then:

1. Reads your design and asks numbered questions, each with a proposed
   answer. Approval 1: you answer.
2. Proposes the chapters, figures and estimated pages. Approval 2: you
   approve or change it.
3. Writes the chapters and figures, builds the PDF and checks it.
4. Shows you the PDF. Approval 3: you approve or ask for changes.

It never invents design facts: whatever your inputs do not say, it asks or
marks as an open point.

## 3. Your colours

Write them in the prompt ("blocks light blue #EAF1F8, waveforms dark
blue"), give Claude Code your own colour guide, or create
`project_colours.md`:

````markdown
```yaml
colours:
  text: "#1B1F24"
  background: "#FFFFFF"
  accent: "#2F5D8A"
  block_fill: "#EAF1F8"
  block_border: "#3E5872"
  waveform: "#1F3B57"
  state_fill: "#FFF4D6"
```
````

All names are listed in [config-templates/style.md](config-templates/style.md):
text, backgrounds, lines, headings, captions, table headers, blocks, the
top-level boundary, wires, highlights, waveforms, clock, state machines.
The build checks that every text and line stays readable on its
background and names any colour that does not.

## 4. What the computer needs

- [Claude Code](https://code.claude.com/docs/en/quickstart).
- LaTeX: MiKTeX or TeX Live, with the free fonts Source Sans 3 and Source
  Code Pro. Claude Code checks this itself and tells you if something is
  missing.

Step-by-step installation and use: [USER-GUIDE.md](USER-GUIDE.md).
Your design goes to the AI service; check that you may share it.

## 5. Examples

[examples/](examples/README.md) holds two finished documents, from RTL and
from a description, each with detailed and with high-level diagrams.

## For maintainers

| File | For |
|---|---|
| [START-HERE.md](START-HERE.md) | What Claude Code follows to write a specification |
| [SKILL.md](SKILL.md), `.claude-plugin/` | specforge as a Claude Code skill or plugin (`claude plugin marketplace add <path>`, then `claude plugin install specforge@specforge`) |
| [CLAUDE.md](CLAUDE.md) | Changing specforge itself |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Workflow, configuration, how to extend |
| [CHANGELOG.md](CHANGELOG.md) | Changes per version |

Command line (`texlua specforge/tools/specforge.lua <command>`; on Linux
and macOS also `sh specforge/specforge.sh <command>`): `doctor --build`,
`new`, `check`, `build --figures`, `inventory`, `help`.
