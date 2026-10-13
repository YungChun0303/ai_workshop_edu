# Writing a Good `CLAUDE.md`

**AI-Empowered Research workshop · Part 2 handout** · CERP³, Washington University in St. Louis · 2026-10-16

Facts about how Claude Code loads memory files come from Anthropic's documentation, accessed 2026-10-12: [Memory](https://code.claude.com/docs/en/memory) and [Best practices](https://code.claude.com/docs/en/best-practices). Claude Code changes often, so check those pages if something here behaves differently.

---

## 1. What `CLAUDE.md` Is

`CLAUDE.md` is a plain Markdown file that Claude Code reads at the start of every session. Whatever you write there becomes a standing instruction, so you don't have to repeat yourself: the research question, where the data live, how scripts are named, what the agent must never do.

Two things to understand from the start:

- **It is context, not a lock.** Anthropic describes `CLAUDE.md` as "context, not enforced configuration." Claude follows clear, specific rules very consistently, but a rule in `CLAUDE.md` isn't a technical barrier. For things that must never happen (committing data, for example), back the rule with a real control such as `.gitignore`.
- **Files add up; they don't replace each other.** If several `CLAUDE.md` files apply, Claude reads all of them, from the broadest (your user file) to the most specific (the project folder).

## 2. Where `CLAUDE.md` Files Live

| Level | Location | Use it for | Shared? |
|---|---|---|---|
| **User** | `~/.claude/CLAUDE.md` (Windows: `%USERPROFILE%\.claude\CLAUDE.md`) | Your personal working habits, in every project | No, only you |
| **Project** | `CLAUDE.md` in the project folder (or `.claude/CLAUDE.md`) | This project's question, data, folders, and rules | Yes, if the project is shared |
| **Local** | `CLAUDE.local.md` in the project folder | Personal notes for one project; add it to `.gitignore` | No |
| **Subfolder** | `CLAUDE.md` inside a subfolder (e.g., `code/`) | Rules for that part of the project; loaded when Claude works there | With the project |
| Organization | Set by an administrator | Institution-wide policy; you can't turn it off | Everyone |

For this workshop you need the first two: **one user file for you, one project file per project.**

## 3. The Two Levels in Practice

**The user file is about *how you work*.** It applies everywhere, so it holds only things that are true in every project: how you want to be asked, how you like files formatted, what kind of researcher you are.

**The project file is about *this study*.** The research question, the folder contract, the data rules, the analysis standards. Anyone who opens the project, or any agent, should be able to read it and understand how the work is done.

### A user-level example: the Task Clarification Protocol

This is the user-level `CLAUDE.md` of the workshop's instructor. It is short and it does one job well: it makes Claude ask before it guesses.

```markdown
# Global Rules
## Task Clarification Protocol
Before starting or executing any task, script, or file edit provided by the user, evaluate if there are any ambiguous requirements, implementation choices, or architectural trade-offs.

If ambiguities or multiple logical approaches exist:
1. **STOP** and ask clarifying questions first before executing code or modifying files.
2. Format your questions clearly using **Numbered Multiple-Choice Options** so the user can select them easily.

### Formatting Requirements for Questions:
- Present each missing detail as a distinct question.
- Provide 2–4 concrete options per question labeled `[1]`, `[2]`, `[3]`, etc.
- Always include a `[Recommended]` tag next to your suggested default path.
- End your response with a simple instruction like: *"Reply with the numbers corresponding to your choices (e.g., 1A, 2B) or type a custom preference."*

Do NOT proceed with execution until the user confirms their selection.

## Markdown Format Rules
- **No Hard Wrapping**: Never insert hard line breaks/newlines within paragraphs when outputting Markdown content or generating `.md` files.
- Allow lines to extend naturally on a single line so soft-wrapping in editors (like VS Code, RStudio, or Obsidian) handles line breaks dynamically.
```

Why it works:

- **The more the agent asks, the better the output.** An agent that guesses fills every gap with the most common choice, which is often not yours. An agent that asks turns hidden decisions (which file? which estimator? overwrite or new version?) into choices you make on purpose.
- **Multiple-choice questions are fast to answer.** "1A, 2B, 3A" takes five seconds. The `[Recommended]` tag tells you which option the agent would pick, so you can accept it or overrule it.
- **It matches research practice.** Decisions about data and design belong to the researcher. This rule keeps them there, which is the same principle as the checkpoints in Part 3.
- **It belongs at the user level.** It describes how *you* want to work, so it should follow you into every project instead of being copied into each one.

## 4. Anatomy of a Project `CLAUDE.md`

The starter file in `project_template/CLAUDE.md` has nine sections. A completed example is in `part3_live_workflow/CLAUDE.md`.

| Section | What goes in it | Why the agent needs it |
|---|---|---|
| 1. Project overview | Title, research question, design, unit of analysis, data sources, IRB status | So it knows what the work is *for*, and what it should not decide on its own |
| 2. Folder contract | The folder tree and rules (`data_raw/` is read-only; outputs go to `outputs/`) | Predictable places mean fewer guesses and no overwritten files |
| 3. Script naming | The 4-digit rule: `0000` import, `1000` cleaning, `2000` descriptives, `3000+` models | Scripts land in order; new steps fit between old ones |
| 4. R conventions | `here::here()` paths, preferred packages, `.rds` output, chunk options, "knit before reporting" | Code that runs on any machine, in your house style |
| 5. Data security | Data classification, "never print individual records," small-cell rule, no secrets | The habits that keep protected data protected |
| 6. Analysis standards | Key variables, primary specification, robustness checks | It doesn't quietly swap your model for another one |
| 7. Writing guidelines | Tone, banned phrases, "every number cites an output file," "never invent citations" | Drafts you can verify |
| 8. Working agreement | When to ask, when to choose, what to log | Where the line is between its judgment and yours |
| 9. Project log | Dated entries of what changed | The next session (or the next person) starts where this one stopped |

## 5. Weak Rules and Strong Rules

Anthropic's advice is to write instructions "concrete enough to verify." A good test: **could you check whether the agent followed this rule?**

| Weak (vague) | Strong (specific, checkable) |
|---|---|
| Write clean code. | Name scripts `NNNN_description.Rmd` in lowercase `snake_case`, e.g., `1000_clean_enrollment.Rmd`. |
| Be careful with the data. | Never create, modify, rename, or delete anything in `data_raw/`. |
| Protect student privacy. | Never print individual-level records. Use `glimpse()`, `summary()`, and counts instead of `head()` or `View()`. |
| Use good file paths. | Build every path with `here::here()`; never hard-code `C:/Users/...` or `/Users/...`. |
| Cite your sources. | Never invent citations. Write `[CITATION NEEDED]` and leave it for the researcher. |
| Don't change my analysis. | Do not change the primary specification without asking. Propose alternatives; don't swap them in. |
| Make sure it works. | After writing or editing a script, knit it and fix errors before reporting back. |

## 6. What Never Goes in `CLAUDE.md`

- **Credentials of any kind:** passwords, API keys, tokens, database connection strings. Keep them in `.Renviron` (git-ignored) and read them with `Sys.getenv()`.
- **Identifiable data:** no names, IDs, or example records, not even "just one row to show the format." Describe the format instead.
- **Access instructions for restricted data** (server addresses, VPN steps). Write "see the data use agreement" instead.
- **Anything you wouldn't publish.** A project `CLAUDE.md` is often committed to Git and shared with collaborators.

## 7. Keep It Short

- **Under 200 lines per file**, Anthropic recommends: "Longer files consume more context and reduce adherence."
- **Cut test:** for each line, ask "Would removing this cause Claude to make mistakes? If not, cut it."
- **Remove contradictions.** If two rules disagree, Claude has to guess which one you meant.
- **Use headers and bullets.** Structure is easier to follow than long paragraphs.

## 8. How to Write and Maintain One

1. **Start from the template.** Copy `project_template/` and replace every `[bracketed placeholder]`. Alternatively, run `/init` inside Claude Code to generate a starter file from your folder, then edit it.
2. **Draft the hard parts in Gemini first.** WashU's Gemini is free to use. Paste in your project description and ask it to draft the research-question and analysis-standards sections, then refine the result inside the project with Claude. Don't paste data or credentials into either tool.
3. **Add a rule whenever you correct the agent twice.** If you've said "save that to `outputs/tables/`, not the root" two times, it belongs in `CLAUDE.md`. You can tell Claude directly: *"Add this to CLAUDE.md."*
4. **Check what loaded.** `/memory` lists and opens the memory files in use; `/context` shows what is taking up the agent's context.
5. **Keep the project log current.** Ask Claude to append a dated entry at the end of each session (template §9).

## 9. Live Activity Checklist (15 minutes)

Copy `part2_setup/project_template/` to a working location, open its `CLAUDE.md`, and fill in:

- [ ] **§1 Project overview:** your own study, or the Part 3 case if you don't have one yet. The research question in one or two sentences.
- [ ] **§1 Data sources and IRB:** names and years only. No access details.
- [ ] **§4 Packages:** edit the preferred list to match what you use.
- [ ] **§5 Data classification:** choose one tier. If the answer is *contains PHI*, stop: Claude Code isn't approved for PHI at WashU.
- [ ] **§5 Small-cell threshold:** set the number your data agreement requires.
- [ ] **§6 Primary specification:** write it down even if it's tentative.
- [ ] **One rule of your own:** something you've had to correct an AI tool on before, written as a strong rule (§5 of this handout).
- [ ] **Optional:** create `~/.claude/CLAUDE.md` with one personal habit, such as the clarification protocol above.
- [ ] **Test it:** run `claude` in the folder and ask *"Summarize the rules in CLAUDE.md that apply to data security."* If the summary is wrong, the rule isn't clear enough.
