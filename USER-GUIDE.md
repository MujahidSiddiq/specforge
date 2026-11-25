# Specforge User Guide

This guide takes a hardware engineer who has never used Specforge from an
empty computer to a finished design specification. Your AI tool does the
work; you prepare one folder, send one prompt and approve the result. You
do not need to know LaTeX.

Written for Specforge 0.3.0. The commands are for Windows PowerShell; see
[Section 9](#9-macos-and-linux) for macOS and Linux.

## Contents

- [1. What you need](#1-what-you-need)
- [2. Install LaTeX](#2-install-latex)
- [3. Prepare your design folder](#3-prepare-your-design-folder)
- [4. Check the computer](#4-check-the-computer)
- [5. Start the AI](#5-start-the-ai)
- [6. Your three approvals](#6-your-three-approvals)
- [7. The result, and later changes](#7-the-result-and-later-changes)
- [8. If something goes wrong](#8-if-something-goes-wrong)
- [9. macOS and Linux](#9-macos-and-linux)
- [10. What has been tested](#10-what-has-been-tested)

---

## 1. What you need

- [ ] An AI tool that can read and write files: for example **Claude Code**
      or **Claude Cowork**. Some tools need a paid plan.
- [ ] **LaTeX** on your computer (free, Section 2), unless your AI tool can
      build the PDF in its own environment.
- [ ] Your design: RTL files, or a description in Markdown (`.md`) files.
- [ ] **Permission to show your design to that AI service.** The AI company
      receives what the AI reads. Ask your organization if you are not sure.

**How to use PowerShell:** press the Windows key, type `PowerShell`, open
**Windows PowerShell** (not "as administrator"), paste a command with a
right-click and press Enter. Do not use Command Prompt (cmd).

## 2. Install LaTeX

Skip this if MiKTeX or TeX Live is already installed.

1. Open <https://miktex.org/download>, download the Windows installer and
   start it.
2. Install for your user only. On the **Settings** page, select **Always**
   for installing missing packages.
3. When it finishes, open **MiKTeX Console** from the Start menu, click
   **Updates**, then **Check for Updates**, then **Update now**.
4. Close PowerShell and open it again.

## 3. Prepare your design folder

Make one folder per design with this content:

```text
C:\designs\pulse-counter\
    specforge\              Specforge itself
    project_rtl\            your RTL (.sv, .svh, .v, .vh)
    project_description\    or your description (.md files)
    project_colours.md      optional: your colours
```

Use simple folder names: letters, numbers, `-` and `_`.

**Specforge:** with Git, run this, with the address of the Specforge
repository in place of `OWNER/specforge`:

```powershell
git clone https://github.com/OWNER/specforge.git C:\designs\pulse-counter\specforge
```

Without Git, download the ZIP from the repository page (**Code**, then
**Download ZIP**), extract it, and rename the extracted folder to
`specforge`. The folder must directly contain `START-HERE.md`.

**Your design:** put the RTL in `project_rtl`, including packages and lower
modules (test benches are not needed), or put Markdown files in
`project_description`. You may give both: then the RTL is the source and
the description explains what the design is for.

A good description covers purpose, blocks, every interface signal, clock
and reset, behaviour, special cases (full, empty, errors, events in the
same cycle), parameters and limits. Gaps are fine: the AI asks about them.

To try Specforge first, create a small example design:

```powershell
$design = "C:\designs\pulse-counter"
New-Item -ItemType Directory -Force "$design\project_rtl" | Out-Null
@'
module pulse_counter #(
  parameter WIDTH = 8
) (
  input  logic             clk,
  input  logic             reset_n,
  input  logic             event_i,
  input  logic             clear_i,
  output logic [WIDTH-1:0] count_o
);

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n)     count_o <= '0;
    else if (clear_i) count_o <= '0;
    else if (event_i) count_o <= count_o + 1'b1;
  end

endmodule
'@ | Out-File -Encoding utf8 "$design\project_rtl\pulse_counter.sv"
```

**Your colours (optional):** create `project_colours.md` in the design
folder:

````markdown
```yaml
colours:
  accent: "#2F5D8A"
  block_fill: "#EAF1F8"
  block_border: "#3E5872"
  waveform: "#1F3B57"
  state_fill: "#FFF4D6"
```
````

The names you can use are listed in `specforge\config-templates\style.md`.
You can also just write your colours in the prompt, or give the AI your own
colour guide.

## 4. Check the computer

```powershell
texlua "C:\designs\pulse-counter\specforge\tools\specforge.lua" doctor --build
```

The first run can take several minutes. It must end with:

```text
This computer can build specforge documents.
```

You can ignore a MiKTeX line about not having checked for updates. If you
see `MISSING`, run the command again: MiKTeX may have installed the missing
parts during the first run.

## 5. Start the AI

**Claude Code:** in PowerShell, go to the design folder and start it:

```powershell
Set-Location "C:\designs\pulse-counter"
```

```powershell
claude
```

The first start asks you to sign in, and whether you trust the folder.
Install Claude Code first if needed: <https://code.claude.com/docs/en/quickstart>.

**Claude Cowork or another AI tool:** start a new task and share (connect)
the design folder `C:\designs\pulse-counter`. Do not share your whole disk.

**Then send this prompt:**

```text
Write a design specification of my design with specforge.
Read START-HERE.md in the specforge folder and follow it.
Pages: at most 15. Diagrams: detailed.
```

- **Pages** is the maximum. A small design gives a shorter document.
- **Diagrams: detailed** shows every signal with its width.
  **Diagrams: high-level** shows the important signals and draws the rest
  as labelled information arrows. The text is complete either way.
- Leave a setting out and the AI asks for it.

The AI asks before some actions. Usually: allow it to read the design
folder, to write in `specforge_output`, and to run the `specforge.lua`
commands. Refuse changes to `project_rtl`, `project_description` or
`specforge`, deletions, uploads and pushes you did not ask for.

## 6. Your three approvals

The AI must stop and wait at each one.

**Approval 1: answer the questions.** The AI shows what it understood and
asks numbered questions, each with a proposed answer. Check its
understanding first, then reply, for example:

```text
1. Yes, use the default.
2. No. <the correct answer>
3. I do not know yet. Keep it as an open point.
```

Your answer becomes a fact in the specification, so read every default.

**Approval 2: the outline.** The AI shows the chapters, figures and the
estimated pages. Check that every block and behaviour has a place.

```text
I approve the outline. Write the chapters and figures.
```

If the complete design does not fit your page maximum, the AI tells you the
smallest length it can reach. You choose: raise the maximum, or name
content to leave out. It never drops content on its own.

**Approval 3: the PDF.** Read it yourself; an AI can make mistakes. Check
the names, widths and directions of the signals, the clock and reset, every
behaviour and priority, the state machines, and that nothing was invented.

```text
Do not release yet. Page <n>: <what is wrong> should be <what is correct>.
```

```text
I approve the release as revision 1.0 with status Released.
```

If the AI does not wait at a step, send: "Stop. Follow the approval gates
in the Specforge instructions."

## 7. The result, and later changes

The PDF is in `specforge_output\output\`, with the same text as a Markdown
file. The project files that make it are in `specforge_output\`.

- **Continue another day:** start the AI in the design folder again and
  send: "Continue my specforge specification from its status." 
- **The design changed:** change your files, then send: "My design files
  changed. List what changed and which sections are affected, and wait for
  my approval."
- **Different colours or diagram level:** ask the AI; it changes the
  project settings and builds again.
- **A new design:** a new design folder with its own copy of `specforge`.

## 8. If something goes wrong

| You see | Do this |
|---|---|
| `texlua` is not recognized | Install LaTeX (Section 2), then open a new PowerShell |
| `MISSING` in the check | Run the check again; then follow what the line says |
| The check cannot find `specforge.lua` | The folder must be named `specforge`, directly in the design folder, and contain `START-HERE.md` |
| The AI says it cannot build | It gives you a build command: run it in PowerShell and give it the messages and the PDF |
| `is not UTF-8 text` | Open the file in Notepad and save it with encoding UTF-8 |
| `top module ... not found`, or several candidates | Tell the AI the name of your top module |
| `Permission denied` while building | Close the PDF and build again |
| `contrast check failed` | A colour is too light or too dark on its background: choose another |

If `texlua` is still not found after a MiKTeX installation for one user,
run this in PowerShell; it works until you close the window:

```powershell
$env:Path += ";$env:LOCALAPPDATA\Programs\MiKTeX\miktex\bin\x64"
```

For any other problem, give the message to your AI and ask it to explain
the cause in simple steps.

## 9. macOS and Linux

**Not yet tested.** Install MacTeX (<https://tug.org/mactex/>) on macOS, or
TeX Live on Linux (Debian or Ubuntu:
`sudo apt install texlive-full poppler-utils`). Open a new terminal, then
check the computer:

```sh
sh ~/designs/pulse-counter/specforge/specforge.sh doctor --build
```

The folder layout, the prompt and the approvals are the same as on
Windows. Start Claude Code with `cd ~/designs/pulse-counter` and `claude`.

## 10. What has been tested

| Item | State |
|---|---|
| Windows 11 with MiKTeX and Claude | Tested |
| The commands and the example design in this guide | Tested |
| A complete document of 0.3.0 written by an AI | Not yet |
| macOS, Linux, TeX Live, other AI tools | Not yet |
| VHDL | Not supported |
