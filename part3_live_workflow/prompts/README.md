# Prompts — From Raw Data to a Manuscript Brief

Five prompts that take a project from **raw data and a research question** to **a brief for drafting Methods and Results**. Each prompt is one step of the research workflow and ends with a **checkpoint**, where Claude stops and the researcher decides.

| Step | Prompt | Claude produces | The researcher decides |
|---|---|---|---|
| 01 | `01_data_audit.md` | `code/0000_import.Rmd`, `writing/data_audit.md` | How to fix each data issue |
| 02 | `02_data_cleaning.md` | `code/1000`-series scripts, `data_clean/*.rds`, cleaning log | Whether the cleaned data look right |
| 03 | `03_empirical_strategy.md` | `writing/analysis_plan.md` with candidate designs | **Which design to use** |
| 04 | `04_analysis.md` | `code/2000`- and `3000`-series scripts, `outputs/` | Whether the results are plausible |
| 05 | `05_manuscript_brief.md` | `writing/manuscript_brief.md` | Framing, interpretation, claims |

## How to run them

1. Open a terminal in the project folder (the one containing `CLAUDE.md`) and start Claude Code: `claude`.
2. Type `Follow @prompts/01_data_audit.md`. The `@` attaches the file to your message.
3. Read what Claude reports at the checkpoint, answer its questions, then move to the next prompt.
4. For step 03, switch to **plan mode** first (Shift+Tab in the terminal; Cmd+Shift+M / Ctrl+Shift+M in the desktop app). Claude can still read and explore, but cannot edit files, so it proposes a design instead of building one.

## Why this structure

- **Standing rules live in `CLAUDE.md`; step instructions live here.** The prompts stay short and reusable because everything project-specific (research question, study definitions, conventions) is in `CLAUDE.md`.
- **Checkpoints keep the researcher in charge.** Claude does the connective work — reading files, writing and running code, organizing results — and stops wherever a research judgment is needed.
- **Every step leaves a file.** The audit, the plan, the scripts, and the brief together are the record of what was done and why, which is what makes AI-assisted work auditable.

## Use them on your own project

Copy `part2_setup/project_template/`, fill in its `CLAUDE.md` (see `../CLAUDE.md` for a completed example), put your files in `data_raw/`, and copy this `prompts/` folder in. The prompts do not mention the St. Louis study, so they work as written; edit them wherever your field or data differ.
