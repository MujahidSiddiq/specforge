# Design Documentation Color Schemes


**Purpose:** A reusable visual and formatting standard for creating professional documents across digital, print, technical, educational, research, and business environments, written so that a person or an AI document generator can apply it consistently.

---

# Part I — Foundations

# 1. Purpose and Scope

This document establishes universal rules for creating professional, readable, consistent, and accessible documents.

It defines standards for:

- Visual identity and colour usage.
- Typography and heading hierarchy.
- Page layout and spacing.
- Tables and structured data.
- Diagrams, flowcharts, and architecture illustrations.
- Timing diagrams and waveforms.
- Code snippets and technical examples.
- Mathematical equations.
- Figures, images, and screenshots.
- Notes, warnings, and callouts.
- Headers, footers, and page numbering.
- Digital accessibility and PDF structure.
- Physical printing and publishing.
- Dark-mode presentation.
- Responsive layouts and different page sizes.
- Multilingual and localized documents.
- Document-specific visual adaptations.
- AI-assisted document generation and quality validation.

## 1.1 Supported Document Categories

The system should support, but is not limited to:

| Category | Examples |
|---|---|
| Books and educational material | Textbooks, tutorials, lecture notes, learning guides |
| Technical documentation | Specifications, interface documents, design descriptions |
| Engineering documentation | Architecture documents, implementation guides, technical reports |
| Research documents | Research papers, experimental reports, scientific publications, theses |
| User documentation | User manuals, installation guides, product guides |
| Process documentation | Laboratory manuals, procedures, workflows, operational instructions |
| Business documents | Proposals, project reports, business plans, executive reports |
| Presentations exported to PDF | Slide decks, lecture slides, briefing packs |
| Forms | Fillable and printable forms, checklists, templates |
| Legal, financial, and regulatory | Contracts, policies, statements, compliance reports |
| Posters and single-page material | Conference posters, flyers, cheat sheets |
| General documents | Reference guides, handbooks, training materials |

The system must adapt to the document's purpose rather than force every document into one fixed layout.

## 1.2 How to Use This Document

1. Read Part I (foundations) and Part II (colour system) in full before generating any document.
2. Use Part III and Part IV for typography, layout, and component rules.
3. Use Part V to adapt the defaults to the document category, format, language, and output medium.
4. Use Part VI to validate and export the document.

Sections 3–7 are the single source of truth for colour. Other sections refer to them instead of repeating colour rules.

## 1.3 Normative Language

The keywords below have the following meanings throughout this document:

| Keyword | Meaning |
|---|---|
| **MUST** / **MUST NOT** | Mandatory. A document that breaks this rule is non-conforming. |
| **SHOULD** / **SHOULD NOT** | Expected default. Deviate only for a stated reason, and record the reason (see Section 26.1). |
| **MAY** | Optional. Use when it helps the reader. |

Lower-case "must", "should", and "may" in examples and explanations carry their ordinary meaning.

## 1.4 Order of Precedence

When rules conflict, apply the higher-ranked source:

1. Legal, regulatory, and safety requirements (for example, accessibility law, product-safety labelling standards).
2. A mandatory external template (for example, a journal, conference, or client template).
3. The organization's brand guidelines.
4. Explicit instructions for the specific document.
5. The rules in this document.
6. The default values in this document.

When a higher-ranked source overrides a rule here, keep every other rule that does not conflict with it.

## 1.5 Terms

| Term | Definition |
|---|---|
| Colour token | A named colour role (for example, `text.primary`) with a defined value for each theme. |
| Theme | A complete set of token values: Light (default) or Dark. |
| Normal text | Text smaller than large text. |
| Large text | Text at least 18 pt regular, or at least 14 pt bold (WCAG 2.x definition). |
| Contrast ratio | The WCAG 2.x relative-luminance ratio, from 1:1 to 21:1, computed without rounding. |
| Meaningful graphic | A graphical element that a reader needs in order to understand content: a chart line, a status marker, a diagram boundary that defines a group, a form-field boundary, an icon that carries meaning. |
| Decorative element | An element that can be removed without losing information. |
| Accent hue | The single brand or document hue used for emphasis. |
| Semantic colour | A colour reserved for a status meaning: Information, Warning, Error, Positive. |
| Hue distance | The absolute difference in OKLCH hue angle between two colours, in degrees (0–180). |

---

# 2. Core Design Principles

Every document must follow these principles.

## 2.1 Readability First

Readability takes priority over decoration.

- Text must remain comfortable to read.
- Foreground and background colours must provide sufficient contrast (Section 3.2).
- Diagrams must communicate information clearly.
- Tables must be easy to scan.
- Layouts must avoid unnecessary visual complexity.
- Decorative elements must not compete with the content.

## 2.2 Structure Before Decoration

The document's structure must communicate its information hierarchy.

Use:

- Consistent heading levels.
- Logical section organization.
- Appropriate numbering where useful.
- Clear grouping of related information.
- Consistent spacing.
- Meaningful captions and labels.

Never use colour, borders, or decorative boxes as substitutes for proper structure.

## 2.3 Neutral by Default

The majority of a document should use neutral colours.

Use:

- Light backgrounds for standard reading.
- Dark text for primary content.
- Subtle borders for separation.
- Accent colours for selected emphasis.
- Semantic colours only when they communicate meaningful information.

Avoid making every section, heading, table, or diagram independently colourful. Measurable limits are given in Section 4.5.

## 2.4 Consistency

Maintain consistent visual meaning throughout the document.

For example:

- The same heading level must have the same appearance.
- Similar tables must follow the same styling.
- Similar diagram elements must use consistent shapes.
- Warnings must have a consistent visual treatment.
- Repeated components must follow the same spacing and typography rules.
- A colour that means something in one place must not mean something else elsewhere in the same document.

## 2.5 Purpose-Based Design

Select visual components according to the information being communicated.

Examples:

- Use a block diagram to explain architecture.
- Use a timing diagram to explain temporal behavior.
- Use a table to present structured information.
- Use a flowchart to explain a process.
- Use an equation to express mathematical relationships.
- Use a chart to communicate numerical trends.

Do not add visual elements merely to decorate a page.

## 2.6 Accessibility and Portability

Documents should remain usable across:

- Different screen sizes.
- PDF readers.
- Common operating systems.
- Printing environments, including black-and-white printers.
- Projectors, for documents that will be presented.
- Assistive technologies.
- Readers with colour-vision deficiencies.
- Different languages and writing directions.

Avoid relying on a particular font, application, or rendering environment unless the project explicitly requires it. Where a preferred font may be unavailable, specify an openly licensed fallback (Section 8.1).

---

# Part II — Colour System

# 3. Colour Fundamentals

## 3.1 Colour Space and Notation

- All token values in this document are **sRGB** colours written as HEX (`#RRGGBB`).
- Digital PDFs **SHOULD** use sRGB and, where the export tool supports it, embed an sRGB output intent or ICC profile.
- Print production uses the printer's colour workflow (Section 6.5). HEX values are not print specifications.
- Colours **MUST** be specified as solid values. Do not create tints with opacity or transparency; transparency changes the effective colour, makes contrast unpredictable, and can cause flattening problems in print.
- Perceptual adjustments in this document (lightness, chroma, hue) use the **OKLCH** colour space.

## 3.2 Contrast Requirements

These thresholds follow WCAG 2.2 Success Criteria 1.4.3 (Contrast Minimum), 1.4.11 (Non-text Contrast), and 1.4.1 (Use of Color). They are the baseline for every theme and output medium.

| Element | Minimum contrast ratio | Measured against |
|---|---|---|
| Normal text (including captions, footnotes, table text, labels in figures) | **4.5:1** | The background directly behind the text |
| Large text (≥18 pt, or ≥14 pt bold) | **3:1** | The background directly behind the text |
| Meaningful graphics (chart lines and markers, status icons, defining borders, form-field boundaries, diagram connectors) | **3:1** | Every adjacent colour |
| Text links in body text, if distinguished from body text by colour | **3:1** against surrounding text, **plus** a non-colour cue (underline) | Surrounding body text |
| Decorative elements, disabled elements, logotypes | No requirement | — |

Rules:

- Contrast ratios **MUST NOT** be rounded. 4.49:1 fails 4.5:1.
- Contrast **MUST** be checked for every actual foreground/background pair used, not only for the token's default background.
- Text over images, gradients, or patterns **MUST** meet the requirement at its lowest-contrast point, or be placed on a solid panel that does.
- Thin or light fonts (weight below 400) and very small text (below 9 pt) **SHOULD** use at least 7:1, because the WCAG ratio overestimates their legibility.
- Body text in documents intended for projection **SHOULD** use at least 7:1 (Section 6.6).

APCA (Accessible Perceptual Contrast Algorithm) **MAY** be used as an additional design check. It **MUST NOT** be used to justify a combination that fails the WCAG 2.x thresholds above. As of 2026, WCAG 3 is a working draft and its contrast method has not been decided.

## 3.3 Colour Harmony Model

The default palette is a **tinted-neutral, single-accent** scheme:

- **Neutrals** carry almost all text, backgrounds, and borders. They are slightly tinted toward the accent hue (OKLCH chroma ≤ 0.012) so the page feels coherent without looking coloured.
- **One accent hue** provides graphical emphasis (rules, markers, diagram highlights, chart highlights, fills). It is never a text colour (Section 4.5). Its lighter and darker steps (subtle, secondary, primary, strong) share the same hue and differ only in lightness and chroma, which creates a monochromatic accent scale.
- **Semantic hues** (Information ≈ 250°, Warning ≈ 67°, Error ≈ 26°, Positive ≈ 159° in OKLCH) follow widely recognized conventions and are kept separate from decoration.
- **Visual hierarchy** comes from lightness first, then chroma, then hue. Readers notice lightness differences before hue differences, and lightness survives greyscale printing and colour-vision deficiencies.

Do not introduce additional hues outside this model except for data visualization palettes (Section 5.5), which stay inside figures.

---

# 4. Colour Tokens

## 4.1 Core Tokens

Each token has one value per theme. The design system **MUST** preserve the same tokens even when the actual colour values change (Section 6.1).

| Token | v1 name | Purpose | Light | Dark | Allowed uses |
|---|---|---|---|---|---|
| `text.primary` | Primary Text | Main paragraphs, headings, important labels | `#202729` | `#E1E6E4` | Any text |
| `text.secondary` | Secondary Text | Captions, descriptions, metadata | `#555F5B` | `#A0ACAA` | Any text |
| `bg.page` | Page Background | Main document canvas | `#FFFFFF` | `#121617` | Page, chart plot area |
| `bg.subtle` | Secondary Background | Table headers, code blocks, grouped content | `#F5F7F6` | `#1B2123` | Background behind text |
| `border.subtle` | Border | Decorative separators, table row rules | `#D6DEDA` | `#2E3A3C` | Decorative lines only |
| `border.strong` | *(new)* | Meaningful boundaries: diagram block outlines, form fields, chart axes, callout borders | `#76817C` | `#6B7B7E` | Meaningful graphics |
| `accent.primary` | Primary Accent | Meaningful graphical highlights, rules, markers, diagram outlines | `#3A8760` | `#52B781` | Graphics only |
| `accent.secondary` | Secondary Accent | Decorative fills behind dark text (cover bands, chapter tabs) | `#A9D5BD` | `#2F5A43` | Decorative fills only |
| `accent.strong` | Dark Accent | High-emphasis graphics, chart highlights, solid fills behind white text (cover bands, slide title bars) | `#1E4D35` | `#8ED6AE` | Graphics and fills only |
| `accent.subtle` | Light Accent / Light Accent Background | Highlighted backgrounds | `#EAF5EE` | `#182E23` | Background behind text |

Notes:

- `accent.primary` in the Light theme is `#3A8760`. Version 1.0 used `#4BA173`, which gave 3.16:1 on white but only 2.93:1 on `bg.subtle` and 2.83:1 on `accent.subtle`, so it failed the 3:1 graphics requirement on the system's own tinted backgrounds. The new value keeps the same hue (OKLCH ≈ 159°) and reaches at least 3.90:1 on every light background.
- Accent tokens are **not text colours** (Section 4.5). Headings, labels, and body text use the neutral text tokens. The contrast values of accent tokens matter for graphics (3:1) and for white text placed on an `accent.strong` fill.
- `border.subtle` reaches only 1.37:1 on white. It **MUST NOT** be the only cue for a boundary the reader needs to see. Use `border.strong` for those.
- `accent.secondary` is decorative. It **MUST NOT** carry meaning and **MUST NOT** be used as a text colour.

## 4.2 Permitted Text and Background Pairings

Text tokens may be placed on background tokens only as shown. All values were computed with the WCAG 2.x formula (Appendix A).

**Light theme**

| Text token ↓ / Background → | `bg.page` | `bg.subtle` | `accent.subtle` | Semantic backgrounds |
|---|---|---|---|---|
| `text.primary` | ✓ | ✓ | ✓ | ✓ |
| `text.secondary` | ✓ | ✓ | ✓ | ✓ |
| `accent.strong` | ✗ (not a text colour) | ✗ | ✗ | ✗ |
| `accent.primary` | ✗ (not a text colour) | ✗ | ✗ | ✗ |
| Semantic foregrounds | ✓ | ✓ | Own background only | Own background only |

**Dark theme**

| Text token ↓ / Background → | `bg.page` | `bg.subtle` | `accent.subtle` | Semantic backgrounds |
|---|---|---|---|---|
| `text.primary` | ✓ | ✓ | ✓ | ✓ |
| `text.secondary` | ✓ | ✓ | ✓ | ✓ |
| `accent.strong` | ✗ (not a text colour) | ✗ | ✗ | ✗ |
| `accent.primary` | ✗ (not a text colour) | ✗ | ✗ | ✗ |
| Semantic foregrounds | ✓ | ✓ | Own background only | Own background only |

Text on `accent.secondary` **MUST** use `text.primary` of the same theme.

Accent tokens may still be the **background** behind text: white text on `accent.strong` (Light) reaches 9.68:1 and is permitted at any size; white text on `accent.primary` (Light) reaches only 4.36:1 and is permitted for large text only.

## 4.3 Semantic Colours

Use semantic colours only when the information requires them.

**Light theme**

| Category | Foreground (text, icon, border) | Background |
|---|---|---|
| Information | `#245A8D` | `#EDF4FA` |
| Warning | `#855000` | `#FFF5DF` |
| Error | `#A52626` | `#FBECEC` |
| Positive | `#1E4D35` | `#EAF5EE` |

**Dark theme** *(new — version 1.0 defined none)*

| Category | Foreground (text, icon, border) | Background |
|---|---|---|
| Information | `#7FB2E5` | `#14263A` |
| Warning | `#E3AC4F` | `#2B2210` |
| Error | `#F28B82` | `#331B1B` |
| Positive | `#6FCF97` | `#182E23` |

Light semantic foregrounds **MUST NOT** be reused in the Dark theme; on `#121617` they fall to between 1.88:1 and 2.73:1.

Rules:

- Semantic colours **MUST** always be supported by an explicit text label. Use one vocabulary per document. The default vocabulary is:

  | Category | Labels |
  |---|---|
  | Information | `INFO`, `NOTE` |
  | Warning | `WARNING`, `CAUTION` |
  | Error | `ERROR`, `FAIL` |
  | Positive | `PASS`, `SUCCESS` |
  | Neutral | `N/A`, `PENDING` |

- Colour **MUST NOT** be the only way to communicate meaning (WCAG 1.4.1).
- Semantic backgrounds differ from `bg.page` by only 1.08:1–1.14:1. They are an aid, not a boundary. Callouts and status cells that use them **MUST** also have a label, and **SHOULD** have a `border.strong` or semantic-foreground border.
- Under simulated deuteranomaly, the Light Warning and Error foregrounds become almost identical, and under protanomaly Error and Positive do. Differentiate semantic categories by label and icon or border style, never by hue alone.
- In the default palette, Positive uses the same colours as `accent.strong` and `accent.subtle`. Therefore accent-coloured highlights **MUST NOT** appear in status contexts (status columns, result tables, test reports), where a reader could mistake emphasis for "pass".

## 4.4 Utility Tokens

| Token | Purpose | Light | Dark | Rule |
|---|---|---|---|---|
| `text.link` | Hyperlinks in text | `#245A8D` | `#7FB2E5` | **MUST** be underlined. Its contrast against body text (2.11:1, Light) is below 3:1, so the underline is the required non-colour cue. |
| `bg.highlight` | Marked or highlighted text | `#FFF1B8` | `#4A3F12` | Use with `text.primary` only. Do not use it to mean "important"; use a callout instead. |

`text.link` intentionally shares the Information hue. The underline distinguishes links from Information labels.

## 4.5 Colour Usage Restrictions

- Keep the document predominantly neutral.
- Use accent colours selectively.
- Avoid assigning arbitrary colours to chapters, sections, modules, or components.
- Avoid excessive coloured backgrounds.
- Text **MUST** use only tokens permitted for text in Section 4.2. (This replaces the v1 rule "avoid bright colours for small text", which could not be checked.)
- **Accent colours MUST NOT be used as text colours**, including headings, subheadings, labels, captions, and links. Text is neutral (`text.primary`, `text.secondary`). The accent appears only in graphics, rules, markers, fills, and diagrams. Semantic status labels (Section 4.3) are the only coloured text, because their colour reinforces a labelled meaning.
- Avoid unnecessary gradients and decorative effects. Gradients **MUST NOT** sit behind text.
- Do not introduce additional colours without a clear purpose. Any colour that is not a token or part of a Section 5.5 chart palette **MUST** be justified in the colour specification (Section 7.4).
- Check foreground and background contrast for every important combination (Section 7).

Quantitative defaults for body pages (cover pages, chapter openers, and posters are exempt):

| Limit | Default |
|---|---|
| Accent hues per document | 1 |
| Non-neutral area (accent and semantic fills combined, excluding figures) | About 10% of the page area or less |
| Accent-coloured text, including headings | None (accent is graphics-only) |
| Semantic callouts per page | Usually no more than 2; more suggests that ordinary text has been turned into callouts |

These limits are heuristics for consistency. They **SHOULD** be followed unless a stated reason applies.

The palette is a starting point, not a guarantee of accessibility. Actual colour combinations must be checked.

---

# 5. Applying Colour to Components

Component sections in Part IV refer to this section for colour.

## 5.1 Headings and Body Text

| Element | Colour |
|---|---|
| Body text | `text.primary` |
| Captions, metadata, footnotes | `text.secondary` |
| Headings and subheadings, all levels | `text.primary` |
| Overlines, kickers, document metadata | `text.secondary` |
| Heading rules or markers (optional, Heading 1 only) | `accent.primary` short rule or left bar, or `border.subtle` |

Heading levels **MUST** be distinguishable by size and weight alone. Heading text **MUST NOT** use accent colours; if the document needs a visible brand touch near a heading, use a graphical marker (a short rule under Heading 1 or a bar beside it), never coloured heading text.

## 5.2 Tables

| Element | Colour |
|---|---|
| Header row | `bg.subtle` background, bold `text.primary`, `border.strong` bottom rule |
| Body rows | `bg.page` |
| Zebra striping (optional) | Alternate rows on `bg.subtle` |
| Row and column rules | `border.subtle` |
| Status cells | Semantic foreground text label; semantic background optional |
| Single highlighted cell or row | `accent.subtle` (never in status columns, see Section 4.3) |

When zebra striping is used, the header row **MUST** remain distinct from striped rows through bold text and the `border.strong` rule, because both use `bg.subtle`.

Do not colour entire tables when only a few values need emphasis.

## 5.3 Callouts

Every callout type has a fixed treatment. Callouts **MUST** be distinguishable without colour through their label and, where available, an icon or border style.

| Callout | Background | Left bar or border | Label colour | Non-colour cue |
|---|---|---|---|---|
| NOTE | Information background | Information foreground | Information foreground | Label + "i" icon |
| TIP | `bg.subtle` | `accent.primary` | `text.primary` | Label + lightbulb icon or none |
| IMPORTANT | `accent.subtle` | `accent.strong`, thick | `text.primary` | Label in bold capitals |
| WARNING / CAUTION | Warning background | Warning foreground | Warning foreground | Label + warning triangle |
| ERROR / DANGER (non-safety) | Error background | Error foreground | Error foreground | Label + error icon |
| EXAMPLE | `bg.subtle` | `border.subtle` | `text.primary` | Label |
| RESULT | `bg.page` | `border.strong` | `text.primary` | Label; use Positive or Error treatment only if the result is a pass or fail |
| ASSUMPTION | `bg.page` | `border.strong`, dashed | `text.primary` | Label + dashed border |
| REQUIREMENT | `bg.page` | `border.strong`, solid | `text.primary` | Label + requirement ID |

Safety hazards to people are not ordinary warnings; see Section 5.9.

## 5.4 Diagrams

| Element | Colour |
|---|---|
| Block outlines that define structure | `border.strong` |
| Block fills | `bg.page` or `bg.subtle`; `accent.subtle` for one highlighted block or group |
| Connectors and arrows | `text.secondary` or `text.primary` |
| Highlighted path or block | `accent.primary` outline or connector, with a label |
| External or optional elements | `border.strong`, dashed |
| Labels inside blocks | `text.primary` |

A diagram **MUST** remain understandable in greyscale. Differences that carry meaning **MUST** also use shape, line style, or labels (Section 12.3).

## 5.5 Charts and Data Visualization

Charts are the only place where colours outside the token set are allowed.

**Plot area:** `bg.page`. Do not place charts on `bg.subtle` or `accent.subtle`; several series colours drop below 3:1 there.

**Axes, ticks, gridlines:** axes and ticks `text.secondary`; gridlines `border.subtle`.

**Single-series and highlight charts:** light neutral bars (for example `#C9CFCC`) with a `border.strong` outline, and the item of interest filled in `accent.strong`. Annotation text beside the highlight stays `text.primary`. (Do not use `accent.primary` against `border.strong` bars to mark the highlight: both are near L* 50 and merge in greyscale.)

**Categorical palette (Okabe–Ito, Light theme), in this order:**

| Order | Name | HEX | Contrast on white | Use |
|---|---|---|---|---|
| 1 | Blue | `#0072B2` | 5.19:1 | Lines, markers, fills |
| 2 | Vermillion | `#D55E00` | 3.87:1 | Lines, markers, fills |
| 3 | Bluish green | `#009E73` | 3.42:1 | Lines, markers, fills |
| 4 | Reddish purple | `#CC79A7` | 3.06:1 | Lines, markers, fills |
| 5 | Neutral dark | `#202729` | 15.17:1 | Lines, markers, fills, "other" or baseline |
| 6 | Orange | `#E69F00` | 2.25:1 | Fills only, with a `text.primary` outline and direct labels |
| 7 | Sky blue | `#56B4E9` | 2.31:1 | Fills only, with a `text.primary` outline and direct labels |
| — | Yellow | `#F0E442` | 1.32:1 | **MUST NOT** be used on a light background |

In the Dark theme, the same hues apply, except that `#000000` and `#202729` **MUST NOT** be used and Blue (3.51:1 on `#121617`) **SHOULD** be used only for thick lines and fills.

Rules:

- Use no more than 5 colour-coded categories by default and never more than 7. Above that, group small categories as "Other", use small multiples, or label directly.
- Series **MUST** also differ by marker shape or line style (solid, dashed, dotted, dash-dot). The four leading Okabe–Ito colours have similar greyscale lightness (CIE L* 46–61), so colour alone does not survive greyscale printing.
- Prefer direct labels on lines and bars to legends.
- **Sequential data** (low to high): use a perceptually uniform, colour-vision-deficiency-friendly map such as *cividis* or *viridis*. Do not use rainbow or "jet" maps.
- **Diverging data** (below and above a meaningful midpoint): use a colour-blind-safe diverging scheme such as ColorBrewer *PuOr* or *BrBG*, with a light neutral midpoint at the reference value.
- Semantic colours **MAY** appear in charts only when the data is a status (for example, pass/fail counts), and **MUST** then match Section 4.3.
- The same category **MUST** keep the same colour in every chart in the document.

## 5.6 Code Syntax Highlighting

Keep code highlighting simple. Use **at most four colours**: one each for keywords, comments, and strings, and plain text for everything else. Plain, uncoloured code (`text.primary` only) is always acceptable.

| Element | What it covers | Light | Dark | Style |
|---|---|---|---|---|
| Keywords | The language's reserved words (for SystemVerilog, the IEEE 1800 keyword list, such as `module`, `logic`, `always_ff`, `if`, `property`, `assert`), plus compiler directives (`` `define ``, `` `include ``, `#include`) | `#0000FF` | `#569CD6` | **Bold** |
| Comments | `//`, `/* */`, `#` comments | `#008000` | `#6A9955` | *Italic* |
| Strings | Quoted text | `#A31515` | `#CE9178` | Regular |
| Everything else | Identifiers, signals, numbers, operators, punctuation, function and system-task names | `#202729` | `#CCCCCC` | Regular |

**Code block background:** `#FFFFFF` with a `border.subtle` border (Light); `#1F1F1F` (Dark).

Rules:

- Apply the same four colours to every language in the document.
- Do not add colours for numbers, types, functions, or signals.
- Bold keywords and italic comments are required whenever colour is used, so code stays readable in greyscale.
- All four colours meet 4.5:1 on their background (Light: keywords 8.59:1, comments 5.13:1, strings 7.84:1, text 15.17:1; Dark: 5.59:1, 4.94:1, 6.23:1, 10.26:1).
- These are the base keyword, comment, and string colours of VS Code's default Light and Dark themes, so the code looks familiar without reproducing a full editor theme.

If an organization or toolchain mandates a syntax theme, that theme takes precedence (Section 1.4); its colours **MUST** still meet 4.5:1 on its code background.

## 5.7 Timing Diagrams and Waveforms

| Element | Colour |
|---|---|
| Default signal lines | `text.primary` |
| Clock signals | `text.secondary` |
| Highlighted signal or transition | `accent.primary`, plus an annotation |
| Unknown (X) state | Cross-hatch pattern in `text.secondary`; red only if it represents an error |
| High-impedance (Z) state | Mid-level line in `text.secondary`, labelled `Z` |
| Error or protocol violation | Error foreground, plus an annotation |
| Grid and cycle markers | `border.subtle` |

Do not assign arbitrary colours to every signal.

## 5.8 Cover Pages, Chapter Openers, and Text over Images

- Cover pages and chapter openers **MAY** use `accent.strong` or `accent.secondary` as large fills, and **MAY** use the brand's exact colour for logos and large decorative areas.
- Text on a coloured fill **MUST** meet Section 3.2 against that fill.
- Text over a photograph **MUST** sit on a solid or near-solid panel that meets Section 3.2, or the image must be darkened or lightened behind the text until the lowest-contrast point passes.
- Full-bleed colour **SHOULD NOT** be used on interior pages of documents intended for office printing.

## 5.9 Safety Messages in Manuals and Procedures

When a user manual, laboratory manual, or procedure contains hazards that could injure people, the semantic palette in Section 4.3 is **not** sufficient.

- Follow the applicable product-safety standard. In the US, ANSI Z535.6 covers safety messages in manuals; internationally, ISO 3864 safety colours and IEC/IEEE 82079-1 (information for use) apply.
- These standards define signal words and colours: **DANGER** (red), **WARNING** (orange), **CAUTION** (yellow), and **NOTICE** (blue) for property-damage or non-injury messages.
- A safety message **MUST** include the signal word, a hazard description, the consequence, and how to avoid the hazard.
- The document's ordinary `WARNING` callout (Section 5.3) **MUST NOT** be used for personal-injury hazards in a document that follows a safety standard. Where both are needed, rename the ordinary callout `CAUTION (non-safety)` or `IMPORTANT` to avoid confusion.

---

# 6. Adapting the Palette

## 6.1 Replacing the Accent Colour (Brand Adaptation)

The accent colour may be replaced with another colour when the document or organization requires it. The replacement **MUST** follow this procedure so that every token still meets Section 3.2.

**Inputs:** one brand colour (HEX). If no brand colour is given, use the default palette unchanged.

1. **Convert** the brand colour to OKLCH and record its hue *H*. Only the hue is carried into the tokens; lightness and chroma are set by the steps below.
2. **Check hue collisions.** Compare *H* with the semantic hues (Information ≈ 250°, Warning ≈ 67°, Error ≈ 26°, Positive ≈ 159°). If the hue distance to any semantic hue is less than 30°, record a collision.
   - With a collision, accent colours **MUST NOT** appear in contexts where that semantic meaning is possible (for example, a red accent **MUST NOT** appear in tables that also show errors).
   - Semantic colours keep their default values. Do not shift semantic hues to fit a brand.
3. **Derive `accent.primary` (Light):** keep *H*, set chroma to the cap below, then lower lightness until contrast is at least 3:1 against `bg.page`, `bg.subtle`, and `accent.subtle` (target 3.5:1 for margin). Reduce chroma further if the colour falls outside sRGB.
4. **Derive `accent.strong` (Light):** keep *H*, set chroma to the cap below, lower lightness until contrast is at least 7:1 against `bg.page` and at least 4.5:1 against `accent.subtle`.
5. **Derive `accent.subtle` (Light):** keep *H*, OKLCH lightness about 0.96–0.97, chroma at most 0.03.
6. **Derive `accent.secondary` (Light):** keep *H*, OKLCH lightness about 0.84–0.86, and confirm `text.primary` on it reaches at least 7:1.
7. **Re-tint the neutrals:** either set the neutrals to hue *H* with OKLCH chroma at most 0.012, or make them pure greys. Then recheck every pairing in Section 4.2.
8. **Derive the Dark theme:** `accent.primary` and `accent.strong` at increasing lightness until they reach at least 4.5:1 and at least 7:1 on `#121617`; `accent.subtle` and `accent.secondary` as dark, low-chroma versions of *H*.
9. **Use the exact brand colour** unaltered only for logos and large decorative areas where no text sits on it, unless it passes the relevant contrast requirement.
10. **Record** the results in the colour specification (Section 7.4).

If an organization supplies a complete, accessible palette, map it onto the tokens in Section 4.1 instead, and still perform steps 2 and 10.

**Chroma caps.** Saturated accents look loud on document pages, so derived tokens **MUST NOT** exceed these OKLCH chroma values, even when the brand colour is more saturated:

| Token | Maximum OKLCH chroma |
|---|---|
| `accent.primary` | 0.11 |
| `accent.strong` | 0.08 |
| `accent.secondary` | 0.06 |
| `accent.subtle` | 0.02 |

The default green tokens already meet these caps.

**Recommended accent hues when no brand colour is given.** Use the default green, or one of these restrained alternatives (all derived with the procedure and caps above, Light theme):

| Preset | Hue | `accent.primary` | `accent.strong` | `accent.secondary` | `accent.subtle` | Collision |
|---|---|---|---|---|---|---|
| Green (default) | 159° | `#3A8760` | `#1E4D35` | `#A9D5BD` | `#EAF5EE` | Positive |
| Teal | 200° | `#009096` | `#006367` | `#A8D8DB` | `#E5F8F9` | None |
| Steel blue | 245° | `#4086BD` | `#2D5C82` | `#B3D2ED` | `#EAF5FF` | Information |
| Slate (low chroma) | 255° | `#6983A5` | `#465A74` | `#B8D0EF` | `#ECF4FF` | Information |

Every preset reaches at least 3.52:1 for `accent.primary` on all light backgrounds and at least 7.02:1 for `accent.strong` on white.

**House style for hue choice.** Purple, violet, magenta, and pink hues (OKLCH ≈ 280°–350°), and yellow or orange hues (≈ 70°–110°), **SHOULD NOT** be chosen as the accent unless a brand requires them. Purples and pinks read as decorative rather than professional in most technical and business documents; yellows and oranges cannot reach 3:1 on white without turning brown. When a brand does require such a hue, apply the chroma caps, and **MAY** limit the brand hue to the cover page and logo while using a recommended preset for the body.

An organization with two brand colours **SHOULD** choose one as the accent hue. The second colour **MAY** be used only on cover pages, in logos, and as a chart category colour.

## 6.2 Colour Profiles by Document Category

| Category | Accent | Semantic colours | Charts | Assume printed in greyscale? |
|---|---|---|---|---|
| Books and textbooks | Rules, markers, diagrams | Callouts allowed | Okabe–Ito | Yes |
| Educational tutorials | Rules, learning-objective box bars, diagrams | Callouts allowed | Okabe–Ito | Yes |
| Technical specifications | Minimal; diagram highlights | Status and requirement tables | Okabe–Ito | Yes |
| Engineering documents | Minimal | Status tables, design-review results | Okabe–Ito | Yes |
| Research papers and theses | None, or the template's | Rarely | Okabe–Ito or sequential maps; greyscale-safe | Yes |
| User manuals | Navigation aids, step numbers | Callouts; safety messages per Section 5.9 | Okabe–Ito | Often |
| Laboratory manuals | Minimal | Safety messages per Section 5.9 | Okabe–Ito | Yes |
| Business reports and proposals | Brand accent on cover fills, rules, and charts | KPI status with labels | Brand accent for the highlighted series; Okabe–Ito for categories | Sometimes |
| Presentations exported to PDF | Brand accent | Status with labels | Okabe–Ito, at most 4 categories per slide | No; see Section 6.6 |
| Forms | Minimal | Validation messages only | Rare | Yes |
| Legal, financial, regulatory | None or minimal | Only where required | Neutral plus one highlight | Yes |
| Posters | Brand accent, larger fills | Rare | Okabe–Ito | No |

"Assume printed in greyscale" means the document **MUST** pass the greyscale check in Section 7.3.

## 6.3 Dark Theme

Dark mode is an optional presentation variant for digital reading environments.

It should not be forced on documents intended primarily for printing or conventional PDF distribution.

A PDF cannot switch theme by itself. A dark-theme PDF is a separate file. It **MUST** be produced from the same content as the light version, **MUST** be labelled as the dark variant (for example, in the file name and metadata), and **MUST NOT** be used as the print master.

Dark theme token values are listed in Sections 4.1, 4.3, 4.4, and 5.6.

Dark theme rules:

- Maintain sufficient text contrast.
- Avoid excessively bright backgrounds.
- Use restrained accent colours.
- Preserve clear table boundaries. Use `border.strong` where boundaries carry meaning; the dark `border.subtle` reaches only 1.54:1 on `bg.page`.
- Ensure code highlighting remains readable.
- Do not simply invert every image. Photographs and screenshots keep their original colours; line art with transparent backgrounds needs a dark-theme version or a light panel behind it.
- Ensure diagrams remain understandable.
- Preserve the same information hierarchy as the light theme.

Theme independence: a document should not require dark mode to communicate its information. Its structure and meaning must remain understandable in the standard light presentation.

## 6.4 Greyscale and Monochrome Output

Many documents are printed on black-and-white printers or photocopied.

- Every meaningful distinction **MUST** survive conversion to greyscale. Where two meaningful colours differ by less than 20 units of CIE L* (lightness), they **MUST** also differ by label, pattern, line style, marker, or icon.
- The four Light semantic foregrounds lie between L* 29 and L* 39 and are therefore not distinguishable by lightness. Their labels and icons carry the meaning in greyscale.
- Semantic backgrounds (L* 94–97) are close to white and may disappear in greyscale or low-quality printing; borders and labels **MUST** carry the meaning.
- A monochrome variant **MAY** replace all accent tokens with `text.primary` and all fills with `bg.subtle`, keeping every label, icon, and line style.

## 6.5 Print Colour

Apply print-specific requirements only when the document is intended for physical production.

- Digital documents commonly use RGB colour values. Print production may require CMYK or another printer-specific colour workflow. Do not assume that a universal RGB-to-CMYK conversion exists. Use the printer's required colour profile and proof the output where colour accuracy matters.
- **Text colour for offset printing:** black and dark-grey text **SHOULD** print on the black plate only (K-only), not as a four-colour mix, because small four-colour text blurs when the printing plates are slightly out of register. When converting, map `text.primary` and `text.secondary` to K-only greys unless the printer specifies otherwise. Rich black (K plus other inks) is for large fills only.
- **Light tints:** very light tints, such as `bg.subtle` and the semantic backgrounds, may print unevenly or disappear. Check them on a printed proof, and darken them for print if separation matters.
- **Ink limits:** dark backgrounds and rich blacks **MUST** respect the printer's total ink coverage limit.
- **Transparency:** avoid transparency and blend effects in files for press; if present, flatten them according to the printer's instructions.
- **Spot colours:** if the brand colour must match exactly, specify the printer's spot colour reference and still define the token values for screen use.

## 6.6 Projection and Presentations

Projectors reduce contrast and wash out light colours.

- Body text **SHOULD** reach at least 7:1.
- Tints with a contrast of less than about 1.2:1 against `bg.page` (including `bg.subtle`, `accent.subtle`, and the semantic backgrounds) **SHOULD NOT** be the only way to separate regions; add `border.strong`.
- Charts **SHOULD** use at most 4 colour-coded categories per slide, with thick lines (at least 2 pt) and direct labels.

---

# 7. Colour Validation

## 7.1 Contrast Check

1. List every foreground/background pair actually used in the document, including text in tables, figures, callouts, headers, footers, and covers.
2. Compute each ratio with the WCAG 2.x formula. Do not round.
3. Compare against Section 3.2 using the text size and weight actually used.
4. Fix every failure by changing the token pairing, never by adding an exception.

## 7.2 Colour-Vision Deficiency Check

Simulate protanopia, deuteranopia, and tritanopia (or their anomalous forms) on every page or figure that uses colour to carry meaning. Confirm that each meaningful distinction is still identifiable through labels, shapes, line styles, or lightness.

## 7.3 Greyscale Check

Convert representative pages to greyscale and confirm Section 6.4.

## 7.4 Colour Specification Record

Before generating a document, the AI or author **MUST** record:

```text
Theme(s):              Light | Light + Dark
Accent source:         Default | Brand colour #RRGGBB | Organization palette
Derived tokens:        accent.primary, accent.strong, accent.subtle, accent.secondary (Light/Dark values)
Hue collisions:        None | <semantic category> (hue distance n°) — restriction applied
Chart palette:         Okabe–Ito | Sequential: <map> | Diverging: <scheme>
Output media:          Screen | Office print | Offset print | Projection
Greyscale required:    Yes | No
Additional colours:    None | <colour, purpose, justification>
Deviations:            None | <rule, reason>
Contrast results:      All pairs pass | <pairs and ratios>
```

This record **SHOULD** be kept with the document source and **MAY** be omitted from the delivered document.

---

# Part III — Typography and Layout

# 8. Typography System

Typography must establish a clear hierarchy and support comfortable reading.

## 8.1 Font Selection

Use a small and consistent set of font families: normally no more than two text families plus one monospaced family and one mathematical font.

| Purpose | Suggested fonts | Openly licensed fallback |
|---|---|---|
| Main body | Aptos, Arial, Calibri, Source Sans 3 | Source Sans 3, Noto Sans |
| Headings | Aptos Display, Arial, Calibri, Source Sans 3 | Source Sans 3, Noto Sans |
| Long-form reading | Georgia or another suitable serif font | Source Serif 4, Noto Serif |
| Code and identifiers | Consolas, Cascadia Mono | Source Code Pro, JetBrains Mono, DejaVu Sans Mono |
| Mathematical notation | Cambria Math, STIX Two Math, Latin Modern Math | STIX Two Math, Latin Modern Math |

These are examples, not mandatory dependencies.

Aptos, Calibri, Cambria Math, and Consolas are licensed with Microsoft products and may not be installed or embeddable in every environment. When the output environment is unknown, use the openly licensed fallback.

Use fonts that are available in the intended environment. Embed fonts in exported documents where permitted and appropriate.

Provide suitable Unicode font fallbacks for multilingual content (Section 22).

## 8.2 Typography Hierarchy

The following sizes are starting recommendations for A4 or Letter documents.

| Element | Recommended size | Weight |
|---|---:|---|
| Cover title | 30–36 pt | Bold |
| Chapter title | 22–28 pt | Bold |
| Section heading | 16–20 pt | Semibold/Bold |
| Subsection heading | 13–15 pt | Semibold |
| Body text | 10.5–12 pt | Regular |
| Table content | 9–10.5 pt | Regular |
| Diagram labels | 9–11 pt | Regular/Medium |
| Captions | 8.5–9.5 pt | Regular |
| Footnotes | 8–9 pt | Regular |
| Code | 9–10.5 pt | Regular/Medium |

Ranges no longer overlap between adjacent heading levels. Within one document, each heading level **MUST** be at least 2 pt larger than the next lower level, or differ clearly in weight.

Adjust these values according to page size, audience, reading distance, and document density.

Do not reduce body text excessively to fit more information on a page. Text **SHOULD NOT** be smaller than 8 pt in any printed document.

## 8.3 Line Spacing

| Element | Line spacing (multiple of font size) |
|---|---|
| Body text | 1.25–1.5 |
| Headings | 1.1–1.25 |
| Table content | 1.15–1.3 |
| Code | 1.2–1.4 |

Paragraph spacing **SHOULD** be 0.5–1 times the body line height. Use either paragraph spacing or first-line indents, not both.

## 8.4 Heading Hierarchy

Maintain a clear distinction between heading levels.

**Heading 1 — Major Chapter or Section**

- Prominent and clearly distinguishable.
- Bold.
- Consistent spacing before and after.
- Optional restrained accent (Section 5.1).

**Heading 2 — Main Section**

- Medium-large.
- Semibold or bold.
- Consistent with other headings at the same level.

**Heading 3 — Subsection**

- Smaller than Heading 2.
- Semibold.
- Minimal decorative treatment.

**Heading 4 — Minor Subsection**

- Similar to body text but bold.
- Use only when additional hierarchy is necessary.

Avoid excessive heading levels. Do not use more than four levels; restructure the content instead.

Heading space before **SHOULD** be larger than space after, so each heading visibly belongs to the content below it.

## 8.5 Body Text

- Use a readable font size.
- Maintain comfortable line spacing (Section 8.3).
- Avoid excessively long paragraphs.
- Divide complex explanations into logical paragraphs.
- Use lists when they improve comprehension.
- Avoid unnecessary bold, italic, and underlined text. Reserve underlining for links.
- Maintain consistent paragraph spacing.

## 8.6 Technical Identifiers

Use a monospaced font for:

- Source code.
- Variables.
- Signal names.
- Commands.
- File paths.
- Register names.
- Configuration parameters.
- Function names.
- Short technical expressions.

Keep technical identifiers visually distinct from normal prose. Inline code **MAY** use a `bg.subtle` background; its text **MUST** remain `text.primary`.

---

# 9. Page Layout and Spacing

## 9.1 Page Size

Select the page size according to the document's purpose and intended distribution.

Common choices:

- A4 for general international documentation.
- Letter for documents primarily intended for US audiences.
- A5 for compact manuals and books.
- 16:9 landscape for presentations exported to PDF.
- Custom sizes for posters, landscape documents, and specialized publications.

Do not assume that every document must use the same page size.

## 9.2 Margins

For standard A4 or Letter documents, use approximately 18–25 mm margins as a starting point.

Adjust margins when:

- The document requires binding.
- The page contains wide tables.
- The document uses multiple columns.
- The intended format requires a different layout.

For bound publications, provide an appropriate inner gutter (Section 23.3).

## 9.3 Spacing

Maintain consistent spacing between:

- Chapters.
- Sections.
- Paragraphs.
- Lists.
- Tables.
- Figures.
- Captions.
- Equations.
- Callout panels.

Whitespace should separate related groups of information. Use a base spacing unit (for example, 4 pt or 6 pt) and make all vertical spacing a multiple of it.

Avoid both overcrowded pages and unnecessary empty space.

## 9.4 Alignment

- Use consistent text alignment.
- Left-align standard English body text by default. Justified text **MAY** be used when a publication template requires it or when hyphenation is enabled and checked for wide word gaps.
- Align headings consistently.
- Align numerical table values appropriately (right-aligned or decimal-aligned).
- Keep captions close to their corresponding figures.
- Use a consistent grid where practical.

Adapt alignment for right-to-left languages and other writing systems.

## 9.5 Page Breaks

- Avoid separating headings from their following content. A heading **MUST** be followed by at least two lines of its content on the same page.
- Keep captions with their figures.
- Avoid splitting short tables unnecessarily.
- Prevent awkward paragraph breaks.
- Avoid single orphaned or widowed lines at page boundaries.
- Use chapter-opening pages when appropriate.

## 9.6 Line Length

For single-column reading, approximately 45–75 characters per line is a useful starting range.

If a page becomes too wide for comfortable reading, consider:

- Increasing margins.
- Using multiple columns.
- Reducing unnecessary page width.
- Restructuring the content.

Do not apply fixed column rules without considering the document's purpose.

---

# 10. Cover Page and Front Matter

The cover should clearly communicate the document's identity and purpose.

## 10.1 Cover Information

Depending on the document, include:

- Document title.
- Subtitle.
- Author or organization.
- Version.
- Publication date.
- Document category.
- Project or product identification.
- Confidentiality classification, where required.
- Short description, where appropriate.

## 10.2 Cover Appearance

Use:

- Clear title hierarchy.
- Appropriate whitespace.
- A restrained colour palette (Section 5.8).
- Consistent alignment.
- Minimal decorative elements.

Avoid unnecessary icons, competing colours, and large decorative elements without purpose.

## 10.3 Front Matter

Include relevant introductory material, such as:

- Document control.
- Revision history.
- Table of contents.
- List of figures.
- List of tables.
- Abbreviations.
- Glossary.
- Executive summary.
- Preface.

Do not force every document to contain every item.

---

# Part IV — Components

# 11. Tables and Structured Data

Tables must make information easier to compare, locate, and understand. Colour treatment is defined in Section 5.2.

## 11.1 General Table Style

Use:

- Neutral backgrounds.
- Dark readable text.
- Subtle borders.
- Clear headers.
- Consistent row spacing.
- Limited highlighting.

Avoid heavy borders and excessive cell shading. Prefer horizontal rules only; add vertical rules only when columns would otherwise be confused.

## 11.2 Table Headers

- Use bold text.
- Use a subtle background (`bg.subtle`).
- Keep headings concise.
- Include units where appropriate.
- Maintain consistent alignment.
- Repeat headers across pages when necessary and supported.

## 11.3 Table Body

- Keep content readable.
- Align numbers consistently.
- Avoid unnecessarily narrow columns.
- Use alternating row backgrounds only when they improve scanning, typically for tables wider than five columns or longer than ten rows.
- Avoid excessive line wrapping.
- Keep related information together.

## 11.4 Status and Highlighting

When a table contains status information, use explicit text labels from the vocabulary in Section 4.3.

| Status | Treatment |
|---|---|
| PASS | Positive foreground label; Positive background optional |
| FAIL | Error foreground label; Error background optional |
| WARNING | Warning foreground label; Warning background optional |
| INFO | Information foreground label |
| N/A | `text.secondary` label, no background |

Use pale semantic backgrounds only where they improve understanding.

Do not colour entire tables when only a few values need emphasis.

## 11.5 Complex Tables

For complex tables:

- Use descriptive column headings.
- Group related columns.
- Keep units explicit.
- Use footnotes for qualifications.
- Break large tables into logical sections when appropriate.
- Avoid repeating long explanations in multiple cells.

---

# 12. Diagrams and Illustrations

Diagrams should communicate structures, relationships, and processes more effectively than text alone. Colour treatment is defined in Section 5.4.

## 12.1 General Diagram Style

Use:

- Clean backgrounds.
- Readable labels (at least 8 pt at final printed size).
- Consistent shapes.
- Subtle borders.
- Clear connections.
- Limited accent colours.
- Appropriate spacing.

Avoid unnecessary colours and decorative effects such as shadows, bevels, and 3D effects.

## 12.2 Shape Conventions

| Shape | Typical Purpose |
|---|---|
| Rectangle | Functional block or processing unit |
| Rounded rectangle | Component or logical group |
| Diamond | Decision or condition |
| Ellipse | Start/end or state marker |
| Cylinder | Storage or database |
| Arrow | Directional flow |
| Dashed boundary | Optional, external, or conceptual grouping |

Shape meanings must remain consistent within a document.

## 12.3 Connections

Use different line styles where they communicate different relationships.

- Solid lines for normal connections.
- Dashed lines for conditional or optional connections.
- Dotted lines for conceptual or indirect relationships.
- Arrows for direction.
- Labels for important connections.

Do not rely exclusively on colour to distinguish connections. Connector lines **SHOULD** be at least 0.75 pt wide at final size.

## 12.4 Block and Architecture Diagrams

- Group related components.
- Use meaningful block names.
- Show important interfaces.
- Label data and control connections.
- Avoid unnecessary crossing lines.
- Maintain consistent block dimensions where practical.
- Separate external and internal components.
- Show important dependencies.

A reader should understand the main architecture without having to read the complete detailed description.

## 12.5 Flowcharts

- Use consistent start and end symbols.
- Use decision diamonds for conditions.
- Label decision paths.
- Maintain a consistent flow direction where possible.
- Avoid unnecessarily complex crossing connections.

## 12.6 Captions

Every important diagram should have a descriptive caption.

A caption should explain what the diagram represents, not merely repeat its title.

Use consistent figure numbering when appropriate.

---

# 13. Timing Diagrams and Waveforms

Timing diagrams require special attention because they contain dense information. Colour treatment is defined in Section 5.7.

## 13.1 General Style

Use:

- Clear backgrounds.
- Readable signal labels.
- Consistent signal spacing.
- Clearly visible transitions.
- Readable time and cycle labels.
- Consistent line widths.

## 13.2 Signal Appearance

Use neutral colours as the default.

Use accent colours selectively to highlight important signals or transitions.

Use semantic colours only when the waveform communicates a meaningful status, error, or warning.

Do not assign arbitrary colours to every signal.

## 13.3 Signal Labels

- Keep labels close to their corresponding waveforms.
- Use consistent naming.
- Avoid overlapping labels.
- Use monospaced fonts where appropriate.
- Include signal widths where useful.
- Clearly identify active-high and active-low signals.

## 13.4 Time Axis

The time axis should include:

- Cycle numbers or time values.
- Units where appropriate.
- Consistent spacing.
- Clearly identified transition positions.

Avoid ambiguous timing references.

## 13.5 Multi-Bit Signals

- Display values clearly.
- Use consistent hexadecimal or binary notation.
- Identify unknown and high-impedance states explicitly.
- Keep labels away from transitions.
- Provide sufficient vertical space.

## 13.6 Annotations

Annotations may explain:

- Request and response events.
- Handshake completion.
- State transitions.
- Reset behavior.
- Pipeline stages.
- Latency.
- Recovery events.
- Important protocol conditions.

Do not allow annotations to obscure the waveform.

---

# 14. Code Blocks and Technical Examples

Code examples must be visually separated from normal prose. Colour treatment is defined in Section 5.6.

## 14.1 Code Block Appearance

Use:

- Monospaced typography.
- A subtle neutral background (`bg.subtle`).
- Readable text.
- Consistent indentation.
- Appropriate line spacing.
- A subtle border where necessary.

## 14.2 Syntax Highlighting

Syntax highlighting may be used when supported.

Keep it restrained and ensure that:

- Text remains readable.
- Highlighting is consistent.
- Colours have sufficient contrast.
- Greyscale printing does not destroy meaning.

Use only the palette in Section 5.6.

## 14.3 Inline Code

Use inline code formatting for the identifiers listed in Section 8.6.

## 14.4 Code Explanations

When presenting code:

1. Explain its purpose.
2. Present the code.
3. Explain important sections.
4. Identify assumptions and limitations.
5. Provide expected results where relevant.

Do not place long explanations inside the code block.

---

# 15. Mathematical Equations and Expressions

Equations must be presented consistently and clearly.

## 15.1 General Style

- Use a suitable mathematical font.
- Maintain consistent notation.
- Separate important equations from body text.
- Use appropriate alignment.
- Keep explanatory text close to the equation.
- Number equations when useful.

## 15.2 Multi-Line Equations

Align related operators and expressions where appropriate.

Maintain sufficient spacing between equation lines.

## 15.3 Highlighting

Use colour only when highlighting genuinely improves understanding. When a term is highlighted, do not colour the math text; place it on a `bg.highlight` background or mark it with an underbrace and a label, so the highlight survives greyscale.

Avoid unnecessary coloured backgrounds.

## 15.4 Definitions

Define symbols and variables close to their first use.

Use consistent notation throughout the document.

---

# 16. Notes, Warnings, and Callouts

Callouts should make important information easier to locate. Colour treatment is defined in Section 5.3; safety messages are defined in Section 5.9.

## 16.1 Callout Types

| Type | Purpose |
|---|---|
| NOTE | Additional information |
| TIP | Helpful recommendation |
| IMPORTANT | Information that must not be overlooked |
| WARNING / CAUTION | Potential risk or incorrect usage (not personal-injury hazards) |
| ERROR | Failure or incorrect result |
| EXAMPLE | Practical illustration |
| RESULT | Outcome or conclusion |
| ASSUMPTION | Accepted condition |
| REQUIREMENT | Explicit requirement or constraint |

## 16.2 Appearance

Default appearance:

- Neutral or light background.
- Dark readable text.
- Subtle border.
- Optional accent marker.
- Consistent internal spacing.

Semantic colours may be used when they provide meaningful information, as mapped in Section 5.3.

## 16.3 Usage Rules

- Keep callouts concise.
- Use descriptive labels.
- Avoid unnecessary icons. Icons that carry meaning (Section 5.3) are not unnecessary.
- Do not turn ordinary paragraphs into callout boxes.
- Do not use warning styling for non-critical information.

---

# 17. Figures, Images, and Screenshots

Images must support the explanation.

## 17.1 Image Selection

Use images when they improve understanding.

Examples include:

- Product illustrations.
- Architecture diagrams.
- Experimental setups.
- Software screenshots.
- Educational illustrations.
- Process visualizations.

## 17.2 Image Presentation

- Preserve aspect ratio.
- Avoid unnecessary cropping.
- Use adequate resolution: about 300 ppi at final size for print photographs, and vector formats (SVG, PDF, EPS) for diagrams and charts wherever possible.
- Maintain consistent alignment.
- Avoid heavy borders.
- Keep images close to relevant explanations.

## 17.3 Screenshots

- Crop irrelevant interface areas.
- Highlight important details with restrained annotations. Annotation marks (boxes, arrows) **MUST** reach 3:1 against the screenshot area behind them; use `accent.strong` or the Error foreground with a white halo if needed.
- Ensure text remains readable.
- Explain what the reader should observe.
- Do not obscure important information.

## 17.4 Captions and Alternative Text

Provide descriptive captions for important images. Alternative text requirements are defined in Section 24.6.

---

# 18. Charts and Data Visualizations

Charts must communicate data accurately. Colour treatment is defined in Section 5.5.

## 18.1 General Requirements

- Use a descriptive title.
- Label axes.
- Include units.
- Use readable legends, or direct labels where possible.
- Avoid unnecessary gridlines.
- Avoid misleading scales. Bar charts **MUST** start at zero.
- Avoid unnecessary 3D effects.
- Choose the simplest suitable chart type.

## 18.2 Chart Selection

| Data type | Suitable visualization |
|---|---|
| Comparison | Bar chart |
| Change over time | Line chart |
| Distribution | Histogram or box plot |
| Proportion | Stacked bar chart; pie chart only for 2–4 parts of one whole |
| Relationship | Scatter plot |
| Magnitude across two dimensions | Heat map with a sequential map |
| Process stages | Flow diagram |

## 18.3 Colour and Patterns

- Use neutral colours by default.
- Highlight important data selectively.
- Use distinguishable patterns or line styles where appropriate.
- Ensure the chart remains understandable without colour.
- Avoid excessive series colours.

The palettes and limits are defined in Section 5.5.

---

# 19. Headers, Footers, and Page Numbering

Headers and footers should support navigation without consuming excessive space.

## 19.1 Headers

Depending on document type, headers may include:

- Document title.
- Chapter or section name.
- Organization name.
- Project identifier.

Avoid unnecessary repetition. Header and footer text uses `text.secondary` and **MUST** still meet 4.5:1.

## 19.2 Footers

Footers may include:

- Page number.
- Document version.
- Publication information.
- Confidentiality classification.
- Short document identifier.

Include only relevant information.

## 19.3 Page Numbering

Use consistent page numbering.

Longer documents may use different numbering styles for front matter and main content where appropriate.

## 19.4 Watermarks and Status Stamps

Watermarks such as `DRAFT` or `CONFIDENTIAL` **MUST** be placed behind content, **MUST NOT** reduce body-text contrast below Section 3.2, and **SHOULD** use `border.subtle`. The status they express **MUST** also appear as text in the header or footer, because a pale watermark may not print or may be ignored by assistive technology.

---

# Part V — Adaptation

# 20. Document-Specific Adaptation

The visual system is universal, but the layout must adapt to the document category. Colour profiles per category are defined in Section 6.2.

## 20.1 Books and Textbooks

Prioritize:

- Comfortable long-form reading.
- Clear chapter hierarchy.
- Chapter-opening pages where appropriate.
- Explanatory illustrations.
- Examples and exercises.
- Readable equations.
- Consistent figure and table numbering.

Avoid excessive colour in body content.

## 20.2 Technical Specifications

Prioritize:

- Architecture and functional descriptions.
- Interface tables.
- Block diagrams.
- Timing diagrams.
- Signal definitions.
- Operational behavior.
- Requirements and constraints.
- Reset and initialization behavior.
- Corner cases and examples.

Keep technical identifiers distinct from normal prose.

## 20.3 Engineering Documents

Prioritize:

- System architecture.
- Functional decomposition.
- Design decisions.
- Interface definitions.
- Data and control flow.
- Operational behavior.
- Assumptions and limitations.

Use diagrams where they communicate structure more clearly than text.

## 20.4 Research Papers and Reports

Prioritize:

- Abstract.
- Introduction.
- Methodology.
- Results.
- Discussion.
- Figures and tables.
- Equations.
- References.

Follow the target publication's formatting requirements when specified (Section 1.4). Journal and conference templates override this document's typography, layout, and accent rules; the contrast, colour-independence, and chart-palette rules still apply to figures.

## 20.5 User Manuals and Guides

Prioritize:

- Prerequisites.
- Step-by-step instructions.
- Screenshots where useful.
- Warnings, and safety messages per Section 5.9 where hazards exist.
- Expected results.
- Troubleshooting information.

Use numbered steps for sequential tasks.

## 20.6 Laboratory Manuals

Prioritize:

- Objectives.
- Equipment and prerequisites.
- Safety information, formatted per Section 5.9.
- Procedures.
- Expected observations.
- Experimental results.
- Analysis questions.

Clearly distinguish instructions, warnings, and expected results.

## 20.7 Business Documents

Prioritize:

- Executive summary.
- Objectives.
- Key information.
- Supporting evidence.
- Recommendations.
- Action items.
- Professional tables and charts.

Maintain a restrained and professional appearance. Apply brand colours through the procedure in Section 6.1.

## 20.8 Educational Tutorials

Prioritize:

- Learning objectives.
- Concept explanations.
- Step-by-step examples.
- Diagrams.
- Exercises.
- Summary sections.
- Practical applications.

Visual highlights should support learning rather than decorate every section.

## 20.9 Presentations Exported to PDF

Prioritize:

- One main message per slide.
- Large text: body at least 18 pt, titles at least 28 pt.
- Projection-safe contrast (Section 6.6).
- Charts simplified to the point being made.
- Slide numbers.

Do not paste dense document tables onto slides; summarize them.

## 20.10 Forms

Prioritize:

- Clear field labels placed consistently (above or to the left of fields).
- Field boundaries in `border.strong` (3:1 or more).
- Required-field markers that use a symbol and text, not colour alone.
- Instructions placed before the fields they apply to.
- Enough writing space for handwritten entries in printable forms.

For fillable PDFs, every field **MUST** have an accessible name (tooltip) that matches its visible label.

## 20.11 Legal, Financial, and Regulatory Documents

Prioritize:

- Neutral appearance with minimal accent.
- Numbered clauses and cross-references.
- Defined terms set consistently (for example, bold at definition).
- Tables of figures with explicit units and currencies.
- Version, date, and confidentiality on every page.

Do not use colour to indicate legal meaning (for example, obligations versus permissions) without an equivalent text marker.

## 20.12 Posters and Single-Page Material

Prioritize:

- A reading order that is clear from a distance.
- Text sized for the viewing distance (for an A0 poster, body text is commonly 24 pt or larger).
- Fewer, larger figures.
- Accent fills allowed in larger areas, still within Section 3.2.

---

# 21. Responsive Layout and Different Formats

Documents may be viewed on different page sizes and digital devices.

The layout should adapt without blindly scaling every element by a fixed multiplier.

## 21.1 Format Adaptation

| Format | Layout Considerations |
|---|---|
| A5 or compact manual | Simplified layout, careful font sizing, compact tables |
| A4 or Letter | Standard single- or multi-column layout |
| Landscape document | Wider tables, diagrams, and technical figures |
| 16:9 slides | Large text, few elements per slide, projection-safe colour |
| Digital reading format | Flexible layout and navigation |
| Large poster | Larger text, clear grouping, viewing-distance considerations |

## 21.2 Scaling Rules

When changing the document format:

- Reconsider margins.
- Reassess font sizes.
- Reflow paragraphs.
- Adjust table widths.
- Resize diagrams proportionally, and recheck that labels stay at least 8 pt and lines at least 0.75 pt.
- Reposition figures.
- Maintain adequate whitespace.

Do not simply enlarge or shrink every element by the same percentage.

## 21.3 Content Reflow

Where the output format supports responsive layouts:

- Allow content to reflow.
- Avoid fixed-width elements that cause overflow.
- Keep tables usable on smaller screens.
- Maintain readable line lengths.
- Preserve the logical reading order.

---

# 22. Localization and Multilingual Typography

Documents containing multiple languages must preserve correct reading direction, typography, and character rendering.

## 22.1 Right-to-Left Languages

For Arabic, Hebrew, Urdu, and other right-to-left writing systems:

- Set the correct text direction.
- Align body text appropriately.
- Adapt list markers.
- Adapt table column ordering where necessary.
- Position callout accents consistently (callout bars move to the right edge).
- Preserve correct punctuation and mixed-language text behavior.
- Use a font designed for the script (for example, a Nastaliq font for Urdu where that style is expected, or Noto Sans Arabic / Noto Naskh Arabic).

Do not blindly mirror every diagram.

Only reverse diagram flow when the intended meaning and reading convention require it.

## 22.2 Left-to-Right Languages

For left-to-right writing systems, maintain the normal reading direction and alignment.

## 22.3 CJK Languages

For Chinese, Japanese, and Korean:

- Use suitable Unicode fonts (for example, Noto Sans CJK / Source Han Sans).
- Provide appropriate font fallbacks.
- Check character rendering.
- Adjust line spacing where needed.
- Avoid splitting characters or words incorrectly.
- Consider vertical typography only when the publication format requires it.

## 22.4 Text Expansion

Translated text may become longer or shorter than the original.

Therefore:

- Avoid unnecessarily fixed-height text containers.
- Allow table rows to expand.
- Allow headings to wrap.
- Provide sufficient space for translated labels.
- Recheck page breaks after localization.

Do not assume a single fixed text-expansion percentage for every language.

## 22.5 Mixed-Language Documents

Check:

- Direction changes.
- Numbers.
- Punctuation.
- Technical identifiers.
- File paths.
- Equations.
- Embedded English terminology.

Ensure mixed-direction text remains readable and correctly ordered.

## 22.6 Colour and Culture

Colour associations differ between cultures. Semantic meaning **MUST** therefore always be carried by labels (Section 4.3), so that the document does not depend on any one culture's reading of a colour.

---

# 23. Physical Printing and Publishing

Apply print-specific requirements only when the document is intended for physical production. Print colour is defined in Section 6.5.

## 23.1 Print Layout

Consider:

- Paper size.
- Binding method.
- Inner and outer margins.
- Page numbering.
- Image resolution.
- Ink coverage.
- Colour reproduction.
- Print-safe text sizes.

## 23.2 Bleed and Trim

For full-bleed printed material:

- Provide bleed according to the printer's specifications.
- Keep important text and visual elements inside the safe area.
- Use appropriate trim marks when required.

A 3 mm bleed is a common starting point, but the printer's production requirements take priority.

## 23.3 Binding Gutter

Bound books and manuals may require additional inner margin.

The gutter must be selected according to:

- Page count.
- Paper thickness.
- Binding method.
- Printer specifications.

Do not use one fixed gutter for every publication.

## 23.4 Print Validation

Check:

- Text size.
- Image resolution.
- Margins.
- Binding clearance.
- Greyscale readability (Section 7.3).
- Colour reproduction.
- K-only black and grey text (Section 6.5).
- Light tints on the printed proof.
- Page order.
- Trim and bleed.

---

# Part VI — Accessibility, Export, and AI Rules

# 24. Digital Accessibility and PDF Structure

Digital documents should be designed to support assistive technologies and accessible navigation.

## 24.1 Standards Baseline

- **Visual accessibility** (contrast, use of colour): WCAG 2.2 Level AA, as defined in Section 3.2.
- **PDF structure**: tagged PDF following PDF/UA-1 (ISO 14289-1) or, for PDF 2.0 files, PDF/UA-2 (ISO 14289-2:2024), where the export technology supports it. PDF/UA does not cover colour or contrast; those come from WCAG.
- **Jurisdiction**: where a law applies (for example, EN 301 549 under the European Accessibility Act in the EU, or Section 508 in US federal procurement), that law's referenced standard takes precedence (Section 1.4).

WCAG is primarily a digital accessibility standard. Its contrast and use-of-colour principles are adopted here as practical guidance for digital documents and PDFs. They do not, by themselves, establish formal accessibility compliance for every document or print format.

## 24.2 Colour Independence

Do not communicate important information through colour alone.

Use:

- Text labels.
- Symbols.
- Shapes.
- Line styles.
- Patterns.
- Explicit status descriptions.

## 24.3 Document Structure Tags

For accessible PDF output, use a logical structure hierarchy where the export technology supports it.

Examples include:

- Headings.
- Paragraphs.
- Lists.
- Tables.
- Figures.
- Links.
- Formulas.

Do not rely exclusively on visual formatting or absolute positioning. Heading tags **MUST** match the visual heading levels and **MUST NOT** skip levels.

## 24.4 Accessible Tables

Where supported:

- Identify table header cells.
- Associate headers with their corresponding data cells.
- Maintain a logical reading order.
- Avoid unnecessarily complex merged cells.

## 24.5 Decorative Elements

Decorative elements that do not convey information should be excluded from the accessibility reading order where supported (tagged as artifacts). This includes decorative accent fills, rules, and background tints.

## 24.6 Alternative Text

Provide alternative text for meaningful visual assets. Alternative text should communicate the image's essential information, not describe its appearance.

For complex diagrams, charts, and waveforms, include a more detailed explanation or structured description in the main document.

## 24.7 Document Metadata

Where supported, include:

- Document title (and set the PDF viewer to display the title rather than the file name).
- Author.
- Subject.
- Primary language.
- Relevant keywords.

## 24.8 Navigation

For longer structured documents, provide appropriate navigation features:

- Table of contents.
- Internal links.
- Hierarchical PDF bookmarks.
- Figure and table references.

The need for an interactive table of contents should depend on document length and structure, not a universal page-count threshold.

---

# 25. PDF Export and Final Validation

Before delivering a document, inspect the exported result.

## 25.1 Export Requirements

Where supported and appropriate:

- Embed fonts.
- Preserve hyperlinks.
- Include document metadata.
- Preserve heading structure and tags.
- Maintain image quality.
- Ensure equations render correctly.
- Preserve tables.
- Include navigation bookmarks.
- Embed the sRGB output intent for screen documents, or the printer's output intent for press (for example, a PDF/X profile).
- Use PDF/A when long-term archiving is required.

## 25.2 Layout Validation

Check:

- Page margins.
- Heading placement.
- Page breaks.
- Figure positioning.
- Table alignment.
- Paragraph spacing.
- Headers and footers.
- Unexpected blank pages.
- Clipped or overlapping content.

## 25.3 Visual Validation

Inspect the complete document, not just the first page.

Review representative pages containing:

- Long paragraphs.
- Large tables.
- Complex diagrams.
- Equations.
- Code blocks.
- Multiple figures.
- Chapter openings.
- Footnotes and references.

## 25.4 Colour Validation

Perform the checks in Section 7 on the exported PDF, not only on the source.

## 25.5 Technical Validation

For technical documents, verify that:

- Identifiers are correct.
- Diagrams agree with descriptions.
- Tables contain the intended information.
- Equations are accurate.
- No technical content has been omitted during formatting.

---

# 26. AI Document Generation Rules

This section defines how an AI tool should apply the document design system.

## 26.1 Before Generation

Before creating a document, the AI must:

1. Read this design system.
2. Identify the document category (Section 1.1).
3. Understand the intended audience.
4. Determine the output format and output media (screen, office print, offset print, projection).
5. Identify any higher-precedence requirements (Section 1.4): templates, brand guidelines, legal or safety standards.
6. Identify the required document structure.
7. Identify the visual components needed.
8. Select an appropriate layout and theme.
9. Produce the colour specification record (Section 7.4), applying Section 6.1 if a brand colour is given and Section 6.2 for the category.

If important requirements are missing, the AI should identify them rather than inventing project-specific details. When the missing item is a colour decision, the AI **MUST** use the defaults in Section 4 and state that it did so.

Any deviation from a SHOULD rule **MUST** be listed under "Deviations" in the colour specification record, with its reason.

## 26.2 During Generation

The AI must:

- Apply consistent typography.
- Use only the defined colour tokens, the semantic colours, and the chart palettes in Section 5.5.
- Maintain logical heading hierarchy.
- Use appropriate page spacing.
- Select suitable visual components.
- Keep tables readable.
- Keep diagrams consistent.
- Preserve technical accuracy.
- Maintain accessibility.
- Adapt the layout to the document category.

## 26.3 Colour Restrictions

The AI must:

- Use neutral colours as the default.
- Use accent colours selectively, within the limits in Section 4.5.
- Use semantic colours only when justified, always with a label.
- Not invent colour values. Every colour used **MUST** trace to a token, a semantic colour, a chart palette entry, or a justified entry in the colour specification.
- Avoid unnecessary coloured backgrounds.
- Avoid excessive gradients and decorative effects.
- Compute contrast for every pair used (Section 7.1), rather than assuming the palette passes.

## 26.4 Layout Restrictions

The AI must avoid:

- Unnecessary decorative cards.
- Excessive borders.
- Excessive background fills.
- Unnecessary icons.
- Overcrowded pages.
- Inconsistent heading styles.
- Excessive bold formatting.
- Unreadably small text (below the minimums in Sections 8.2 and 12.1).
- Fixed layouts that break when content changes.

## 26.5 Content Accuracy

For technical, scientific, and instructional documents:

- Do not invent requirements.
- Do not invent interfaces or behaviors.
- Do not change technical terminology without justification.
- Do not omit important conditions to simplify diagrams.
- Clearly identify assumptions.
- Distinguish confirmed information from unspecified information.
- Ensure visualizations agree with the accompanying explanation.

Visual quality must never come at the expense of content accuracy.

## 26.6 Adapt Rather Than Copy

The system defines visual principles, not a fixed document template.

The AI must adapt its implementation to the document's purpose.

For example:

- A book should support long-form reading.
- A technical specification should prioritize clarity and precise information.
- A research paper should follow publication requirements.
- A laboratory manual should prioritize procedures and safety.
- A user guide should prioritize navigation and actionable instructions.

Maintain visual consistency without forcing identical layouts.

## 26.7 Final Review

Before delivery, the AI must:

1. Inspect the document structure.
2. Check typography and colour consistency.
3. Run the colour validation in Section 7 (contrast, colour-vision deficiency, greyscale).
4. Review tables and diagrams.
5. Check page breaks and alignment.
6. Verify content accuracy.
7. Review accessibility requirements.
8. Inspect the exported document.
9. Correct any significant formatting problems.

---

# 27. Reusable AI Prompt

The following instructions can be reused when asking an AI tool to create a document.

## Document Generation Instructions

Before generating the document, read and follow the rules in:

`Universal Document Design System.md`

(If the file is renamed, update this reference.)

Use this document as the universal visual and formatting standard.

First, identify the document category, audience, output format, output media, and required content structure. Identify any template, brand guideline, or legal or safety standard that takes precedence.

Then adapt the design system to the document's purpose, and record the colour specification (Section 7.4) before building the document.

Requirements:

1. Prioritize readability and information hierarchy.
2. Use only the colour tokens, semantic colours, and chart palettes defined in the design system. If a brand colour is supplied, derive the accent tokens with Section 6.1.
3. Use neutral backgrounds and readable text that meets the contrast thresholds in Section 3.2.
4. Never use colour as the only carrier of meaning.
5. Apply a consistent typography hierarchy.
6. Maintain appropriate page margins and spacing.
7. Use suitable tables, diagrams, figures, equations, and code blocks.
8. Adapt the layout and colour profile to the document category (Sections 6.2 and 20).
9. Preserve technical and factual accuracy.
10. Do not invent missing information.
11. Do not add unnecessary decorative elements.
12. Apply accessibility requirements where supported.
13. Consider print, greyscale, projection, digital, and localization requirements when relevant.

Before delivery, inspect the complete document for visual consistency, readability, colour validation results, formatting problems, content accuracy, and export quality.

The final document should look like a professionally prepared publication rather than a collection of independently styled pages.

---

# 28. Final Quality Checklist

Use this checklist before delivering a document.

## Colour System

- [ ] A colour specification record exists (Section 7.4).
- [ ] Every colour used traces to a token, semantic colour, or chart palette entry.
- [ ] Neutral colours dominate where appropriate (Section 4.5).
- [ ] Accent colours are used selectively; one accent hue only.
- [ ] No text (headings, labels, links) uses an accent colour.
- [ ] Accent chroma is within the caps in Section 6.1.
- [ ] Code uses no more than the four code colours in Section 5.6 (or none), with bold keywords and italic comments.
- [ ] Semantic colours are used only when justified, each with a label.
- [ ] Accent colours do not appear in status contexts.
- [ ] Brand colours, if any, were derived with Section 6.1 and hue collisions recorded.
- [ ] No unnecessary decorative colours, gradients, or transparency have been introduced.

## Contrast and Colour Independence

- [ ] Every text pair meets 4.5:1 (or 3:1 for large text), computed without rounding.
- [ ] Every meaningful graphic meets 3:1 against adjacent colours.
- [ ] Links are underlined.
- [ ] Important information is not communicated through colour alone.
- [ ] Greyscale output preserves meaning.
- [ ] Colour-vision deficiency simulation preserves meaning.
- [ ] Dark-theme variant (if produced) uses dark-theme semantic values.

## Typography

- [ ] Font families are consistent.
- [ ] Heading levels are distinguishable by size or weight without colour.
- [ ] Body text is readable.
- [ ] Captions and labels are appropriately sized.
- [ ] Code uses monospaced typography where appropriate.
- [ ] Fonts render correctly in the final output.

## Layout

- [ ] Page margins are consistent.
- [ ] Spacing is balanced.
- [ ] Headings are not isolated at page boundaries.
- [ ] Figures and tables are positioned appropriately.
- [ ] No content is clipped or overlapping.
- [ ] Page breaks are appropriate.

## Tables and Diagrams

- [ ] Tables are readable.
- [ ] Decorative borders are subtle; meaningful boundaries use `border.strong`.
- [ ] Diagrams use consistent shapes and connections.
- [ ] Labels are clear.
- [ ] Captions explain the visual content.
- [ ] Chart series differ by marker or line style as well as colour.

## Accessibility

- [ ] Document structure is logical and tagged where supported.
- [ ] Meaningful figures have alternative text where supported.
- [ ] Tables have appropriate header information where supported.
- [ ] Decorative elements are excluded from the reading order where supported.
- [ ] Document language and title metadata are set.

## Digital and Print Output

- [ ] PDF rendering has been checked.
- [ ] Fonts render correctly.
- [ ] Images and equations render correctly.
- [ ] Links and navigation work where applicable.
- [ ] Page numbering is correct.
- [ ] Print-specific requirements have been checked where applicable, including K-only text and light tints.
- [ ] No unexpected blank pages exist.

## Content Quality

- [ ] The document follows its intended structure.
- [ ] Technical information is accurate.
- [ ] Diagrams agree with the written explanation.
- [ ] Tables contain the intended information.
- [ ] Assumptions and limitations are identified.
- [ ] No required content has been omitted during formatting.

---

# 29. Reference Resources

The following resources provide guidance for accessibility, colour, and document quality.

**Accessibility**

1. W3C — Web Content Accessibility Guidelines (WCAG) 2.2 — https://www.w3.org/TR/WCAG22/
2. W3C — Understanding Contrast (Minimum) — https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
3. W3C — Understanding Non-text Contrast — https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
4. W3C — Understanding Use of Color — https://www.w3.org/WAI/WCAG22/Understanding/use-of-color.html
5. W3C — WCAG 3.0 Working Draft (informative only; not a compliance standard) — https://www.w3.org/TR/wcag-3.0/
6. PDF Association — ISO 14289-2 (PDF/UA-2) — https://pdfa.org/iso-14289-2-pdfua-2/
7. ETSI — EN 301 549, Accessibility requirements for ICT products and services — https://www.etsi.org/
8. Section 508 — Accessibility Guidance — https://www.section508.gov/
9. GOV.UK — Accessibility Guidance — https://www.gov.uk/service-manual/helping-people-to-use-your-service

**Colour and data visualization**

10. Okabe, M. and Ito, K. — Color Universal Design (categorical palette used in Section 5.5); popularized by Wong, B. (2011), "Points of view: Color blindness", *Nature Methods* 8, 441.
11. ColorBrewer — colour schemes for maps and charts — https://colorbrewer2.org/
12. Paul Tol — Colour schemes for scientific data — https://personal.sron.nl/~pault/

**Safety information**

13. ANSI Z535.6 — Product Safety Information in Product Manuals, Instructions, and Other Collateral Materials.
14. ISO 3864 — Graphical symbols: safety colours and safety signs.
15. IEC/IEEE 82079-1 — Preparation of information for use (instructions for use) of products.

---
# Appendix A — Computed Contrast Matrix

All ratios use the WCAG 2.x relative-luminance formula and are truncated to two decimals (never rounded up). Recompute this appendix whenever a token value changes.

## A.1 Light theme — text and graphics on backgrounds

| Foreground | `bg.page` | `bg.subtle` | `accent.subtle` | Information bg | Warning bg | Error bg | Positive bg |
|---|---:|---:|---:|---:|---:|---:|---:|
| `text.primary` `#202729` | 15.17 | 14.10 | 13.58 | 13.67 | 14.00 | 13.23 | 13.58 |
| `text.secondary` `#555F5B` | 6.61 | 6.14 | 5.92 | 5.96 | 6.10 | 5.76 | 5.92 |
| `accent.strong` `#1E4D35` | 9.68 | 9.00 | 8.66 | 8.72 | 8.93 | 8.44 | 8.66 |
| `accent.primary` `#3A8760` | 4.36 | 4.05 | 3.90 | 3.93 | 4.02 | 3.80 | 3.90 |
| `border.strong` `#76817C` | 4.03 | 3.75 | 3.61 | 3.63 | 3.72 | 3.52 | 3.61 |
| `border.subtle` `#D6DEDA` | 1.37 | 1.27 | 1.22 | 1.23 | 1.26 | 1.19 | 1.22 |
| `text.link` `#245A8D` | 7.18 | 6.67 | 6.43 | 6.47 | 6.63 | 6.26 | 6.43 |
| Information fg `#245A8D` | 7.18 | 6.67 | 6.43 | 6.47 | 6.63 | 6.26 | 6.43 |
| Warning fg `#855000` | 6.67 | 6.20 | 5.97 | 6.01 | 6.16 | 5.82 | 5.97 |
| Error fg `#A52626` | 7.22 | 6.71 | 6.46 | 6.51 | 6.67 | 6.30 | 6.46 |
| Positive fg `#1E4D35` | 9.68 | 9.00 | 8.66 | 8.72 | 8.93 | 8.44 | 8.66 |

Other light pairs: `text.primary` on `accent.secondary` 9.35:1; `text.primary` on `bg.highlight` 13.38:1; `text.link` against `text.primary` 2.11:1.

## A.2 Dark theme — text and graphics on backgrounds

| Foreground | `bg.page` | `bg.subtle` | `accent.subtle` | Information bg | Warning bg | Error bg | Positive bg |
|---|---:|---:|---:|---:|---:|---:|---:|
| `text.primary` `#E1E6E4` | 14.43 | 12.91 | 11.44 | 12.16 | 12.42 | 12.67 | 11.44 |
| `text.secondary` `#A0ACAA` | 7.78 | 6.96 | 6.17 | 6.56 | 6.70 | 6.83 | 6.17 |
| `accent.strong` `#8ED6AE` | 10.73 | 9.60 | 8.51 | 9.04 | 9.24 | 9.42 | 8.51 |
| `accent.primary` `#52B781` | 7.32 | 6.55 | 5.81 | 6.17 | 6.30 | 6.43 | 5.81 |
| `border.strong` `#6B7B7E` | 4.12 | 3.69 | 3.27 | 3.47 | 3.55 | 3.62 | 3.27 |
| `border.subtle` `#2E3A3C` | 1.54 | 1.38 | 1.22 | 1.30 | 1.33 | 1.36 | 1.22 |
| `text.link` `#7FB2E5` | 8.15 | 7.29 | 6.46 | 6.87 | 7.02 | 7.15 | 6.46 |
| Information fg `#7FB2E5` | 8.15 | 7.29 | 6.46 | 6.87 | 7.02 | 7.15 | 6.46 |
| Warning fg `#E3AC4F` | 8.91 | 7.97 | 7.07 | 7.51 | 7.67 | 7.82 | 7.07 |
| Error fg `#F28B82` | 7.62 | 6.82 | 6.04 | 6.42 | 6.56 | 6.69 | 6.04 |
| Positive fg `#6FCF97` | 9.58 | 8.57 | 7.59 | 8.07 | 8.25 | 8.41 | 7.59 |

Other dark pairs: `text.primary` on `accent.secondary` 6.24:1; `text.primary` on `bg.highlight` 8.27:1; `text.link` against `text.primary` 1.76:1.

Reading the matrix: normal text needs 4.50 or more; large text and meaningful graphics need 3.00 or more. Accent rows apply to graphics only, because accent tokens are not text colours (Section 4.5). Decorative tokens (`border.subtle`) are listed to show why they must not carry meaning.

---

# Appendix B — Changes from Version 1.0

Every change is listed so that no rule was changed or removed silently. "v1 §" refers to the original numbering.

## B.1 Section Renumbering

| v1 § | v2 § | Note |
|---|---|---|
| 1 | 1 | Added 1.2–1.5 (how to use, normative language, precedence, terms) |
| 2 | 2 | Unchanged except cross-references and two added bullets |
| 3 | 3–7 | Colour system expanded from one section to five |
| 4 | 8 | Typography |
| 5 | 9 | Layout |
| 6 | 10 | Cover and front matter |
| 7–16 | 11–19, 20 | Components and document-specific adaptation |
| 17 | 24 | Accessibility |
| 18 | 6.3 | Dark mode merged into the colour system |
| 19 | 23 and 6.5 | Print layout kept in 23; colour conversion moved to 6.5 |
| 20 | 21 | Responsive layout |
| 21 | 22 | Localization |
| 22 | 25 | Export and validation |
| 23 | 26 | AI rules |
| 24 | 27 | Reusable prompt |
| 25 | 28 | Checklist |
| 26 | 29 | References |

## B.2 Corrections (essential)

| # | v1 location | Problem | Change |
|---|---|---|---|
| C1 | §3.2 Primary Accent `#4BA173` | 2.93:1 on Secondary Background and 2.83:1 on Light Accent; fails v1's own 3:1 graphics rule (§17.1) | Revised to `#3A8760` (same hue; ≥3.90:1 on all light backgrounds) |
| C2 | §3.1 vs §3.2 | Role table lists Secondary Accent with no value; palette lists Dark Accent and Light Accent, which are not roles | Unified into one token table (§4.1) with every role valued |
| C3 | §3.1 Border used for "diagram outlines"; §17.1 requires 3:1 for meaningful graphics | Border is 1.37:1 on white | Added `border.strong` (`#76817C`); `border.subtle` restricted to decoration |
| C4 | §18 Dark theme | No semantic colours; light semantic colours fall to 1.88–2.73:1 on the dark page | Added dark semantic set (§4.3) |
| C5 | §18.1 | No Dark Accent, Secondary Accent, or strong border; "Light Accent Background" name misleading in a dark theme | Added `accent.strong`, `accent.secondary`, `border.strong` (Dark); renamed to `accent.subtle` |
| C6 | §3.3 Positive = §3.2 Dark/Light Accent | Accent emphasis is indistinguishable from "pass" | Rule added: accent not used in status contexts (§4.3); brand hue-collision check (§6.1) |
| C7 | §24 prompt | Refers to `DOCUMENT_DESIGN_SYSTEM.md`, which does not match the file name | Corrected (§27) |
| C8 | §4.2 sizes | Cover/Chapter overlap at 28 pt; Section/Subsection overlap at 16 pt, contradicting §4.3 "clear distinction" | Cover 30–36 pt; Subsection 13–15 pt; 2 pt minimum step (§8.2) |
| C9 | §12.1 vs §3.3 | Eight callout types, four semantic colours, no mapping | Mapping table (§5.3) |
| C10 | §3.3 vs §7.4 | Label vocabularies differ (`SUCCESS`, `INFORMATION` vs `PASS`, `INFO`, `N/A`) | One vocabulary (§4.3) |
| C11 | §17.1 | "Large text" undefined; rounding not addressed | Defined (§1.5); no-rounding rule (§3.2) |
| C12 | §12 WARNING for lab and user manuals | Conflicts with product-safety signal-word conventions (DANGER/WARNING/CAUTION/NOTICE) | Safety-message rule (§5.9) |

## B.3 Additions

| # | v2 § | Addition |
|---|---|---|
| A1 | 1.3, 1.4 | Normative keywords and order of precedence |
| A2 | 3.1 | Colour space (sRGB), notation, no-transparency rule |
| A3 | 3.2 | Contrast table including links, thin fonts, text over images; APCA status |
| A4 | 3.3 | Colour harmony model |
| A5 | 4.2 | Permitted text/background pairing matrix |
| A6 | 4.4 | Link and highlight tokens |
| A7 | 4.5 | Quantitative usage limits |
| A8 | 5.1–5.8 | Colour mapping for headings, tables, callouts, diagrams, charts, code, timing diagrams, covers |
| A9 | 5.5 | Categorical (Okabe–Ito), sequential, and diverging chart palettes with contrast data |
| A10 | 5.6 | Syntax-highlighting palette (light and dark) |
| A11 | 6.1 | Brand-colour derivation procedure |
| A12 | 6.2 | Colour profiles by document category |
| A13 | 6.4 | Greyscale and monochrome rules |
| A14 | 6.5 | K-only text, light tints, ink limits, transparency, spot colours |
| A15 | 6.6 | Projection rules |
| A16 | 7 | Colour validation procedure and colour specification record |
| A17 | 8.1 | Openly licensed font fallbacks |
| A18 | 8.3 | Line-spacing values |
| A19 | 19.4 | Watermarks and status stamps |
| A20 | 20.9–20.12 | Presentations, forms, legal/financial, posters |
| A21 | 22.6 | Colour and culture |
| A22 | 24.1 | PDF/UA-1, PDF/UA-2, EN 301 549 references |
| A23 | 25.1 | Output intents, PDF/A, PDF/X |
| A24 | Appendix A | Computed contrast matrix |

## B.4 Rewordings of Existing Rules

| v1 rule | v2 wording |
|---|---|
| "Avoid bright colours for small text." (§3.4) | "Text MUST use only tokens permitted for text in Section 4.2." |
| "Check contrast." (§23.3) | "Compute contrast for every pair used (Section 7.1), rather than assuming the palette passes." |
| "Avoid arbitrary colour schemes." (§23.3) | "Not invent colour values. Every colour used MUST trace to a token, a semantic colour, a chart palette entry, or a justified entry in the colour specification." |
| "Left-align standard English body text." (§5.4) | Kept as default; justified text allowed when a template requires it (§9.4) |
| "Use adequate resolution." (§13.2) | About 300 ppi for print photographs; vector for diagrams (§17.2) |

## B.5 Changes in Version 2.1

| # | v2.1 location | Change | Reason |
|---|---|---|---|
| D1 | 4.1, 4.2, 4.5, 5.1, 5.3 | Accent colours are no longer allowed as text colours. Headings and subheadings at every level use `text.primary`; TIP and IMPORTANT labels use `text.primary`. The accent remains for graphics, rules, markers, fills, and diagrams. | Owner feedback: coloured heading text looked unprofessional; green works in diagrams but not in text. |
| D2 | 5.6 | Custom syntax palette replaced with the VS Code Default Light+ / Dark+ token colours, a role-to-scope table, a language mapping (SystemVerilog, C/C++, Python, Bash), and the theme's own code backgrounds. Bold/italic kept only as a greyscale safeguard. | Owner feedback: code should use a recognized standard scheme. Light+ numbers and types fail 4.5:1 on `bg.subtle`, so the code background changed to white. |
| D3 | 6.1 | Added OKLCH chroma caps for derived tokens, four recommended accent presets, and a house-style rule against purple/pink and yellow/orange accents unless a brand requires them. | Owner feedback: the derived purple in the showcase looked poor. The procedure kept the brand's full saturation (chroma 0.15); the caps prevent this for any hue. |
| D4 | 5.5 | Highlight charts use light neutral bars with a `border.strong` outline; annotation text stays `text.primary`. | Consequence of D1. |
| D5 | 15.3 | Equation highlights use `bg.highlight` or an underbrace label instead of accent-coloured text. | Consequence of D1. |
| D6 | 6.2 | Category profiles no longer list headings as an accent location. | Consequence of D1. |

Superseded v2.0 rules (kept here so nothing is removed silently): "Headings, optional accent: `accent.strong`, at one heading level only"; "`accent.strong` allowed uses: any text"; "`accent.primary`: large text only in Light theme"; the v2.0 syntax palette (`#7A3E9D`, `#1E6B45`, `#8A4B00`, `#245A8D`, `#5D6863` on `bg.subtle`).

## B.6 Changes in Version 2.2

| # | Location | Change | Reason |
|---|---|---|---|
| E1 | 5.6 | Section rewritten from measured data. SystemVerilog was tokenized with the *Verilog-HDL/SystemVerilog* extension grammar and the VS Code theme files, and the colours were read from the result. | v2.1 assigned colours by guesswork and got the SystemVerilog mapping wrong: `module`, `always_ff`, `begin`, `if`, `assign` and `property` are purple (control keywords), not blue; `input`/`output` and module names are teal; directives are dark red (`#811F3F`), not blue. |
| E2 | 5.6.4 | Other-language table corrected: C/C++ `#include` and `#define`, and Python `import`/`from`, are purple, not blue. | Same check, using VS Code's built-in grammars. |
| E3 | 5.6.1 | Standard named as Light Modern / Dark Modern (Light+ / Dark+ token colours, Modern backgrounds `#FFFFFF` / `#1F1F1F`), with Light 2026 / Dark 2026 as a documented alternative. | VS Code's default themes are now Light 2026 / Dark 2026, which colour types, functions, strings and comments differently. |
| E4 | 5.6.2 | Highlighting must be generated by a tokenizer (for example, Shiki) with the real grammar and theme; hand assignment only as a recorded fallback. | Hand-assigned colours cannot reproduce the grammar's choices. |

## B.7 Changes in Version 2.3

| # | Location | Change | Reason |
|---|---|---|---|
| F1 | 5.6 | Replaced the full VS Code theme reproduction (v2.2, Sections 5.6.1–5.6.5) with a four-colour scheme: keywords, comments, strings, plain text. Removed the tokenizer requirement, the per-theme tables, and the per-language mapping. | Owner feedback: the full editor colour set was too complex for documents; keep code highlighting simple. |

Superseded v2.2 content (kept here so nothing is removed silently): full SystemVerilog token table for Light Modern, Dark Modern, Light 2026 and Dark 2026; other-language table; Shiki tokenizer requirement.

## B.8 Removed Rules

None. Duplicated rules were consolidated into one location and replaced elsewhere with a cross-reference.

---

# End of Universal Document Design System
