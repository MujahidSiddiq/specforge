# Instructions for AI agents

Two different jobs are possible in this folder. Decide which one the user
asked for.

## Writing a specification of a design

Read `START-HERE.md` and follow it. Write only in the user's project
folder, never in this folder.

## Improving specforge itself

Only when the user asks for a change to the framework.

1. Read `ARCHITECTURE.md`, `PROGRESS.md` and the files you will change.
2. Discuss the change with the user before making it.
3. Keep the framework generic: no project names, design data, personal
   names, e-mail addresses or local paths. Examples use invented designs.
4. Keep the one implementation in `tools/` (texlua, standard libraries
   only). Text from a project is data: escape or validate it before it
   reaches LaTeX, a file path or a program.
   Do not add a .cmd or .bat launcher: cmd.exe runs parts of its arguments
   as commands before the batch file starts.
5. Run `texlua tests/run.lua` and add a test for each fixed bug.
6. Run `specforge bundle` so that `specforge-chat.md` is current, then
   `specforge bundle --check`.
7. Update `CHANGELOG.md` and `PROGRESS.md`. For a release, `VERSION`, both
   files in `.claude-plugin/` and `config-templates/project.md` carry the
   same version.
8. Commit with a message that says what changed. Push only when asked.
9. A release zip: `git archive --format=zip --prefix=specforge/
   --output=dist/specforge-<VERSION>.zip HEAD` (with everything committed).
   It contains the test fixture, an invented design, which `doctor --build`
   uses.
