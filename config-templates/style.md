# Style

Leave both blocks empty to use the default style. Only what you write is
changed; everything else keeps its default.

```yaml
colours: {}
overrides: {}
```

## Colours by plain name

Write `#RRGGBB` values under `colours`, replacing `colours: {}`:

```yaml
colours:
  text: "#1B1F24"
  background: "#FFFFFF"
  accent: "#2F5D8A"
  block_fill: "#EAF1F8"
  block_border: "#4A5A6A"
  waveform: "#1B1F24"
  state_fill: "#EAF1F8"
overrides: {}
```

| Name | Colours |
|---|---|
| `text`, `secondary_text` | Body text; captions, header, footer, wires and sub-labels |
| `background`, `light_background` | Page; table headers and the top-level boundary |
| `lines`, `light_lines` | Outlines and table rules; decorative rules |
| `accent` | Chapter rule and highlights (the related accent tones follow it) |
| `headings`, `captions`, `table_header` | Headings; caption text; table header fill |
| `block_fill`, `block_border` | Blocks in block diagrams |
| `boundary_fill`, `boundary_border` | The top-level boundary |
| `wires`, `highlight` | Connections; a highlighted path |
| `waveform`, `clock`, `waveform_grid` | Timing diagrams |
| `state_fill`, `state_border`, `transitions`, `reset_arrow` | State machines |

## Any other value

Copy a key from `styles/style-defaults.md` into `overrides`, with the same
nesting. A colour value is `#RRGGBB` or the name of a colour token.

```yaml
colours: {}
overrides:
  page:
    class_font_size_pt: 12
  diagrams:
    wire:
      line_pt: 1.0
```

## Rules

- Every colour must keep text and lines readable: the build checks the
  contrast of each pair of foreground and background (colour-guide.md
  Section 3.2) and stops with the pair that fails. Choose a darker or
  lighter colour then; the check cannot be switched off.
- When `accent` changes, its lighter and darker tones are derived from it,
  unless they are set too.
- The same colour may not be set both by plain name and in `overrides`.
- A font override names an installed OpenType font family.
- An unknown name or key, or a value of the wrong kind, is an error.
