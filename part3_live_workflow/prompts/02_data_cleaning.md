# Step 02 — Data Cleaning and Management

**Use:** `Follow @prompts/02_data_cleaning.md` — after the researcher has decided on each fix in `writing/data_audit.md`.

---

## Goal

Turn the raw files into analysis-ready data, applying exactly the fixes the researcher approved.

## Read first

- `CLAUDE.md` (especially §6: study definitions, intervention timing, study area)
- `writing/data_audit.md` and the researcher's decisions on it

## Do

1. Write `code/1000`-series scripts that build:
   - **one row per unit-year** for the main analysis file (for example, student-year), with covariates, outcomes, and treatment exposure;
   - **treatment timing** for each unit: the first year it is exposed, or 0 if never exposed (the format staggered-adoption estimators expect);
   - any **aggregate panel** the research question needs (for example, a place-year panel in a `1100` script).
2. Keep a **cleaning log**: rows and units remaining after each step, shown as a table in the knitted script.
3. Add checks that stop the script if something is wrong: keys unique, codes within the codebook, no unexpected missing values in key variables.
4. Save each file to `data_clean/` as `.rds`, knit every script, and fix errors before reporting.

## Do not

- Modify `data_raw/`.
- Make a research decision that is not in the audit (for example, dropping a group or redefining treatment). Ask instead.

## Checkpoint

Stop. Report the cleaning log, the variables in each saved file with one-line definitions, and anything surprising. **Wait for the researcher** before step 03.
