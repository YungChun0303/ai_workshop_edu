# Step 05 — Manuscript Brief

**Use:** `Follow @prompts/05_manuscript_brief.md` — after the researcher has reviewed the results.

---

## Goal

Write a brief the researcher can draft the Methods and Results sections from. This is **not** the paper: it organizes what was done and found, and marks what only the researcher can decide.

## Read first

- `CLAUDE.md` (especially §7, writing guidelines)
- `writing/data_audit.md`, `writing/analysis_plan.md`
- The scripts in `code/` and the files in `outputs/`

## Do

Write `writing/manuscript_brief.md` with these sections:

1. **Summary:** the question and the answer in one paragraph.
2. **Data:** sources, period, and sample construction, with the counts from the cleaning log.
3. **Methods:** each design as actually implemented — estimand, identifying assumption, specification, inference. Name the script for each.
4. **Results:** each finding as a one-sentence claim with its number, followed by `<!-- source: outputs/... -->`.
5. **Tables and figures:** file, what it shows, and a proposed caption.
6. **Robustness and diagnostics:** what was checked and what it showed.
7. **Limitations and threats.**
8. **Decisions for the researcher:** framing, interpretation, and implications that the analysis cannot settle.
9. **AI-use disclosure (draft):** what Claude did in this project (data audit, cleaning code, design options, estimation code, this brief) and what the researcher decided.

## Rules

- Every number comes from a file in `outputs/`, with its source in an HTML comment.
- Use causal language only where the design supports it.
- Never invent citations: write `[CITATION NEEDED]`.

## Checkpoint

Stop. List any claim you are unsure of, and any number you could not trace to an output file.
