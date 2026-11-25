# specforge progress

Read this first when you resume work on the framework. It records the
framework only, never the designs it was used on.

## State

Version 0.3.0: complete design specifications, detailed or high-level diagrams,
state machine notation, page maximum, workspace layout, plain-name colours.

## Done

- One texlua tool in `tools/`, replacing the PowerShell scripts of 0.1.0.
- One root skill and model-neutral guides.
- Entry points for Claude Code: `START-HERE.md`, `SKILL.md`, `CLAUDE.md`.
- Test suite in `tests/`, including the command line as a separate process.
- 0.2.1: no batch launcher; inputs are checked before anything is written.
- `USER-GUIDE.md` for first-time users. When a command or message changes,
  update the guide in the same change.

## Not verified

- Linux, macOS and TeX Live.
- A complete 0.3.0 document written by an AI (the examples were written by
  hand to test the notation).
- The page estimate factors for complete specifications (first estimates).

## Next

- Try the framework on further designs, one at a time, and turn each
  finding into a test and a fix.
- Later, when asked: detailed specification type, VHDL.
