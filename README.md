# specforge

specforge makes an AI write a **high-level specification** of a hardware
design (10 to 15 pages, PDF and Markdown) from one of two inputs:

- `design-info`: Markdown files that describe the design;
- `rtl`: SystemVerilog or Verilog, with optional notes.

The AI analyses the inputs, asks what is missing, waits for your approval
of the outline, writes, builds and waits for your approval of the result.
specforge holds no project data: every design has its own project folder.

## New to specforge?

Follow the [user guide](USER-GUIDE.md). It goes step by step from
installation to the final PDF, with a small example, for code, cowork and
chat assistants. The rest of this page is a short reference.

## Choose your AI

| Your AI | Read |
|---|---|
| Claude Code, or another AI code agent | [docs/use-with-code-agent.md](docs/use-with-code-agent.md) |
| A cowork assistant | [docs/use-with-cowork.md](docs/use-with-cowork.md) |
| Chat only | [docs/use-with-chat.md](docs/use-with-chat.md) |

On a new computer read [docs/install.md](docs/install.md) first.

The shortest route, for any AI that can read files:

```text
Read <path to specforge>/START-HERE.md and follow it.
My project folder is <path>.
```

## Commands

Every system: `texlua "<specforge>/tools/specforge.lua" <command>`.
Linux and macOS also have `sh <specforge>/specforge.sh <command>`.
On Windows use PowerShell. `texlua` comes with MiKTeX and TeX Live.

| Command | Does |
|---|---|
| `doctor --build` | Checks this computer and builds a test document |
| `new <project> ...` | Creates a project folder |
| `check <project>` | Checks a project and writes the combined Markdown |
| `build <project> --figures` | Builds the PDF and the figure previews |
| `inventory <project>` | Lists units, ports, parameters and instances of RTL |
| `chat-pack <project>` | Packs a project for a chat AI |
| `unpack <project> <file>` | Saves the files of a chat answer |
| `help` | Shows all options |

## What is tested and what is not

| Item | State |
|---|---|
| Build, checks, inventory, chat tools on Windows 11 with MiKTeX | Automatic tests (`texlua tests/run.lua`) |
| Both approaches, from inputs to PDF | Done on one design, with Claude |
| Linux, macOS, TeX Live | Written for them, not run on them |
| Plugin install in Claude Code | Installed and listed as one skill; not yet used for a document |
| Copy as a project skill, upload as a skill | The tool works from a copy; loading by the assistant not tested |
| AIs other than Claude | Instructions are provided, not tried |
| Complete document through a chat | Pack, unpack and build tested; no document written that way yet |
| Document types other than the high-level specification | Not available |
| VHDL | Not available |

An AI can misread a design. The gates exist so that you catch it: review
the questions, the outline and the PDF.

## Safety

- Your inputs are read, never changed. Output goes into the project folder.
- Text from a project cannot become a LaTeX command. Figure sources are
  checked against a list of allowed commands. That check is not a sandbox:
  look at figures from a source you do not trust before building.
- The tool uses no network. Your TeX installation may download missing
  packages, and an AI service receives what you give it.

## Changing the look

Put only the values you want to change in the project's `style.md`. The
keys are in [styles/style-defaults.md](styles/style-defaults.md); contrast
is checked on every build.

## Improving specforge

See [AGENTS.md](AGENTS.md) and [ARCHITECTURE.md](ARCHITECTURE.md).
