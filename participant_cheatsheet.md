---
title: "Claude CLI for Research: Cheat Sheet"
subtitle: "AI-Empowered Research · CERP³ · Washington University in St. Louis · 2026-10-16"
---

Commands come from the workshop setup guides (`part2_setup/setup_guides/` at github.com/YungChun0303/ai_workshop_edu), verified 2026-10-12.

## 1. Install and Verify

| | Command |
|---|---|
| **macOS** (Terminal) | `curl -fsSL https://claude.ai/install.sh \| bash` |
| **Windows** (PowerShell) | `irm https://claude.ai/install.ps1 \| iex` |
| **Windows** (Command Prompt) | `curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd` |
| **Verify, then sign in** | `claude --version` · `claude doctor` (read-only check) · `claude` (opens your browser) |

- **Windows:** `PS C:\...>` is PowerShell and `C:\...>` is Command Prompt. `'irm' is not recognized` means you're in Command Prompt. You don't need Administrator rights or WSL.
- **Not recognized** (`claude` or `Rscript`)? Open a new terminal. On Windows, add R's `bin` folder to your PATH (guide §2, Step 5). **Never delete `~/.local/bin/claude`**: that file is Claude Code.

## 2. WashU Access

- **Claude Edu** includes Claude Code. It is approved for FERPA data and institutional IP, **not PHI**.
- **Claude Secure** is approved for PHI and FERPA data, but has **no Claude Code**.
- **Sign in:** claude.ai → WashU email → *Continue with SSO*. **Students:** confirm your seat includes Claude Code (it.washu.edu/claude-for-education).

## 3. Connect R (optional)

1. In R, once: `install.packages("mcptools")`
2. In the terminal, once:

```bash
claude mcp add -s user r-mcptools -- Rscript -e "mcptools::mcp_server()"
```

3. In RStudio, to share your live session: `mcptools::mcp_session()`. To make it permanent, put `if (interactive()) mcptools::mcp_session()` in `.Rprofile`.
4. In Claude, type `/mcp` and look for **r-mcptools ✔ connected**.

## 4. Start a Project

1. Copy `part2_setup/project_template/` and rename it (lowercase, no spaces).
2. Fill in its `CLAUDE.md` (see `part2_setup/claude_md_guide.md`), and put your original files in `data_raw/`.
3. `cd` into the folder and run `claude`. For step-by-step prompts, copy in `part3_live_workflow/prompts/`.

```markdown
# CLAUDE.md — [project]   (minimal; the template has 9 sections)
- Question: [1–2 sentences]. Data: [sources, years]. Tier: [de-identified / FERPA]. PHI: stop.
- Never modify data_raw/. Only 1000-series scripts write to data_clean/.
- Scripts: code/NNNN_name.Rmd (0000 import · 1000 clean · 2000 describe · 3000 model).
- Paths with here::here(). Never print individual records; use counts.
- Never invent citations: write [CITATION NEEDED]. Ask before research decisions.
```

## 5. Essential Commands

| Command | What it does |
|---|---|
| `claude` | Start a session in this folder |
| `claude --continue` | Resume the last conversation here |
| `claude --resume` | Pick a past conversation |
| `/init` | Generate a starter `CLAUDE.md` |
| `/memory` | Edit the `CLAUDE.md` files in use |
| `/mcp` | Check connected tools |
| `/model` | Switch model |
| `/compact` | Summarize to free up context |
| `/clear` | Start fresh in the same folder |
| `/usage` | Plan limits and usage |
| **Shift+Tab** | Cycle modes: Auto (default) · Manual · Accept edits · Plan |
| **Esc** / **Esc Esc** | Stop / rewind |
| **Ctrl+L** | Redraw a confusing screen |

**Learning? Use Manual mode** (`claude --permission-mode default`). **Making a research-design decision? Use Plan mode**: Claude reads and proposes, but can't edit.

## 6. Two Engines

| **Gemini** (free through WashU) | **Claude CLI** |
|---|---|
| Literature, long PDFs, many sources | Anything that touches your files |
| First-pass synthesis and framing | Writing and running `.Rmd` scripts |
| Drafting a spec or `CLAUDE.md` text | Cleaning, analysis, pipelines, drafts in `writing/` |

**Handoff:** save Gemini's output as Markdown in `writing/`; Claude reads it from there.

## 7. Pocket Ethics Checklist

1. **Data tier:** public, de-identified, FERPA, PHI, or DUA-restricted?
2. **Workspace:** is it approved for that tier? **PHI never goes into Claude Code or any agentic tool.**
3. **Citations:** have I opened and verified every one?
4. **Disclosure:** did AI touch analysis, data, or results? Then say so in Methods: tool, version, date, what it did.
5. **Secrets:** no keys or passwords in `CLAUDE.md` or Git; keep them in `.Renviron`.

## 8. Resources

| | |
|---|---|
| **Free through WashU** | Gemini for Education · Copilot Chat (Microsoft 365) · Ask WashU |
| **Claude Edu** | Free for eligible Danforth students (after the *AI Literacy* module); faculty and staff $16 or $50 per month |
| **ChatGPT Edu** | Faculty and staff, $10–$100 per month. Codex needs separate approval and is not approved for HIPAA or FERPA data |
| **Personal Pro / Max** | Works, but carries no WashU data agreement: keep university data out |
| **Optional tools** | **Warp** (free; has its own AI agent, so just type `claude`) · **Typora** ($14.99) · **Obsidian** (free) |
| **Links** | code.claude.com/docs · ai.washu.edu/tools |

Prices and approvals checked 2026-10-12; they change often, so check the WashU pages.
