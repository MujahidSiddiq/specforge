# Style overrides

Copy this file into the project folder. Leave the `overrides` block empty to
use the default style.

To change a value, copy its key from `styles/style-defaults.md` into the
block below, keeping the same nesting, and set the new value. Only the keys
you write are changed; every other key keeps its default.

```yaml
overrides: {}
```

## Example

This example changes only the accent colour and the base font size; every
other value stays at its default:

```yaml
overrides:
  colour:
    accent_primary: "#2F5D8A"
  page:
    class_font_size_pt: 12
```

## Rules

- A colour override must still meet the contrast rules of
  `styles/colour-guide.md` (Part II). The assistant checks this and reports
  any pair that fails before building.
- When the accent colour changes, the derived accent tokens
  (`accent_strong`, `accent_subtle`, `accent_secondary`) are derived again
  as described in `styles/colour-guide.md`, Section 6.1, unless they are
  overridden as well.
- A font override names an installed OpenType font family.
- An unknown key or a value of the wrong kind is an error.
