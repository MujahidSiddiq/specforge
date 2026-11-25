# Project configuration

Example project of specforge: an invented design, given as a Markdown
description and documented with high-level diagrams.
`../specforge_output_detailed` has the same chapters with detailed
diagrams.

```yaml
specforge_version: "0.3.0"
document_type: design-spec
approach: design-info
diagrams: high-level
inputs:
  design_info: "../project_description/"
document:
  title: "Packet FIFO (PFIFO)"
  short_name: PFIFO
  author: specforge example
  revision: "1.0"
  status: Example
  date: 25 November 2026
page_budget:
  max: 8
```
