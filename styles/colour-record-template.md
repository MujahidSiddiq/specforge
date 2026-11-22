# Colour specification record

Required for every document by `colour-guide.md`, Section 7.4. Copy this
file into the project folder as `colour-record.md` and fill it in after the
merged style is known. With no colour overrides, the values of
`style-defaults.md` and the results below apply unchanged.

```text
Theme(s):              Light
Accent source:         Default (no brand colour supplied) | <override value>
Derived tokens:        accent.primary   <#RRGGBB>
                       accent.strong    <#RRGGBB>
                       accent.subtle    <#RRGGBB>
                       accent.secondary <#RRGGBB>
Hue collisions:        <accent hue against the semantic colours, and how it is handled>
Chart palette:         None | <palette>
Output media:          Screen and office print
Greyscale required:    Yes (technical specification)
Additional colours:    None | <list with justification>
Deviations:            None | <numbered list>
Contrast results:      All pairs pass | <failing pairs>
```

## Foreground/background pairs used

The rows below are the pairs used by the default style, with their contrast
ratios. Recompute any row whose colours are overridden.

| Use | Foreground | Background | Ratio | Requirement |
|---|---|---|---:|---|
| Body text, headings, table text, diagram labels | `text_primary` `#202729` | `bg_page` `#FFFFFF` | 15.17 | 4.5 |
| Table header text, labels on the top-level boundary | `text_primary` | `bg_subtle` `#F5F7F6` | 14.10 | 4.5 |
| Text on a highlighted element | `text_primary` | `accent_subtle` `#EAF5EE` | 13.58 | 4.5 |
| Captions, header, footer, sub-labels, width labels | `text_secondary` `#555F5B` | `bg_page` | 6.61 | 4.5 |
| `PENDING` label | `warn_fg` `#855000` | `bg_page` | 6.67 | 4.5 |
| `OPEN POINT` label | `warn_fg` | `warn_bg` `#FFF5DF` | 6.16 | 4.5 |
| Open-point text | `text_primary` | `warn_bg` | 14.01 | 4.5 |
| Block outlines, table outer rules, hatch pattern | `border_strong` `#76817C` | `bg_page` | 4.03 | 3.0 |
| Top-level boundary and ports | `border_strong` | `bg_subtle` | 3.75 | 3.0 |
| Wires, arrows, clock waveform | `text_secondary` | `bg_page` | 6.61 | 3.0 |
| Wires crossing the boundary fill | `text_secondary` | `bg_subtle` | 6.14 | 3.0 |
| Chapter rule, title-page rule, highlight | `accent_primary` `#3A8760` | `bg_page` | 4.36 | 3.0 |
| Table row rules, timing grid (decorative) | `border_subtle` `#D6DEDA` | `bg_page` | 1.37 | none |

## Colour independence

State, for the document, how each colour-coded element is also identified
without colour (labels, line widths, patterns, position).
