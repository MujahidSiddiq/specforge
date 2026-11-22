# 03 - Tables

## When to use a table

Use a table for structured facts that a reader looks up: interfaces and
signals, parameters, configuration, operating conditions, states, priority
rules, terminology. Use prose for behaviour that is a sequence of events.

## Form

```markdown
**Table 3.1.** External interfaces of `top_unit`.

| Signal | Width | Direction | Description |
|---|---|---|---|
| `clk` | 1 | Input | Clock. |
```

- Every table has a numbered caption line **above** it:
  `**Table N.M.** Caption.` `N` is the chapter, `M` counts the tables of
  the chapter from 1. The build checks the numbering.
- The caption is a short noun phrase ending with a full stop. It names what
  the table lists, not what it proves.
- The first row is the header. Header cells are short nouns.
- Cells are short. A description cell is one or two sentences ending with a
  full stop; name and number cells have no full stop.
- Identifiers in cells are inline code.

## Layout

- Tables are set as unbreakable blocks (`tables.breakable: false`): keep a
  table short enough to fit on one page, about 25 rows at most. Split a
  longer table by topic into two numbered tables.
- At most five columns; four is better. A column that is the same in every
  row is removed and stated in the caption or the text.
- The build sizes the columns from their content. A cell holding one long
  unbreakable identifier sets the minimum width of its column; if a table
  overflows, shorten the content or split the column.
- No empty cells: write "--" for not applicable, and say what it means in
  the text if it is not obvious.

## Style

Fills, rules, fonts and spacing come from the `tables` style keys; a table
is never styled in the chapter. There are no vertical rules.
