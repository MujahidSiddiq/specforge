# Checklist: intake (workflow steps 1 to 3)

## Configuration

- [ ] `project.md` exists and its `yaml` block reads without errors.
- [ ] `document_type` and `approach` have supported values.
- [ ] `document.title`, `document.short_name` and `document.author` are set.
- [ ] For `rtl`: `inputs.rtl_top` is set and the module exists in the RTL.
- [ ] The input folders exist and contain the expected files.
- [ ] `style.md` has no unknown keys and passes the contrast check (or is
      empty).
- [ ] `specforge_version` matches the framework, or the differences were
      reviewed with the user.
- [ ] `clarifications.md`, `revision-history.md` and `status.md` exist.

## Analysis

- [ ] Every input file is listed in `analysis.md` with a summary.
- [ ] For `rtl`: the RTL version (commit, tag or date) is recorded and the
      inventory was run.
- [ ] Every extracted fact has a source and a state (confirmed or derived).
- [ ] Every item of `shared/hls-information-checklist.md` is marked given,
      partly given or missing.
- [ ] Contradictions, ambiguities and naming problems are listed as
      findings.
- [ ] The understanding is summarized for the user to confirm.

## Clarification

- [ ] Every finding that changes the document has a question.
- [ ] Every question is in `clarifications.md` with source and proposed
      default.
- [ ] Questions are short, numbered, grouped, most blocking first.
- [ ] Nothing that blocks the outline is still open.
