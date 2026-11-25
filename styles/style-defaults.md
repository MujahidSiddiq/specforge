# Style defaults

The default value of every styled element of a specforge document. The
values reproduce the reference high-level specification that specforge was
derived from, and they follow the rules of `colour-guide.md`.

A project changes any value by naming its key, with the same nesting, in the
`overrides` block of its `style.md`. Keys that are not overridden keep the
values below. The build turns the merged values into the
LaTeX style files, so these keys are the only place where a style value is
defined.

Units are part of the key name (`_pt`, `_mm`). Colours are `#RRGGBB` and
always refer to a token of the `colour` group by name (for example
`text_primary`) everywhere else, so that changing a token changes every
element that uses it.

```yaml
page:
  paper: a4                        # a4 | letter
  class_font_size_pt: 11           # base size of the document class
  margin_mm: 22                    # all four sides
  head_height_pt: 14
  head_sep_mm: 8
  foot_skip_mm: 11
  chapter_starts_new_page: false   # chapters run on, to fit the page budget
  front_matter_numbering: roman    # title page, document information, contents
  body_numbering: arabic

colour:                            # colour-guide.md Sections 4.1, 4.3 (light theme)
  text_primary: "#202729"          # body text, headings, table text, labels
  text_secondary: "#555F5B"        # captions, header, footer, wires, sub-labels
  bg_page: "#FFFFFF"               # page background
  bg_subtle: "#F5F7F6"             # table header row, top-level boundary fill
  border_subtle: "#D6DEDA"         # decorative rules only (table rows, grids)
  border_strong: "#76817C"         # meaningful boundaries (block outlines, header rule)
  accent_primary: "#3A8760"        # graphics only: chapter rule, highlighted path
  accent_strong: "#1E4D35"         # graphics and fills
  accent_subtle: "#EAF5EE"         # background behind text (highlighted entry)
  accent_secondary: "#A9D5BD"      # decorative fills
  info_fg: "#245A8D"               # semantic colours: always with a text label
  info_bg: "#EDF4FA"
  warn_fg: "#855000"
  warn_bg: "#FFF5DF"
  error_fg: "#A52626"
  error_bg: "#FBECEC"

fonts:                             # OpenType families (colour-guide.md Section 8.1)
  main: SourceSans3                # body text
  main_upright: "*-Regular"
  main_italic: "*-RegularIt"
  main_bold: "*-Semibold"
  main_bold_italic: "*-SemiboldIt"
  heading: SourceSans3             # headings, title, block names
  heading_upright: "*-Bold"
  heading_italic: "*-BoldIt"
  mono: SourceCodePro              # signals, parameters, modules, code
  mono_upright: "*-Regular"
  mono_bold: "*-Semibold"
  mono_scale: 0.88

body:
  line_spread: 1.12
  paragraph_skip_pt: 6
  ragged_right: true               # no justified text
  hyphenation: false
  list_item_sep_pt: 2
  list_top_sep_pt: 4
  identifiers_monospace: true      # signal, parameter and module names

headings:                          # all headings in heading font, text_primary
  colour: text_primary
  chapter:
    size_pt: 19
    leading_pt: 23
    space_before_pt: 22
    space_after_pt: 10
    rule_colour: accent_primary    # short rule under the chapter title
    rule_width_mm: 20
    rule_thickness_pt: 2
  section:
    size_pt: 17
    leading_pt: 21
    space_before_pt: 20
    space_after_pt: 6
  subsection:
    size_pt: 14
    leading_pt: 17
    space_before_pt: 16
    space_after_pt: 4
  subsubsection:
    size_pt: 12
    leading_pt: 15
    space_before_pt: 12
    space_after_pt: 3
  numbering_depth: 3               # 1.2.3.4 is the deepest numbered level
  toc_depth: 0                     # contents list chapters only (page budget)

title_page:
  top_space_mm: 48
  rule_colour: accent_primary      # the only graphical marker on the page
  rule_width_mm: 24
  rule_thickness_pt: 3
  title_size_pt: 34
  title_leading_pt: 40
  title_colour: text_primary
  subtitle_size_pt: 18
  subtitle_leading_pt: 22
  subtitle_colour: text_secondary
  fields: [Author, Revision, Date, Status]   # shown at the foot of the page
  field_label_colour: text_secondary

front_matter:
  document_information: true       # table: type, design, revision, date, author, status
  revision_history: true
  contents: true
  list_of_figures: false           # omitted to fit the page budget
  list_of_tables: false
  share_one_page: true             # information, history and contents on one page if they fit

header_footer:
  font_size: small
  colour: text_secondary
  header_left: title               # title | short_name | chapter | none
  header_right: chapter
  footer_left: "Revision {revision} • {status}"
  footer_right: page
  header_rule_pt: 0.5
  header_rule_colour: border_subtle
  footer_rule_pt: 0

captions:
  font_size: small
  colour: text_secondary
  label_bold: true
  label_colour: text_primary
  label_separator: period
  skip_pt: 8
  table_caption_position: above
  figure_caption_position: below

tables:                            # colour-guide.md Sections 5.2, 11
  font_size_pt: 10
  leading_pt: 12.5
  row_stretch: 1.35
  column_sep_pt: 6
  header_fill: bg_subtle
  header_bold: true
  outer_rule_colour: border_strong # top, below header, bottom
  outer_rule_pt: 0.8
  row_rule_colour: border_subtle
  row_rule_pt: 0.5
  vertical_rules: false
  breakable: false                 # short tables, kept on one page

callouts:                          # colour-guide.md Sections 5.3, 16
  open_point:
    label: OPEN POINT
    fill: warn_bg
    bar_colour: warn_fg
    bar_width_pt: 2.4
    label_colour: warn_fg
  pending:
    label: PENDING                 # marks information not yet confirmed
    colour: warn_fg
  note:
    fill: bg_subtle                # highlighted statement (e.g. a key rule)
    width_fraction: 0.92

figures:
  max_height_fraction: 0.44        # of the text height (page budget)
  max_height_fraction_timing: 0.62 # timing diagrams need more room
  top_fraction: 0.95               # float placement: let figures share pages
  text_fraction: 0.05
  float_page_fraction: 0.8
  max_floats_per_page: 2
  floats_stay_in_chapter: true

diagrams:                          # colour-guide.md Sections 5.4, 12
  boundary:                        # top-level module boundary
    draw: border_strong
    fill: bg_subtle
    line_pt: 1.1
  block:                           # functional block
    draw: border_strong
    fill: bg_page
    line_pt: 0.9
  group:                           # interface group box
    draw: border_strong
    fill: bg_page
    line_pt: 0.8
    corner_radius_pt: 2
  wire:
    colour: text_secondary
    line_pt: 0.8
  control_wire_pt: 0.7             # control signals thin
  data_wire_pt: 1.7                # data and state signals thick
  bundle_pt: 1.3
  packet_line_pt: 0.6              # each of the two lines of a packet arrow
  packet_gap_pt: 1.6               # space between them
  highlight:                       # highlighted path, always labelled
    colour: accent_primary
    line_pt: 1.1
  port_size_mm: 2
  junction_size_mm: 1.6
  signal_label_size_pt: 8          # monospace, text_primary
  block_name_size_pt: 12           # heading font, text_primary
  block_sub_size_pt: 8.5           # text_secondary
  group_title_size_pt: 8.5
  width_label_size_pt: 8

timing:                            # colour-guide.md Sections 5.7, 13
  signal_colour: text_primary
  clock_colour: text_secondary
  line_pt: 0.8
  grid_colour: border_subtle
  grid_line_pt: 0.4
  undefined_pattern: hatch         # value not specified
  undefined_pattern_colour: border_strong
  label_size_pt: 8                 # monospace
  x_scale: 2.7                     # one clock cycle = two timing units
  y_scale: 1.5
  slope: 0.12

pdf:
  bookmarks_numbered: true
  display_title: true
  hide_links: true                 # links are not boxed or coloured
```

## Elements and their sources

| Group | Applies to | Base rules in `colour-guide.md` |
|---|---|---|
| `page` | Paper, margins, header and footer spacing, numbering | Sections 9, 19.3 |
| `colour` | Every colour in the document | Part II (Sections 3 to 7) |
| `fonts`, `body` | Text, identifiers | Sections 8.1 to 8.6 |
| `headings` | Chapter to subsubsection headings | Sections 5.1, 8.4 |
| `title_page`, `front_matter` | Title page, document information, revision history, contents | Sections 5.8, 10 |
| `header_footer` | Running header and footer | Section 19 |
| `captions` | Figure and table captions | Sections 12.6, 17.4 |
| `tables` | All tables | Sections 5.2, 11 |
| `callouts` | Open points, pending markers, highlighted notes | Sections 5.3, 16 |
| `figures` | Figure size and placement | Section 17 |
| `diagrams` | Block and architecture diagrams | Sections 5.4, 12 |
| `timing` | Timing diagrams and waveforms | Sections 5.7, 13 |
| `pdf` | PDF properties | Section 1 (accessibility and portability) |

## Rules that are not values

These rules hold for every document, whatever the overrides:

- Colour never carries meaning alone: a highlighted path, a callout or a
  marked entry always has a text label (`colour-guide.md` Section 4.5).
- Headings and body text use only `text_primary`; the accent is used for
  graphics, never for text.
- Every foreground/background pair meets the contrast requirement of
  `colour-guide.md` Section 3.2; changed colours are checked before a build.
- Each document gets a colour specification record
  (`colour-guide.md` Section 7.4).
