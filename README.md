# specforge

**specforge lets an AI tool write a design specification of a hardware
design**, as a PDF with diagrams, tables and timing diagrams. The AI reads
the instructions in this folder and does the work; you answer its
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
- Works with AI tools that can read and write files, such as Claude Code
  and Claude Cowork. Chat-only assistants: see the end of this page.

## 1. Prepare a folder

```
my-design/
  specforge/              this repository (git clone, or the release zip)
  project_rtl/            your RTL: .sv, .svh, .v, .vh, in any sub-folders
  project_description/    or your description: .md files
  project_colours.md      optional: your colours
```

Give `project_rtl`, `project_description`, or both. With both, the RTL is
the source and the description explains purpose and intent. The AI creates
`specforge_output/` next to them, with the PDF in `specforge_output/output/`.

## 2. Give the AI this prompt

Open the AI tool on `my-design` (in Cowork: share the `my-design` folder)
and send:

```text
Write a design specification of my design with specforge.
Read START-HERE.md in the specforge folder and follow it.
Pages: at most 15. Diagrams: detailed.
```

Change the page number, and write `Diagrams: high-level` if you prefer.
Anything you leave out, the AI asks for.

The AI then:

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
blue"), give the AI your own colour guide, or create `project_colours.md`:

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

The PDF is built with LaTeX: MiKTeX or TeX Live with the free fonts Source
Sans 3 and Source Code Pro. The AI checks this itself (`doctor --build`)
and tells you if something is missing. A cloud AI without LaTeX writes the
document and gives you one command to build it on your computer.
Step-by-step installation: [USER-GUIDE.md](USER-GUIDE.md).

## 5. Good to know

- Your design goes to the AI service you use. Check that you may share it.
- An AI can misread a design. The three approvals are where you catch it.
- Tested on Windows 11 with MiKTeX and Claude. Linux, macOS, TeX Live and
  other AI tools are supported by the instructions but not yet tested.
- Not available: VHDL.

## For AI tools and maintainers

| File | For |
|---|---|
| [START-HERE.md](START-HERE.md) | Entry point for any AI writing a specification |
| [SKILL.md](SKILL.md), `.claude-plugin/` | Claude Code skill and plugin (`claude plugin marketplace add <path>`, then `claude plugin install specforge@specforge`) |
| [AGENTS.md](AGENTS.md) | Changing specforge itself |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Workflow, configuration, how to extend |
| [CHANGELOG.md](CHANGELOG.md) | Changes per version |

Command line (`texlua specforge/tools/specforge.lua <command>`; Linux and
macOS also `sh specforge/specforge.sh <command>`): `doctor --build`, `new`,
`check`, `build --figures`, `inventory`, `chat-pack`, `unpack`, `help`.

## Chat-only assistants

An AI that can only chat cannot read your folders, so you carry the files:

1. Create the project: `texlua specforge/tools/specforge.lua new --diagrams detailed --pages 15`
   (run in `my-design`), and fill in the title and author in
   `specforge_output/project.md`.
2. Make a pack: `texlua specforge/tools/specforge.lua chat-pack specforge_output`.
3. Upload `specforge/specforge-chat.md` and `specforge_output/build/chat-pack.md`,
   and send: "Follow specforge-chat.md. My project is in chat-pack.md."
4. Save each answer that contains files as `answer.txt`, then run
   `texlua specforge/tools/specforge.lua unpack specforge_output answer.txt`.
5. Build: `texlua specforge/tools/specforge.lua build specforge_output --figures`,
   and give the messages and the PDF back to the chat.
