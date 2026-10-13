# AI-Empowered Research

**Practical workflows with Claude CLI, R, and modern tools for social science and education researchers.**

Materials for a 2.5-hour workshop hosted by CERP³ at Washington University in St. Louis: installation guides, a project template, a complete demonstration project on synthetic data, reusable prompts, slides, and take-home guides on disclosure and data security.

> **Workshop:** Friday, 2026-10-16, 9:00–11:30 AM · Hillman Hall, Room 130 · hosted by CERP³
> **Before you come:** install Claude Code and R, and confirm your Claude access. See [§5 of the syllabus](syllabus.md#5-before-the-workshop) and the setup guide for [macOS](part2_setup/setup_guides/setup_guide_macos.md) or [Windows](part2_setup/setup_guides/setup_guide_windows.md).

---

## What's Inside

| Part | Folder | What you'll find |
|---|---|---|
| **1 · The AI research landscape** | [`part1_ai_landscape/`](part1_ai_landscape/) | Slides: chat vs. agent, what WashU provides, choosing models by task |
| **2 · Setup: Claude CLI, R & the project folder** | [`part2_setup/`](part2_setup/) | Setup guides for [macOS](part2_setup/setup_guides/setup_guide_macos.md) and [Windows](part2_setup/setup_guides/setup_guide_windows.md); a [project template](part2_setup/project_template/) with a starter `CLAUDE.md`; the handout [*Writing a Good `CLAUDE.md`*](part2_setup/claude_md_guide.md); slides |
| **3 · Live workflow: an education-policy study** | [`part3_live_workflow/`](part3_live_workflow/) | A complete project on **synthetic** data: case `CLAUDE.md`, five [step prompts](part3_live_workflow/prompts/) (audit → cleaning → strategy → analysis → brief), raw data and codebook, an answer key, slides |
| **4 · Ethics: The Suit Is Not the Scientist** | [`part4_ethics/`](part4_ethics/) | The [op-ed](part4_ethics/article/), the [AI-use disclosure one-pager](part4_ethics/ai_use_disclosure_guide.md), slides |

Also at the top level: the [syllabus](syllabus.md) and a two-page [cheat sheet](participant_cheatsheet.md) ([PDF](participant_cheatsheet.pdf)).

## Start Here

**Attending the workshop?** Read the [syllabus](syllabus.md), complete its pre-workshop checklist, and keep the [cheat sheet](participant_cheatsheet.pdf) handy.

**Working through it on your own?**

1. Install and verify Claude Code with the setup guide for [macOS](part2_setup/setup_guides/setup_guide_macos.md) or [Windows](part2_setup/setup_guides/setup_guide_windows.md).
2. Read [*Writing a Good `CLAUDE.md`*](part2_setup/claude_md_guide.md).
3. Open `part3_live_workflow/` in a terminal, start Claude Code with `claude --permission-mode default`, and run the five prompts in order: `Follow @prompts/01_data_audit.md`, and so on. Each one stops at a checkpoint for your decision.
4. Compare your results with `part3_live_workflow/answer_key/` **after** you finish. Before you start, move `answer_key/` (and `slides/`, which shows its results) out of the folder, so the agent works only from the raw data, as in the live demo.
5. Read Part 4 before you use any of this on real data.

**Using it on your own project?** Copy [`part2_setup/project_template/`](part2_setup/project_template/), fill in its `CLAUDE.md`, put your files in `data_raw/`, and copy in [`part3_live_workflow/prompts/`](part3_live_workflow/prompts/). The prompts don't mention the case study, so they work as written.

## Requirements

- **Claude access that includes Claude Code:** WashU Claude Edu (students: confirm your seat includes Claude Code), or a personal Claude Pro or Max plan. WashU's Claude Secure does **not** include Claude Code.
- **R 4.x** and RStudio. Part 3 uses `tidyverse`, `here`, `knitr`, `rmarkdown`, `fixest`, `did`, and `tidysynth`.
- **Optional:** Posit's `mcptools` (connects Claude to a live R session), VS Code, Warp, Typora, Obsidian. See the setup guides.

## About the Data

**Every record in this repository is synthetic.** The Part 3 data mimic the structure of state education records and Census ZIP-level estimates. No real student, school, or district data were used. ZIP codes are real St. Louis-area ZIPs so maps work, but every attribute attached to them is simulated. The program studied (CNI) is fictional and **the results are hypothetical**.

To regenerate the data and the answer key (seeded, so results are identical), run from `part3_live_workflow/`:

```bash
Rscript answer_key/generate_mock_data.R
```

Then knit `answer_key/code/` in numeric order (`0000` → `3100`). Knitted HTML files are not tracked in Git.

**In your own projects, never commit research data.** The project template's `.gitignore` keeps `data_raw/`, `data_clean/`, and `.Renviron` out of Git. This repository publishes `data_raw/` only because it is synthetic.

## Data Security in Brief

- **No PHI in Claude Code or any agentic tool.** At WashU, PHI belongs only in a PHI-approved workspace (for Claude, Claude Secure).
- Match every dataset to a workspace approved for it, and check your data use agreement first.
- WashU tool approvals and prices in these materials were checked on 2026-10-12. Confirm them at [ai.washu.edu/tools](https://ai.washu.edu/tools) and [it.washu.edu/claude-for-education](https://it.washu.edu/claude-for-education/) before relying on them.

Details: Part 4 and the [disclosure one-pager](part4_ethics/ai_use_disclosure_guide.md).

## How These Materials Were Made

In keeping with Part 4: these materials were developed with substantial assistance from Claude Code (Anthropic), working under a project `CLAUDE.md` and the author's direction. The author set the workshop design, the arguments, and the rules; answered the agent's design questions at each step; reviewed the outputs; and takes responsibility for the content. Claude drafted text, slides, scripts, and the synthetic data generator, and verified tool and policy facts against cited sources. The op-ed was written by the author.

## License

- **Materials** (guides, handouts, slides, syllabus, and the synthetic data): [Creative Commons Attribution 4.0 International (CC BY 4.0)](LICENSE). You may share and adapt them with attribution.
- **Code and reusable templates** (R scripts and R Markdown files, including `generate_mock_data.R`; the `prompts/` files; and the `project_template/` folder): [MIT License](LICENSE-CODE).
- **Not covered:** the Washington University name, logos, and presentation-template design used in the slides (trademarks of Washington University in St. Louis), and the op-ed itself, which is linked, not reproduced.

## How to Cite

> Chun, Y. (2026). *AI-Empowered Research: Practical workflows with Claude CLI, R, and modern tools for social science and education researchers* [Workshop materials]. CERP³, Washington University in St. Louis. https://github.com/YungChun0303/ai_workshop_edu

## Contact

Questions, corrections, or a broken command: open a [GitHub Issue](https://github.com/YungChun0303/ai_workshop_edu/issues) or email Yung Chun at yungchun@wustl.edu.
