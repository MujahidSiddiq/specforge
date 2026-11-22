# Use with a code agent

## Any code agent

This works with every agent that can read files and run commands, and needs
no installation. Give it access to the specforge folder and to your design
folder, then paste:

```text
Read D:\specforge\START-HERE.md and follow it.
My project folder is D:\designs\fifo\spec.
Do not change my design files, and ask me before you write the document.
```

Replace the two paths. If the project folder does not exist yet, also say
which approach you want (`design-info` or `rtl`), where the inputs are and,
for RTL, the top module.

Agents that read `AGENTS.md` find the same instructions when they are
started in the specforge folder. Do not copy `AGENTS.md` into a design
repository: it describes this folder.

## Claude Code

Choose one of three ways.

**1. The prompt above.** Nothing to install.

**2. As a plugin**, available in every project. In a terminal:

```powershell
claude plugin marketplace add "D:\specforge"
```

```powershell
claude plugin install specforge@specforge
```

Then start a new session in your design folder and ask:

```text
Use specforge to write the high-level specification. Project folder: spec
```

After specforge changes, run `claude plugin marketplace update specforge`
and install the new version with `claude plugin update specforge@specforge`.

**3. As a skill of one project.** Copy the whole specforge folder to
`<design repository>/.claude/skills/specforge/`. The folder must stay
complete; copying only `SKILL.md` or `guides/` does not work. Start Claude
Code in that repository, accept its question whether you trust the folder,
then restart it. If specforge is not listed there, use way 1 or 2.

## What to expect

The agent asks questions and waits, proposes an outline with a page
estimate and waits, then writes, builds and shows the PDF for your
approval. If it skips a wait, tell it: "Follow the gates in START-HERE.md."
