# 02 - Writing

## Tone and precision

Writing is precise, unambiguous, technically accurate, concise and
consistent. It is not conversational.

- One statement, one fact. Say what the design does, under which condition,
  and when (for example "in the same cycle", "in the next cycle").
- Use the present tense and the active voice: "The buffer stores the
  entry", not "The entry will be stored".
- Use *must*, *must not* and *may* only for requirements on the
  environment (inputs, users of the design), never for the design's own
  behaviour, which is stated as fact.
- No speculation about implementation, no unsupported claims, no repeated
  explanations. If a fact is given in one place, other places refer to it.
- Avoid vague words: "some", "usually", "fast", "large", "etc." State the
  number, the condition or the complete list.

## Terminology

- Use the names of the inputs exactly: block names, signal names, parameter
  names. Do not invent synonyms; one thing has one name throughout.
- Define each term on first use, and list the terms in the introduction
  when the document uses more than a few.
- Signal, parameter, module and file names are written as inline code
  (`` `data_valid` ``); they are set in the monospace font.
- Block names in prose start with a capital letter when the input does
  (for example "Transmit FIFO"); be consistent with the input.
- Avoid words the user has asked not to use; record such wishes in
  `clarifications.md` so they are kept.

## Numbers and units

- Widths in bits are plain numbers in tables ("8") and "8-bit" in prose.
- Use the parameter name when a value depends on a parameter
  (`DATA_WIDTH`), and give the default value where it helps.
- Use SI units with a space: "10 ns", "2 KiB" for binary sizes.
- Write ranges with "to": "0 to 7".

## Cross-references

- Refer to chapters, sections, tables and figures by number: "Table 3.1",
  "Figure 2.2", "Section 4.3", "Chapter 5". The build checks that each one
  exists.
- A reference to another document puts that document's name or
  abbreviation first: "ABC Section 1.2". The build skips such references.
- Refer to a figure or table before it appears, and say what it shows.

## Open points and unconfirmed content

- Content that is not confirmed is written as an open point:
  `> **Open point OP-n.** <what is open and what it affects>`.
- Every open point is also listed in the constraints-and-limitations
  chapter, with its ID.
- A closed open point disappears from the text and is recorded in the
  revision history; the answer goes into `clarifications.md`.

## Requirements (optional)

When the document type asks for numbered requirements, each has a unique ID
(for example `REQ-IF-001`), describes one verifiable behaviour, and names
the section or table it comes from.

## Language

British or American spelling as the inputs use it; one of them throughout.
The PDF language tag is `document.language` in `project.md`.
