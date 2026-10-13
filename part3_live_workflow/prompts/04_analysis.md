# Step 04 — Analysis

**Use:** `Follow @prompts/04_analysis.md` — after the researcher has approved `writing/analysis_plan.md`.

---

## Goal

Implement the approved plan exactly, and check whether the results make sense.

## Read first

- `CLAUDE.md` §6 (approved primary specification and robustness checks)
- `writing/analysis_plan.md`

## Do

1. **Descriptives (`2000` series):** sample size by year and group, baseline characteristics by treatment group, treatment timing, and outcome trends by group. Save each table to `outputs/tables/` (CSV) and each figure to `outputs/figures/` (PNG), with names that start with the script number.
2. **Models (`3000+` series):** one script per design in the plan. Estimate the primary specification, then each listed robustness and placebo check. Report estimates with standard errors or confidence intervals.
3. **Diagnostics:** the checks named in the plan (for example, an event study for pre-trends, or placebo runs for a synthetic control).
4. **Sanity check:** end each model script with a short section comparing the estimates with the plausibility benchmarks in the plan. Flag anything that looks too large, too small, or the wrong sign, and say what might explain it.
5. Knit every script and fix errors before reporting.

## Do not

- Change the specification without asking.
- Run unlisted specifications and report only some of them. If you run something extra, report it.

## Checkpoint

Stop. Give a results table (estimate, SE or CI, source file), the diagnostics, and every flag from the sanity checks. **Wait for the researcher** before step 05.
