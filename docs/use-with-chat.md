# Use with a chat AI

For any AI that can only chat and read uploaded files. The AI writes; you
save and build with two commands. The commands need LaTeX on your computer
(see `install.md`).

Check first that your organization allows the design to be given to that
AI service: the pack below contains your inputs.

## 1. Create the project

See step 4 of `install.md`.

## 2. Make the pack

```powershell
texlua "D:\specforge\tools\specforge.lua" chat-pack "D:\designs\fifo\spec"
```

It lists every file it included. The result is `build\chat-pack.md` in the
project.

## 3. Start the chat

Upload two files: `specforge-chat.md` from the specforge folder, and the
pack. Then write:

```text
Follow specforge-chat.md. My project is in the pack. Start with the
analysis and your questions. Do not write the document before I approve
the outline.
```

If the files are too large for one upload, make the pack with
`--no-inputs` and upload the design files separately.

## 4. Save each answer that contains files

Copy the answer into a text file, for example `D:\designs\fifo\answer.txt`,
and run:

```powershell
texlua "D:\specforge\tools\specforge.lua" unpack "D:\designs\fifo\spec" "D:\designs\fifo\answer.txt"
```

Only specforge project files are written. A replaced file is kept in
`build\unpack-backup`. An incomplete answer is refused.

## 5. Build

```powershell
texlua "D:\specforge\tools\specforge.lua" build "D:\designs\fifo\spec" --figures
```

Paste errors and warnings into the chat. Upload the PDF for the visual
check, and look at it yourself.

## Continuing in a new chat, or with another AI

Repeat steps 2 and 3. The pack carries the project state, the answers and
the chapters written so far.

## Without LaTeX on this computer

The chat can still do the analysis, questions and outline from uploaded
inputs, and give you the files to save by hand. There is no PDF until the
project is built on a computer with LaTeX.
