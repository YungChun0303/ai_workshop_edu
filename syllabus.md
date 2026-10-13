# AI-Empowered Research: Practical Workflows with Claude CLI, R, and Modern Tools for Social Science & Education Researchers

**Workshop Syllabus**

| **Date** | Friday, 2026-10-16 |
|---|---|
| **Time** | 9:00–11:30 AM (150 minutes, including a 10-minute break) |
| **Location** | Hillman Hall, Room 130, Washington University in St. Louis |
| **Host** | CERP³ |
| **Instructor** | Yung Chun, PhD — Research Assistant Professor, Brown School; Director of Data, CERP³ ([profile](https://brownschool.washu.edu/faculty-and-research/yung-chun/)) |
| **Contact** | yungchun@wustl.edu |
| **Audience** | PhD students and junior faculty |
| **Prerequisites** | Working familiarity with R (or Stata). No prior terminal experience required. |
| **Materials** | [github.com/YungChun0303/ai_workshop_edu](https://github.com/YungChun0303/ai_workshop_edu) |

---

## 1. Workshop Description

Most researchers meet AI through a browser tab: paste a chunk of code, read a plausible answer, paste it back, and hope the model remembered what the variables meant. That loop is fast for a single question and quietly corrosive for a research program — it breaks reproducibility, strands project context in a chat window, and tempts researchers to move sensitive data into places their IRB never approved.

This workshop demonstrates a different mode of working. **Agentic tools such as Claude CLI (Claude Code) operate inside your project directory**: the agent reads your data dictionary, writes an `.Rmd` script to disk, runs it, inspects the errors, and fixes them, while your raw data stays on your machine. Project conventions live in a `CLAUDE.md` file, so the agent inherits your standards every session instead of relearning them in every chat.

We pair that with **Google Gemini**, which WashU provides to everyone at no cost, for literature work and large-corpus reading, and walk an end-to-end research workflow on a **synthetic dataset** modeled on a real education-policy study. The session closes with the question the tools cannot answer for you: what remains yours to own when a machine can produce a correct, well-cited paper.

The goal is not "AI writes my paper." The goal is a **research pipeline where the tedious, error-prone connective tissue is automated and auditable**, so more of your attention goes to design, identification, and interpretation.

## 2. Learning Objectives

By the end of this session, participants will be able to:

1. **Distinguish agentic AI from conversational chatbots**, and explain why directory-aware tooling changes the reproducibility and data-privacy calculus for empirical research.
2. **Choose the right tool for the task**, routing literature landscaping and large-corpus reading to Gemini and reserving Claude CLI for work that touches the file system.
3. **Install Claude CLI alongside R and RStudio** and build a standardized research directory with immutable `data_raw/`, generated `data_clean/`, and a 4-digit `code/` hierarchy.
4. **Author a `CLAUDE.md` project-memory file** that encodes naming conventions, output rules, and analysis standards.
5. **Run an end-to-end empirical workflow** — folder setup, data cleaning, analysis (including synthetic control and staggered difference-in-differences), and a first draft of Methods and Results — through agentic execution.
6. **Apply concrete ethical and data-security limits**: match each dataset to an approved AI workspace, recognize the red lines AI must not cross, and state plainly what you did and what the machine did.

---

## 3. Schedule at a Glance

| Time | Part | Focus |
|---|---|---|
| 9:00–9:25 | **Part 1 · The AI Research Landscape** | Agents vs. chatbots; the AI landscape and WashU's AI tools; how not to drown in AI |
| 9:25–10:10 | **Part 2 · Setup: Claude CLI, R & the Project Folder** | Installation, folder structure, and `CLAUDE.md` |
| 10:10–10:20 | *Break* | |
| 10:20–11:05 | **Part 3 · Live Workflow: An Education-Policy Study** | Folder → cleaning → analysis → Methods/Results draft, on synthetic data |
| 11:05–11:25 | **Part 4 · Ethics: The Suit Is Not the Scientist** | Understanding vs. responsibility; disclosure; data tiers; red lines |
| 11:25–11:30 | **Q&A** | |

---

## 4. Session Details

### Part 1 · The AI Research Landscape (9:00–9:25, 25 min)

**Goals.** Build a working map of AI tools for research and a decision rule for which one to reach for.

**Topics.**
- **What makes an agent different from a chatbot.** A chatbot answers in a window; an agent reads, writes, and executes files inside your project — and leaves an auditable trail.
- **The landscape.** What recent surveys and studies say about how researchers, and social scientists in particular, use generative AI — where it helps and where it fails.
- **Platform, model, surface.** The AI platforms WashU provides (Gemini, Copilot Chat, Ask WashU, Claude Edu and Claude Secure, ChatGPT Edu) and which data each is approved for (see §6); model tiers and what they cost; and the surfaces for working with Claude — chat, Claude CLI in the terminal, Claude Code in the desktop app, and Cowork.
- **Division of labor.** Gemini (free through WashU) for literature landscaping, multi-PDF synthesis, and drafting prompts and specs; Claude CLI for anything that touches the file system.
- **Don't drown in it.** Learn the workflow, not the news cycle: choose models by task, and share what works in a community rather than following AI feeds.

**Materials.** `part1_ai_landscape/` (slides).

### Part 2 · Setup: Claude CLI, R & the Project Folder (9:25–10:10, 45 min)

**Goals.** Leave with a working installation and a project folder an agent can navigate.

**Topics.**
- Installing Claude CLI on macOS and Windows with the native installer; verifying the install; connecting Claude to a live R session with Posit's `mcptools`.
- **Project folder structure:** immutable `data_raw/`, generated `data_clean/`, a 4-digit `code/` hierarchy (`0000` import, `1000` cleaning, `2000` descriptives, `3000+` models), and separate `outputs/` for figures and tables.
- **Why `CLAUDE.md` matters.** It is the project's memory: conventions, data rules, and analysis standards the agent reads at the start of every session. A good `CLAUDE.md` is the difference between an agent that guesses and one that follows your lab's rules.

**Activity.** Create the project folder from the template and write your first `CLAUDE.md`, live.

**Materials.** `part2_setup/project_template/` (folder skeleton and starter `CLAUDE.md`); the handout [*Writing a Good `CLAUDE.md`*](part2_setup/claude_md_guide.md); the setup guides for [macOS](part2_setup/setup_guides/setup_guide_macos.md) and [Windows](part2_setup/setup_guides/setup_guide_windows.md).

### Break (10:10–10:20, 10 min)

### Part 3 · Live Workflow: An Education-Policy Study (10:20–11:05, 45 min)

**Goals.** See how a researcher goes from **raw data and a research question** to **a brief for drafting Methods and Results**, using Claude Code and a short sequence of reusable prompts. The focus is the workflow and the researcher's decisions along the way, not the findings.

**Context.** The demonstration mirrors the workflow of a funded multi-site study of school mobility and neighborhood-level interventions in St. Louis. **The real data cannot be shared.** All demonstrations use a **synthetic mock-up dataset** that reproduces the study's structure (a student-by-year panel with staggered treatment timing, plus a neighborhood-level panel) and contains no real student records. The results are hypothetical.

**Five steps, one prompt each.** The project starts with only raw data, a codebook, and a `CLAUDE.md` stating the research question. Each prompt ends at a checkpoint where the researcher decides.
1. **Data audit** — the agent inventories the raw files, finds data problems, and proposes fixes; the researcher approves them.
2. **Data cleaning and management** — the agent writes and runs `1000`-series scripts that save only to `data_clean/`, with a cleaning log; `data_raw/` is never modified.
3. **Empirical strategy** — in plan mode, the agent proposes candidate designs with their assumptions and threats; the researcher chooses (here, synthetic control for the neighborhood and a staggered difference-in-differences model in the Callaway & Sant'Anna framework for students).
4. **Analysis** — descriptive statistics and figures (`2000` series), the chosen models (`3000` series), diagnostics, and a plausibility check against what we know about the data.
5. **Manuscript brief** — the agent organizes the actual outputs into a brief for drafting Methods and Results; we review what it got right, what it overstated, and what only the researcher can decide.

**Activity.** Follow along on your laptop with the mock dataset, or watch and annotate.

**Materials.** `part3_live_workflow/` — a complete project folder: `CLAUDE.md` for the case, `prompts/` (the five prompts, reusable on your own project), `data_raw/` (synthetic data and codebook), and `answer_key/` (finished scripts and results for reference after the workshop).

### Part 4 · Ethics: The Suit Is Not the Scientist (11:05–11:25, 20 min)

**Goals.** Move from "who wrote this?" to "who answers for this?" — and leave with concrete rules.

**Topics.**
- **The argument.** If a machine can produce an accurate, novel, well-cited paper, the written artifact no longer certifies the author's understanding. What institutions can still demand is *responsibility*: a person who answers for the claim.
- **Making responsibility explicit.** Contribution statements that say plainly what the author did and what the machine did; when AI use requires disclosure in a manuscript.
- **Data-sensitivity tiers.** Matching each dataset to the workspace approved for it.
- **Red lines.**
  - No PHI in Claude Code, Claude Edu, or any browser AI — PHI belongs only in Claude Secure.
  - No citations you have not personally opened and verified.
  - No AI-only qualitative coding.
  - No uploading manuscripts you are peer-reviewing.
  - No credentials or secrets committed to a repository.

**Materials.** [*The Suit Is Not the Scientist*](https://yungchun.substack.com/p/the-suit-is-not-the-scientist) (op-ed, 2026-09-25; link in `part4_ethics/article/`).

### Q&A (11:25–11:30, 5 min)

Bring questions about your own projects.

---

## 5. Before the Workshop

Please complete these steps **before Friday, 2026-10-16.** Full instructions are in the setup guides for [macOS](part2_setup/setup_guides/setup_guide_macos.md) and [Windows](part2_setup/setup_guides/setup_guide_windows.md).

- [ ] **Install R and RStudio** (current versions).
- [ ] **Get Claude access.** Either Claude Edu through WashU (see §6) or a personal Claude Pro/Max subscription. Claude Code is *not* included in Claude Secure. **Students:** confirm with WashU IT that your free Claude Edu seat includes Claude Code.
- [ ] **Install Claude Code with the native installer.**
  - macOS: `curl -fsSL https://claude.ai/install.sh | bash`
  - Windows (PowerShell): `irm https://claude.ai/install.ps1 | iex`
- [ ] **Verify the install.** Run `claude --version`, then `claude doctor`, and sign in when prompted.
- [ ] **Clone or download the workshop repository** from [github.com/YungChun0303/ai_workshop_edu](https://github.com/YungChun0303/ai_workshop_edu).
- [ ] **Confirm you have admin rights** on your laptop to install software.

If anything fails, bring the error message — troubleshooting installs is part of Part 2.

**Bring de-identified data only.** Do not bring identifiable participant data, PHI, or FERPA-protected records to the workshop. A small de-identified dataset from your own work is welcome; the techniques land harder on data you care about.

---

## 6. AI Access at WashU

| Platform | Who | Cost | Agentic coding tool? | Approved data |
|---|---|---|---|---|
| **Google Gemini** (Gemini for Education; includes Gemini Notebook, formerly NotebookLM) | Students, faculty, staff | Free | — | FERPA-protected data. PHI: WashU's pages are inconsistent — confirm with the HIPAA Privacy Office before use |
| **Microsoft Copilot Chat** | Everyone with Microsoft 365 | Free | — | FERPA-protected data. Not PHI |
| **Ask WashU** (WashU's own multi-model chatbot) | Students, faculty, staff | Free | — | PHI and FERPA-protected data |
| **Claude Edu** (Chat, Cowork, Claude Code, Design) | Faculty & staff; Danforth students (free after the *AI Literacy* Canvas module) | Free for eligible students; $16/mo (Standard) or $50/mo (Premium) for faculty & staff | **Yes — Claude Code.** Students: confirm with WashU IT that your seat includes it | FERPA-protected data and institutional IP. **Not approved for PHI** |
| **Claude Secure** | Faculty & staff | $16/mo (Standard) or $50/mo (Premium) | **No** | PHI and FERPA-protected data |
| **ChatGPT Edu** | Faculty & staff | $10–$100/mo, by tier | Codex, after a separate responsible-use form. **Codex is not approved for HIPAA or FERPA data** | Chat: PHI and FERPA-protected data |

**Sign-in:** claude.ai → WashU email → *Continue with SSO* → WashU Key. Confirm the workspace label in the lower-left sidebar. Claude Edu is limited to university teaching and research; personal use is prohibited. Faculty and staff subscriptions are requested through ServiceNow.

**No agentic coding tool at WashU is approved for PHI.** Claude Code is not approved for PHI, Codex is not approved for HIPAA or FERPA data, and GitHub Copilot is not approved for PHI.

Sources: [ai.washu.edu/tools](https://ai.washu.edu/tools), [it.washu.edu/claude-for-education](https://it.washu.edu/claude-for-education/#workspaces), [it.washu.edu/openai](https://it.washu.edu/openai) (accessed 2026-10-12). Check these pages for current pricing, eligibility, and data approvals.

---

## 7. Tool Stack

| Layer | Tool | Role |
|---|---|---|
| Execution agent | **Claude CLI (Claude Code)** | Reads, writes, and executes inside your project directory |
| Research agent | **Google Gemini** (free through WashU) | Literature landscaping, long-context PDF synthesis, prompt and spec drafting |
| Statistical engine | **R + RStudio** | Where the analysis actually runs |
| Terminal | **Warp** or the built-in terminal | Reviewable session history for long agent runs |
| Writing & notes | **Obsidian** or **Typora** | Live Markdown for drafts and memos |
| Sharing | **GitHub** | Distribution of all workshop materials |

---

## 8. Readings (Optional)

**Core reading**

- Chun, Y. (2026, September 25). [*The Suit Is Not the Scientist*](https://yungchun.substack.com/p/the-suit-is-not-the-scientist) [Op-ed]. *Substack.* Link also in `part4_ethics/article/`.

**Setup guides (read before Part 2)**

- Chun, Y. (2026). [*A Comprehensive Guide to Claude Code & MCP for Data Analysis on macOS*](part2_setup/setup_guides/setup_guide_macos.md). Installation, RStudio and VS Code integration, and MCP configuration.
- Chun, Y. (2026). [*A Comprehensive Guide to Claude Code & MCP for Data Analysis on Windows*](part2_setup/setup_guides/setup_guide_windows.md). Native Windows installation (WSL2 optional), RStudio and VS Code integration, and MCP configuration.

**Works discussed in Part 4**

- Fan, Y., Tang, L., Le, H., et al. (2025). Beware of metacognitive laziness: Effects of generative artificial intelligence on learning motivation, processes, and performance. *British Journal of Educational Technology, 56*(2), 489–530.
- Dawson, P., Bearman, M., Dollinger, M., & Boud, D. (2024). Validity matters more than cheating. *Assessment & Evaluation in Higher Education, 49*(7), 1005–1016.
- Hills, A. (2016). Understanding why. *Noûs, 50*(4), 661–688.
- Searle, J. R. (1980). Minds, brains, and programs. *Behavioral and Brain Sciences, 3*(3), 417–424.

---

## 9. Repository Contents

| Folder / File | Contents |
|---|---|
| `syllabus.md` | This document |
| `participant_cheatsheet.md` / `.pdf` | Two-page take-home: install, WashU access, R connection, project start, commands, ethics checklist |
| `part1_ai_landscape/` | Part 1 slides |
| `part2_setup/` | [macOS](part2_setup/setup_guides/setup_guide_macos.md) and [Windows](part2_setup/setup_guides/setup_guide_windows.md) setup guides; [`claude_md_guide.md`](part2_setup/claude_md_guide.md) (handout); `project_template/` (standard project folder with a starter `CLAUDE.md`); Part 2 slides |
| `part3_live_workflow/` | The demonstration project: case `CLAUDE.md`, `prompts/` (five reusable prompts), `data_raw/` (synthetic data and codebook, no real records), `answer_key/` (finished scripts and outputs); Part 3 slides |
| `part4_ethics/` | `article/` (*The Suit Is Not the Scientist*); `ai_use_disclosure_guide.md` (disclosure and data-security one-pager); Part 4 slides |

Slides and the article are added as they are finalized before the workshop.
