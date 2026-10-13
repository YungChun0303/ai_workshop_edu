# Step 01 — Data Audit

**Use:** in Claude Code, from the project folder: `Follow @prompts/01_data_audit.md`

---

## Goal

Understand the raw data before changing anything. The output is an audit the researcher can make decisions from.

## Read first

- `CLAUDE.md` (research question, folder rules, study definitions)
- `data_raw/codebook.md`
- Every data file in `data_raw/`

## Do

1. Write and knit `code/0000_import.Rmd` (inspection only). For each file, report: rows, columns, column types, the key that identifies a row and whether it is unique, year coverage, missingness, and whether every categorical value appears in the codebook.
2. Look for problems a careful analyst would catch: duplicate or multiple records per unit, inconsistent formats (e.g., codes stored as text), out-of-range or flagged values, units outside the study area, years outside the study period, gaps in years, and files that do not link cleanly.
3. Write `writing/data_audit.md` with:
   - a file inventory table (file, unit, key, years, rows);
   - how the files link to each other;
   - **each issue found**, with the evidence (a count, not an example record) and a proposed fix;
   - open questions for the researcher.

## Do not

- Write anything to `data_clean/`, or fix any issue yet.
- Print individual records. Use counts and summaries.

## Checkpoint

Stop. Summarize the most important issues in at most ten bullets, each with its proposed fix, and **wait for the researcher to approve or change each fix** before step 02.
