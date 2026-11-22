# Make a zip to carry to another computer

Run in the specforge folder, with everything committed:

```powershell
git archive --format=zip --prefix=specforge/ --output=dist/specforge-0.2.1.zip HEAD
```

Create `dist` first if it does not exist, and use the version from
`VERSION` in the file name. The zip holds the committed files without the
Git history. It is complete: extract it anywhere and continue with
`install.md`.

The small test fixture is included, because `doctor --build` uses it. It
describes an invented design.

Do not put project folders inside specforge: they would travel with it.
