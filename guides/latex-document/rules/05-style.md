# 05 - Style and colour

## Where style comes from

| Source | Contents |
|---|---|
| `<specforge>/styles/style-defaults.md` | Default of every style key |
| `<project>/style.md` | The project's overrides (only the keys it changes) |
| `<specforge>/styles/colour-guide.md` | Rules every document follows, whatever the values |

The build merges the defaults with the overrides and
generates the LaTeX style files. Nothing else defines a style value.

## Rules

1. **Never hard-code style in a chapter or figure.** No colour names, hex
   values, font commands, font sizes or spacing in `chapters/` or
   `figures/`. Use the Markdown constructs and the TikZ styles; they take
   their values from the style keys.
2. **Change the look through `style.md`.** To change a value, add its key
   under `overrides`, with the same nesting as in `style-defaults.md`. Do
   not edit `style-defaults.md` for one project.
3. **A user's request for a different look is an override.** Record it in
   `style.md` and mention it in `clarifications.md`; confirm the exact
   values with the user if the request is not exact ("a bit larger").
4. **Colours keep their roles.** Text uses `text_primary` and
   `text_secondary`; the accent is for graphics only (rules, highlights),
   never for text; semantic colours (`info`, `warn`, `error`) always appear
   with a text label.
5. **Contrast is checked on every build.** A failing pair stops the build;
   fix the override, do not weaken the check.
6. **The accent is one colour.** Overriding `accent_primary` derives the
   other accent tokens from its hue unless they are overridden too. Read
   the hue collisions in `build/style-report.md` and keep the accent out of
   contexts with the colliding meaning.
7. **Fonts** are installed OpenType families. File-based faces are given as
   `*-Regular` patterns (as in the defaults); otherwise give the family
   name only.

## Colour specification record

Every document has a `colour-record.md` (from
`<specforge>/styles/colour-record-template.md`), filled in from
`build/style-report.md`: overrides, derived tokens, hue collisions and the
contrast table. Update it whenever a colour override changes.

## Adding a style key

A new styled element needs a new key: add it with its default to
`style-defaults.md`, use its macro in `latex/` (the name is the key path in
CamelCase with the prefix `\sf`), document it, and note it in
`CHANGELOG.md`. This is a framework change, not a project change.
