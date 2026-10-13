# Step 03 — Empirical Strategy

**Use:** switch Claude Code to **plan mode** first — press Shift+Tab until the status bar shows plan mode (in the desktop app: Cmd+Shift+M / Ctrl+Shift+M). In plan mode Claude can read files and explore, but cannot edit anything. Then: `Follow @prompts/03_empirical_strategy.md`

---

## Goal

Propose how to answer the research question with these data. **No estimation in this step** — the researcher chooses the design.

## Read first

- `CLAUDE.md` (research question, §6 analysis standards)
- `writing/data_audit.md` and the cleaning log from step 02
- The variable lists of the files in `data_clean/`

## Do

1. Restate each part of the research question as an estimand: who is treated, what outcome, compared with what.
2. Describe the features of the data that constrain the design: how many treated units, whether treatment timing is staggered, the length of the pre-period, which outcomes exist at which level.
3. For each part of the question, propose **two or three candidate designs**. For each design give:
   - the identifying assumption, in plain language;
   - how to check it with these data (pre-trends, placebo outcomes, placebo units);
   - the main threats (selection, spillovers, composition change);
   - the R package and the data file it would use.
4. **Recommend one design per question** and say why.
5. List the descriptive analyses needed first (`2000` series), the robustness and placebo checks, and the **plausibility benchmarks** to compare results against (for example, typical yearly growth in the outcome).
6. Write all of this to `writing/analysis_plan.md`.

## Do not

- Run any model or write any `3000`-series script.
- Choose for the researcher.

## Checkpoint

Stop. Present the design choices as numbered options and **wait for the researcher's decision.** Then record the approved primary specification and robustness checks in `CLAUDE.md` §6.
