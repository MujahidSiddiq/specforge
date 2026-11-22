# Specforge User Guide

This guide is for a hardware engineer who has never used Specforge. It takes
you from an empty computer to a final PDF. You do not need to know LaTeX or
Git.

Written for Specforge 0.2.1. The main steps use Windows. For macOS and
Linux, see [Section 15](#15-macos-and-linux).

## How to use this guide

Follow these steps in order. Do only **one** route in Step 4.

| Step | What you do | Read |
|---|---|---|
| 1 | Install Specforge and LaTeX | [Section 4](#4-install) |
| 2 | Prepare your design files | [Section 5](#5-prepare-your-design) |
| 3 | Create a project | [Section 6](#6-create-the-project) |
| 4 | Work with your AI: **code**, **cowork** or **chat** | [Section 7](#7-choose-your-ai-route) |
| 5 | Answer questions and review | [Section 11](#11-your-three-approvals) |
| 6 | Get the final PDF | [Section 12](#12-get-the-final-pdf) |

For your first time, use the small example in this guide. Use your own
design after that.

## Contents

- [1. What Specforge does](#1-what-specforge-does)
- [2. What you need](#2-what-you-need)
- [3. Five rules before you start](#3-five-rules-before-you-start)
- [4. Install](#4-install)
- [5. Prepare your design](#5-prepare-your-design)
- [6. Create the project](#6-create-the-project)
- [7. Choose your AI route](#7-choose-your-ai-route)
- [8. Route A: Code AI](#8-route-a-code-ai)
- [9. Route B: Cowork AI](#9-route-b-cowork-ai)
- [10. Route C: Chat AI](#10-route-c-chat-ai)
- [11. Your three approvals](#11-your-three-approvals)
- [12. Get the final PDF](#12-get-the-final-pdf)
- [13. Continue, change or start another design](#13-continue-change-or-start-another-design)
- [14. Fix common problems](#14-fix-common-problems)
- [15. macOS and Linux](#15-macos-and-linux)
- [16. Words used in this guide](#16-words-used-in-this-guide)
- [17. What has been tested](#17-what-has-been-tested)

---

## 1. What Specforge does

Specforge helps an AI write a **high-level specification** of a hardware
design. The result is a PDF of about 10 to 15 pages.

```text
Your design files
      |
      v
AI reads them and asks questions  -->  YOU answer      (approval 1)
      |
      v
AI proposes an outline            -->  YOU approve it  (approval 2)
      |
      v
AI writes chapters and figures
      |
      v
Specforge builds the PDF          -->  YOU approve it  (approval 3)
      |
      v
Final PDF
```

There are two separate choices.

**Choice 1: What do you give?**

| You have | Input type | Name in Specforge |
|---|---|---|
| A written description of the design | Markdown files (`.md`) | `design-info` |
| The code of the design | SystemVerilog or Verilog files | `rtl` |

**Choice 2: Which AI do you use?**

| Your AI | Route |
|---|---|
| It works in a terminal or code editor and can run commands | A: Code |
| It works on folders that you share with it | B: Cowork |
| It can only chat and read uploaded files | C: Chat |

Both input types work with all three routes.

Specforge does not write RTL and does not verify your design. VHDL is not
supported.

## 2. What you need

- [ ] A computer with an internet connection.
- [ ] An account for one AI tool. Some tools need a paid plan.
- [ ] About 30 to 60 minutes for the first installation.
- [ ] Several GB of free disk space for LaTeX.
- [ ] Your design files, or the example from Section 5.
- [ ] **Permission to show your design to that AI service.** The AI company
      receives what the AI reads. Ask your organization if you are not sure.

### How to use PowerShell

PowerShell is the Windows program in which you type commands.

1. Press the **Windows** key.
2. Type `PowerShell`.
3. Open **Windows PowerShell**. Do not use "Run as administrator". Do not
   use Command Prompt (cmd), because the commands in this guide do not work
   safely there.
4. Copy one whole command box from this guide.
5. Right-click in PowerShell to paste it. Press **Enter**.
6. Wait until you can type again before you paste the next box.

Boxes marked `text` are not commands. They are messages for the AI, or
examples of what you will see.

## 3. Five rules before you start

These rules prevent most first-time problems.

1. **Use simple folder names.** Letters, numbers, `-` and `_` are easiest.
   Good: `C:\designs\pulse-counter`.
2. **Put every value in quotes**, as in `--title "Pulse Counter"`.
3. **If a value has a `$` or a backtick, use single quotes**, as in
   `--title 'Counter $A'`. PowerShell changes these characters inside
   double quotes. Characters such as `&` and `%` are safe inside quotes.
4. **Do not use double quote marks inside a value, or leave a value empty.**
5. **Use three separate folders.** Specforge refuses a project inside the
   input folder.

```text
C:\specforge\                 Specforge (the tool)
C:\designs\pulse-counter\
    input\                    your design files (never changed)
    spec\                     the project (the document is made here)
```

---

## 4. Install

You do this once for each computer.

### 4.1 Get Specforge

**If you received a ZIP file:**

1. Right-click the ZIP file and select **Extract All**.
2. Extract it. Then find the folder that contains `START-HERE.md`.
3. Rename that folder to `specforge` and move it to `C:\`.

**If you use GitHub:**

1. Open the Specforge repository page. If you see "404", sign in. If you
   still see it, ask the owner for access, because the repository may be
   private.
2. Click **Code**, then **Download ZIP**.
3. Do the three ZIP steps above. The folder is usually named
   `specforge-main`.

**Check it:**

```powershell
Test-Path "C:\specforge\START-HERE.md"
```

You must see `True`. If you see `False`, you probably have one folder inside
another, such as `C:\specforge\specforge-main`. Move the inner folder up.

If you cannot write to `C:\`, use another simple folder. Then replace
`C:\specforge` everywhere in this guide.

### 4.2 Install LaTeX

LaTeX is the free program that makes the PDF. You do not need to learn it.

If MiKTeX or TeX Live is already installed, go to Section 4.3.

1. Open <https://miktex.org/download>.
2. Download the Windows installer and start it.
3. Accept the conditions if you agree with them.
4. Select installation only for you.
5. On the **Settings** page, find the choice for installing missing
   packages. Select **Always**.
6. Click **Start**. When it finishes, click **Close**.
7. Open **MiKTeX Console** from the Windows Start menu.
8. Click **Updates**, then **Check for Updates**, then **Update now**.
9. **Close PowerShell and open it again.**

### 4.3 Check your computer

```powershell
texlua "C:\specforge\tools\specforge.lua" doctor --build
```

The first run can take several minutes. Success looks like this, with other
lines before it:

```text
ok        test build
This computer can build specforge documents.
```

You can ignore a MiKTeX line that says
`major issue: So far, you have not checked for MiKTeX updates`.

**If you see that success message, go to Section 5.**

If you see `MISSING`, run the check a second time. MiKTeX may have installed
the missing parts during the first run. If parts are still missing, run
these two commands:

```powershell
miktex packages update-package-database
```

```powershell
foreach ($p in "geometry","fontspec","amsmath","xcolor","colortbl","latex-tools","booktabs","ragged2e","parskip","microtype","enumitem","titlesec","fancyhdr","caption","float","placeins","adjustbox","varwidth","pgf","tikz-timing","hyperref","bookmark","preview","sourcesans","sourcecodepro") { miktex packages install $p }
```

A message that a package is already installed is fine. Run the check again.

---

## 5. Prepare your design

Choose **5A** for a written description or **5B** for RTL. To learn, copy
the example commands without changes.

### 5A. Markdown design information

Create the example:

```powershell
$design = "C:\designs\pulse-counter"
New-Item -ItemType Directory -Force "$design\input" | Out-Null
@'
# Pulse counter

## Purpose
The pulse counter counts events from another block.

## Interface
- clk: input, 1 bit, clock.
- reset_n: input, 1 bit, asynchronous reset, active low.
- event_i: input, 1 bit, high for one cycle for each event.
- clear_i: input, 1 bit, clears the count.
- count_o: output, WIDTH bits, current count.

## Parameter
- WIDTH: width of the counter. Default 8.

## Behavior
- Reset sets count_o to 0.
- On a rising clock edge, clear_i sets count_o to 0.
- If clear_i is low and event_i is high, count_o increases by 1.
'@ | Out-File -Encoding utf8 "$design\input\pulse_counter.md"
```

The example does not say what happens after the largest count. Watch for
the AI to ask you about this. It must not guess.

**For your own design**, put `.md` files in an `input` folder in the same
way:

- A `.md` file is a plain text file. Notepad can write it.
- In Notepad, select **Save as type: All files** and **Encoding: UTF-8**.
  This prevents names such as `design.md.txt`.
- Word, PDF and `.txt` files are not read by the project tools. Copy their
  text into a `.md` file.
- Perfect writing is not necessary. The AI asks about missing information.

These topics reduce the number of questions:

| Topic | Write |
|---|---|
| Purpose | What the design is for and where it is used |
| Blocks | Each main block and its job |
| Interfaces | Names, directions, widths and when values are valid |
| Clock and reset | Clocks, reset polarity and reset values |
| Behavior | Each operation and its timing |
| Special cases | Full, empty, flush, errors and events in the same cycle |
| Parameters | Defaults and allowed values |
| Limits | Assumptions and known limitations |

### 5B. RTL

Create the example:

```powershell
$design = "C:\designs\pulse-counter-rtl"
New-Item -ItemType Directory -Force "$design\input" | Out-Null
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
'@ | Out-File -Encoding utf8 "$design\input\pulse_counter.sv"
```

**For your own design:**

- Put the RTL in an `input` folder: `.sv`, `.svh`, `.v` or `.vh`.
- Include packages and lower modules.
- Find the exact name of the top module.
- Test benches are not needed. Leave them out.
- RTL shows what the design does. It does not show why. The AI will ask you
  about the purpose and intent.

---

## 6. Create the project

### 6.1 Set three short names

These short names make the later commands easy.

**Run these lines every time you open a new PowerShell window.** In the
second line, write your design folder. For the RTL example it is
`C:\designs\pulse-counter-rtl`.

```powershell
function specforge { texlua "C:\specforge\tools\specforge.lua" @args }
$design = "C:\designs\pulse-counter"
$project = "$design\spec"
```

### 6.2 Create it

Run **only one** of these commands. For your own design, change the title,
short name, author and top module.

**For Markdown (5A):**

```powershell
specforge new $project --approach design-info --input "$design\input" --title "Pulse Counter" --short "PCNT" --author "Design Engineer"
```

**For RTL (5B):**

```powershell
specforge new $project --approach rtl --input "$design\input" --top "pulse_counter" --title "Pulse Counter" --short "PCNT" --author "Design Engineer"
```

| Value | Meaning |
|---|---|
| `--title` | Full name on the title page |
| `--short` | Short name, also used in the PDF file name |
| `--author` | Author on the title page |
| `--top` | Exact top module name (RTL only) |

Success ends with:

```text
Created the project C:/designs/pulse-counter/spec
```

If you see an `ERROR`, nothing was created. Correct the command and run it
again. Specforge checks the input folder and, for RTL, the top module.

### 6.3 Check or correct the project

```powershell
notepad "$project\project.md"
```

Look at `title`, `short_name`, `author` and the input path. Change only the
values inside the quotes. Save and close.

For RTL only, also check that Specforge can find the top module:

```powershell
specforge inventory $project
```

Success starts with `Wrote` and names `rtl-inventory.md`.

Do not build yet. There are no chapters, so a build would show an error.

### 6.4 What is in the project

| File or folder | What it is | Do you edit it? |
|---|---|---|
| `project.md` | Title, author, paths and settings | Yes |
| `style.md` | Optional changes to colors and fonts | Optional |
| `status.md` | Where the work stopped | No, the AI does |
| `clarifications.md` | Questions and your answers | No, answer the AI |
| `analysis.md` | What the AI understood (appears later) | Read it |
| `outline.md` | The plan of the document (appears later) | Read and approve it |
| `chapters` | The text of the document | The AI writes it |
| `figures` | The diagrams | The AI draws them |
| `build` | Temporary and log files | No |
| `output` | **The PDF** (appears after a build) | No |

---

## 7. Choose your AI route

| Question | A: Code | B: Cowork | C: Chat |
|---|---|---|---|
| Who saves the files? | AI | AI | You, with one command |
| Who builds the PDF? | AI | Usually you | You |
| How much work for you? | Least | Little | Most |
| Where do you go next? | [Section 8](#8-route-a-code-ai) | [Section 9](#9-route-b-cowork-ai) | [Section 10](#10-route-c-chat-ai) |

If you have all three, choose **A**.

---

## 8. Route A: Code AI

Examples of code AI tools are Claude Code, Codex, Cursor and GitHub Copilot
in agent mode.

### 8.1 Install the AI tool

Use your tool's official instructions. For Claude Code, see
<https://code.claude.com/docs/en/quickstart>. The Windows install command
on that page is:

```powershell
irm https://claude.ai/install.ps1 | iex
```

Open a new PowerShell and check:

```powershell
claude --version
```

### 8.2 Start the AI in your design folder

Set the three short names from [Section 6.1](#61-set-three-short-names).

**Claude Code:**

```powershell
Set-Location $design
```

```powershell
claude --add-dir "C:\specforge"
```

The first start asks you to sign in. It may also ask whether you trust the
folder. Answer yes only for a folder that you know.

**Another code AI:** open your design folder in that tool. Allow it to read
`C:\specforge`.

### 8.3 Give it this message

```text
Read C:\specforge\START-HERE.md and follow it.
My project is the "spec" folder in the current folder. It is already created.
Do not change my input files and do not change the Specforge folder.
Start with the analysis and ask me your questions.
Wait for my answers, and for my approval of the outline, before you write.
```

### 8.4 Permission questions

The AI asks before some actions.

| The AI wants to | Usual answer |
|---|---|
| Read Specforge or your input | Allow |
| Write inside `spec` | Allow |
| Run `doctor`, `check`, `inventory` or `build` of Specforge | Allow |
| Change `input` or `C:\specforge` | Refuse |
| Delete files, push to Git or upload files | Refuse, unless you asked for it |
| Install software | Ask why, then decide |

### 8.5 Continue

Go to [Section 11](#11-your-three-approvals). The AI does the build. If it
cannot build, use the command in [Section 12](#12-get-the-final-pdf).

---

## 9. Route B: Cowork AI

A cowork AI works on folders that you share. It may run in the cloud. Then
it cannot use the LaTeX on your computer, and **you** run the build. This is
normal.

### 9.1 Share two folders

1. Open your cowork tool and start a new task. In Claude, select **Cowork**
   in the message box of the desktop app.
2. Connect the folder `C:\specforge`.
3. Connect your design folder, for example `C:\designs\pulse-counter`.

Do not share your whole disk.

If the tool accepts only one folder, copy the Specforge folder into your
design folder, next to `input` and `spec`. Share only the design folder.

### 9.2 Give it this message

```text
Read START-HERE.md in the Specforge folder that I shared and follow it.
My project is the "spec" folder in the design folder that I shared.
It is already created. Use relative paths in project files.
Do not change my input files and do not change the Specforge folder.
Start with the analysis and ask me your questions.
Wait for my answers, and for my approval of the outline, before you write.
If you cannot build the PDF, tell me. I will build it.
```

### 9.3 Build when the AI asks

Answer the questions and approve the outline first
([Section 11](#11-your-three-approvals)). When the chapters are ready, set
the short names from [Section 6.1](#61-set-three-short-names), then run:

```powershell
specforge build $project --figures
```

### 9.4 Give the result back

1. Copy all lines that the command printed.
2. Paste them into the cowork task with this message:

```text
I ran the build. The messages are below.
The PDF is in spec/output. Check the messages and the PDF.
Tell me what you could not check.
```

3. If the AI makes a correction, build again.
4. Continue with approval 3 in [Section 11](#11-your-three-approvals).

---

## 10. Route C: Chat AI

A chat AI cannot save files or build. You copy its answers, and Specforge
saves them for you.

```text
make pack --> upload --> chat --> copy answer --> unpack --> build
                           ^                                   |
                           +------- paste build messages ------+
```

### 10.1 Make the pack

Set the short names from [Section 6.1](#61-set-three-short-names), then run:

```powershell
specforge chat-pack $project
```

The command lists every file that it packed. **Read this list.** It must
contain only files that you may upload. If it shows an `ERROR`, no new
pack was made. Correct the problem and do not upload an older pack.

The pack is `spec\build\chat-pack.md` in your design folder.

### 10.2 Start the chat

1. Start a new chat.
2. Upload these two files:
   - `C:\specforge\specforge-chat.md`
   - `chat-pack.md` from step 10.1
3. Send this message:

```text
Follow specforge-chat.md. My project is in chat-pack.md.
Start with the analysis and your numbered questions.
Wait for my answers, and for my approval of the outline, before you write.
When you give me files, use the exact file markers from specforge-chat.md.
```

### 10.3 Answer in the chat

Reply to the questions in the same chat. See
[Section 11](#11-your-three-approvals) for replies that you can copy.

### 10.4 Save an answer that contains files

Such an answer has lines like these:

```text
===== BEGIN FILE: chapters/01_introduction.md =====
...
===== END FILE =====
```

Do this for **each** answer that has them:

1. Click the chat's **Copy** button for the whole answer. Do not select the
   text with the mouse, because formatting can be lost.
2. Open the answer file:

```powershell
notepad "$design\answer.txt"
```

3. Click **Yes** if Notepad offers to create the file.
4. Delete any old text, paste, save and close. The encoding must be UTF-8,
   which is the normal setting in current Notepad.
5. Save the files into the project:

```powershell
specforge unpack $project "$design\answer.txt"
```

Success says `Wrote` and the number of files. An older copy of a replaced
file is kept in `spec\build\unpack-backup`.

### 10.5 Build when the chapters are ready

```powershell
specforge build $project --figures
```

1. Paste all printed lines into the chat.
2. Upload the PDF from `spec\output`.
3. Send:

```text
These are the build messages and the PDF. Check both.
If a correction is needed, give me complete files with the file markers.
Tell me what you could not check.
```

4. For each correction, repeat 10.4 and 10.5.

### 10.6 When the chat is too long, or you change to another AI

Save the last answer that has files (10.4). Make a new pack (10.1). Start a
new chat (10.2). The new pack contains the state, your saved answers and the
chapters.

If the pack is too large to upload, make it without inputs and upload the
design files separately:

```powershell
specforge chat-pack $project --no-inputs
```

For RTL, also run `specforge inventory $project` and upload
`spec\build\rtl-inventory.md`.

---

## 11. Your three approvals

These are the same in all routes. **The AI must stop and wait at each one.**

### Approval 1: Answer the questions

The AI shows what it understood and asks numbered questions. Each question
has a proposed answer.

```text
1. What happens after the largest count?
   Proposed default: the counter wraps to zero.
```

Check the AI's understanding first. Then reply:

```text
1. Yes, use the default.
2. No. <write the correct answer>
3. I do not know yet. Keep it as an open point.
```

Write "yes to all defaults" only after you read every default. Your answer
becomes a fact in the specification.

### Approval 2: Approve the outline

The AI shows chapters, figures and an estimated page count. Check:

- [ ] All main blocks and behaviors have a place.
- [ ] The figures are useful.
- [ ] The length is acceptable. A very small design can be less than 10
      pages. That is fine. Do not add empty text.

Reply with one of these:

```text
I approve the outline. Write the chapters and figures.
```

```text
The outline needs changes: <write the changes>. Show it to me again.
```

### While the AI writes

The AI may ask you to look at figures or answer a new question. Check every
figure: names, arrow directions and connections.

### Approval 3: Approve the PDF

An AI can make mistakes. Read the PDF yourself.

- [ ] The title page and author are correct.
- [ ] Port names, directions and widths match the design.
- [ ] Clock and reset are correct.
- [ ] Each behavior and priority is correct.
- [ ] Figures match the design and are readable.
- [ ] Nothing was invented.
- [ ] Unknown items are shown as open points.
- [ ] Nothing is cut at a page edge.

To ask for a correction:

```text
Do not release yet. Correct this:
Page <number>: <what is wrong> should be <what is correct>.
Build again, or tell me to build, and show me what changed.
```

To approve:

```text
I approve the release as revision 1.0 with status Released.
Update project.md, revision-history.md and status.md.
Then do the final build, or tell me to build.
```

### If the AI does not wait

```text
Stop. Follow the approval gates in the Specforge instructions.
Show me what you need me to decide, and wait for my answer.
```

---

## 12. Get the final PDF

Do this after approval 3. In the chat route, first unpack the updated files.
A code AI may already have done the build.

**1. Close the PDF** if it is open. An open PDF can block the build.

**2. Build:**

```powershell
specforge build $project --figures
```

**3. Read the result.** A good result contains:

```text
Clean build: no overfull boxes, undefined references or missing characters.
Wrote C:/designs/pulse-counter/spec/output/PCNT_High-Level_Specification.pdf
```

Give any `WARNING` or `ERROR` to the AI and correct it.

**4. Open the PDF:**

```powershell
Invoke-Item "$project\output\*.pdf"
```

**5. Check** that the title page shows the approved revision and status.

Your deliverables are in `spec\output`:

| File | Use |
|---|---|
| `PCNT_High-Level_Specification.pdf` | The document to share |
| `PCNT_High-Level_Specification.md` | The same text in Markdown |

`PCNT` is replaced by your short name. The Markdown file shows its diagrams
only while the `figures` folder stays in the project.

**You are finished.**

---

## 13. Continue, change or start another design

### Continue on another day

- **Code or cowork:** start as before and send:

```text
Read START-HERE.md in the Specforge folder and follow it.
Continue my project in the "spec" folder from status.md.
Tell me the current step and what you need from me.
```

- **Chat:** follow [Section 10.6](#106-when-the-chat-is-too-long-or-you-change-to-another-ai).

### Your design changed

Change your input files yourself. Then send:

```text
My input files changed. List what changed and which sections are affected.
Wait for my approval before you change the document.
After approval, update the revision history and build again.
```

In the chat route, make and upload a new pack first.

### Change colors or fonts

Ask the AI:

```text
Change the document style: <what you want>.
Use style.md. Do not change the Specforge folder.
```

To do it yourself, open `style.md` and replace `overrides: {}` in the first
`yaml` box. This example changes the accent color:

```yaml
overrides:
  colour:
    accent_primary: "#2F5D8A"
```

All possible keys are in `styles/style-defaults.md` in the Specforge
folder.

### Start another design

Use a new design folder and a new `spec` folder. Repeat Sections 5 and 6.
You do not need to install again. Never mix two designs in one project.

### Move to another computer

Copy the complete design folder, with both `input` and `spec`. Install
Specforge on the new computer with [Section 4](#4-install).

### Get a newer Specforge

1. Rename the old `C:\specforge` folder, for example to `specforge-old`.
2. Install the new one with [Section 4.1](#41-get-specforge).
3. Run the check in [Section 4.3](#43-check-your-computer).
4. Read `CHANGELOG.md` before you build an old project again.
5. From 0.2.0: `specforge.cmd` no longer exists. Use the commands in this
   guide.

---

## 14. Fix common problems

Read the **first** line that starts with `ERROR`.

### Installation

| You see | Do this |
|---|---|
| `texlua` is not recognized | Install LaTeX (4.2). Then close and reopen PowerShell. If MiKTeX is already installed, see below this table |
| `MISSING` in the doctor result | Follow Section 4.3 |
| `pdftocairo` is `optional` | The PDF still builds. Only previews are skipped |
| A message that `specforge.lua` cannot be found | Check the folder with the `Test-Path` command in 4.1 |
| `miktex` is not recognized | Close and reopen PowerShell after installing MiKTeX |
| `claude` is not recognized | Open a new PowerShell |

If `texlua` is still not found after a MiKTeX installation for one user, run
this. It works until you close the window:

```powershell
$env:Path += ";$env:LOCALAPPDATA\Programs\MiKTeX\miktex\bin\x64"
```

### Commands

| You see | Do this |
|---|---|
| `specforge` is not recognized | Set the short names again (6.1) |
| `is missing for` or `an empty value is not allowed` | Set the short names again (6.1) |
| `needs a value` | Write a value between the quotes, or remove that option |
| `unexpected value` | Put quotes around the whole value |
| `a value contains a double quote` | Remove quote marks inside the value, and any `\` at the end of a path |
| `--approach must be design-info or rtl` | Check the spelling |
| `becomes part of the file name` | Use letters, numbers and `-` in the short name |
| `already has a project.md` | The project exists. Continue it, or use a new folder |
| `create the project outside the specforge folder` | Use a folder such as `C:\designs\...\spec` |
| `has no project.md` | `$project` is wrong, or you did not do 6.2 |
| `was set up for specforge` | Your project is older. Ask the AI to read `CHANGELOG.md` and tell you what changed |

### Inputs

| You see | Do this |
|---|---|
| `folder does not exist` | Correct the path in the command, or in `project.md` |
| `must be a folder, and this is a file` | Give the folder that contains the file |
| `contains the project` | Move your design files into their own `input` folder, next to `spec` |
| `contains a specforge project` | An input folder must hold only design files. Move the project out |
| `is a folder that specforge writes to` | Do not use `build`, `output`, `chapters` or `figures` as input |
| `top module '...' not found` | Use one of the module names shown. Capital letters matter |
| `is a package, not a module` | Give the name of the top module |
| `no Markdown files` | Use `.md` files. Check for names such as `design.md.txt` |
| `no RTL files` | Check the input folder and the file extensions |
| `is not UTF-8 text` | Open the file in Notepad and save it with encoding UTF-8 |
| `document.author is empty` | Fill in `author` in `project.md` |

### Chat

| You see | Do this |
|---|---|
| `no file blocks found` | Use the Copy button, or ask: "Give the files again with the exact file markers" |
| `may have been cut off` | Ask: "Your answer was cut off. Give the last file again, complete" |
| `is not a file an AI answer may write` | Ask the AI to use only the allowed file paths |
| `figure check failed` | Paste the error into the chat and ask for corrected figure files |
| The AI forgot earlier work | Make a new pack and start a new chat (10.6) |

### Build

| You see | Do this |
|---|---|
| `no chapter files` | Normal before drafting. Approve the outline and let the AI write |
| `cannot write` and `Permission denied` | Close the PDF and build again |
| `lualatex failed` | Give the error and `spec\build\main.log` to the AI |
| `does not exist in this document` | Give the warning to the AI. A reference is wrong |
| `Overfull` | Give the warning to the AI. Something is too wide |
| `below the page budget` | Fine for a small design, if nothing is missing |
| `above the page budget` | Ask the AI to shorten, or approve the longer length |
| `contrast check failed` | Choose a darker color in `style.md` |

### Still stuck?

Give your AI this message, with the text of the error:

```text
I am following USER-GUIDE.md of Specforge.
I ran this command: <command>
I got this output: <output>
Explain the cause in simple English and give me one step at a time.
Do not change the Specforge folder or my input files.
```

---

## 15. macOS and Linux

**These systems have not been tested yet.** The steps are the same. Only
installation and commands are different.

### Install

- **macOS:** install MacTeX from <https://tug.org/mactex/>. If you use
  Homebrew, `brew install poppler` adds the figure previews.
- **Debian or Ubuntu Linux:**

```sh
sudo apt update && sudo apt install texlive-full poppler-utils
```

Put the Specforge folder at `~/specforge`. Open a new terminal.

### Set the short names in every new terminal

```sh
specforge() { sh "$HOME/specforge/specforge.sh" "$@"; }
design="$HOME/designs/pulse-counter"
project="$design/spec"
```

### Check the computer

```sh
specforge doctor --build
```

### Prepare and create

Create the input folder. Save the example text from Section 5 in it with
any text editor.

```sh
mkdir -p "$design/input"
```

For Markdown:

```sh
specforge new "$project" --approach design-info --input "$design/input" --title "Pulse Counter" --short PCNT --author "Design Engineer"
```

For RTL:

```sh
specforge new "$project" --approach rtl --input "$design/input" --top pulse_counter --title "Pulse Counter" --short PCNT --author "Design Engineer"
```

### The other commands

| Windows command in this guide | macOS or Linux |
|---|---|
| `specforge build $project --figures` | `specforge build "$project" --figures` |
| `specforge inventory $project` | `specforge inventory "$project"` |
| `specforge chat-pack $project` | `specforge chat-pack "$project"` |
| `specforge unpack $project "$design\answer.txt"` | `specforge unpack "$project" "$design/answer.txt"` |
| `Invoke-Item "$project\output\*.pdf"` | macOS: `open`, Linux: `xdg-open`, then the PDF path |
| `claude --add-dir "C:\specforge"` | `claude --add-dir "$HOME/specforge"` |
| `C:\specforge\START-HERE.md` in an AI message | `~/specforge/START-HERE.md` |

---

## 16. Words used in this guide

| Word | Meaning |
|---|---|
| AI agent | An AI that can use files or run commands |
| Build | Making the PDF from the chapters and figures |
| Chapter | One part of the document |
| Design information | Your written description of the design |
| Gate | A point where the AI must wait for your approval |
| High-level specification | A document of what a design does and how it is organized |
| LaTeX | The program that makes the PDF |
| Markdown | Plain text with simple marks, saved as `.md` |
| Open point | Something not decided yet, shown clearly in the document |
| Outline | The plan of chapters and figures |
| Pack | One file with your project, to upload to a chat |
| Project | The folder where one document is made |
| RTL | Hardware code in SystemVerilog or Verilog |
| Top module | The highest module of the design |
| Unpack | Saving the files from a chat answer |

---

## 17. What has been tested

Specforge 0.2.1 is young. This is its real state:

| Item | State |
|---|---|
| Windows 11 with MiKTeX already installed | Tested |
| Commands in this guide: create, inventory, pack, unpack, build | Tested on the example |
| New MiKTeX installation and the package repair commands | Not tested |
| macOS, Linux and TeX Live | Not tested |
| A complete document with 0.2.1 by any AI, in any route | Not tested yet |
| Specifications other than high-level, and VHDL | Not supported |

Always review the PDF before you share it.

AI tools and installers change their screens. If a button has a different
name, use the official help of that tool.
