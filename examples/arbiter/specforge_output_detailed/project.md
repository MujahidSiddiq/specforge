# Project configuration

Example project of specforge: an invented design, documented with
detailed diagrams. `../specforge_output_high-level` has the same chapters
with high-level diagrams.

```yaml
specforge_version: "0.3.0"
document_type: design-spec
approach: rtl
diagrams: detailed
inputs:
  rtl: "../project_rtl/"
  rtl_top: "req_arbiter"
document:
  title: "Request Arbiter (ARB)"
  short_name: ARB
  author: specforge example
  revision: "1.0"
  status: Example
  date: 25 November 2026
page_budget:
  max: 8
```
