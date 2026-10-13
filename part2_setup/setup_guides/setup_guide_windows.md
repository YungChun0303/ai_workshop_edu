# A Comprehensive Guide to Claude Code & MCP for Data Analysis on Windows

author: "Yung Chun"

date: "2026-07-30"

revised: "2026-10-12"

goal: This guide is the Windows companion to *A Comprehensive Guide to Claude Code & MCP for Data Analysis on macOS*. It covers the same ground — installing **Claude Code**, structuring a data analysis project, and wiring **MCP** into **RStudio**, **Visual Studio Code**, and **Obsidian** — but addresses the platform differences that actually bite: the native-vs-WSL decision, PATH and shell friction, backslash path handling in R, and cloud-synced folders.

> **The short version for the impatient:** Claude Code runs natively on Windows now. You do **not** need WSL unless you specifically want Linux toolchains or sandboxed command execution. Install Git for Windows anyway — it gives Claude a real Bash shell and removes an entire category of problems.

> **Revision note (2026-10-12).** Re-verified against the Claude Code docs (code.claude.com/docs), CRAN, and each tool's own site. Changes: WashU access note; Git for Windows link and WinGet command; R version and PATH (the R installer never adds R to PATH); the firewall step for `mcptools` removed (it uses local named pipes, not network ports); `mcp_session()` wrapped in `if (interactive())`; Zotero setup for Claude Code corrected; `uv` and `mcp-obsidian` requirements; project folder aligned with the workshop template; a new section on permission modes (auto mode is now the default); new section 9 on companion tools (Warp, Windows Terminal, Typora, Obsidian).

## 0. What is Claude Code and MCP?

- **Claude Code** is a command-line interface (CLI) tool and terminal-based assistant developed by Anthropic. It runs inside your local environment, executes commands, reads and writes files, and automates multi-step tasks.
- **Model Context Protocol (MCP)** is an open standard acting as a secure bridge between an AI assistant and external data sources or software. MCP "servers" expose databases, filesystems, APIs, or applications such as RStudio, Obsidian, and Zotero directly to Claude.

**Account requirement:** Claude Code requires a paid plan — Pro, Max, Team, Enterprise, or a Console (API) account. The free Claude.ai tier does not include Claude Code access.

> **At WashU:** Claude Code comes with the **Claude Edu** workspace (approved for FERPA data, **not PHI**). **Claude Secure does not include Claude Code.** WashU's page describes Claude Code for faculty and staff; students should confirm with WashU IT that their free seat includes it. Sign in at claude.ai with your WashU email → *Continue with SSO*. Details: https://it.washu.edu/claude-for-education/

## 1. Choosing Your Windows Setup

This is the one decision with no macOS equivalent, so make it deliberately before installing anything.

| Option | Requires | Sandboxing | Choose when |
|---|---|---|---|
| **Native Windows** | Nothing; Git for Windows optional but recommended | Not supported | Your R, Stata, and data live on Windows. **This is the right default for most researchers.** |
| **WSL 2** | WSL 2 enabled | Supported | You need Linux toolchains, or you want sandboxed command execution |
| **WSL 1** | WSL 1 enabled | Not supported | Only if WSL 2 is unavailable on your machine |

**Recommendation for social science researchers:** go native. Your RStudio installation, your Box or OneDrive folders, and your Stata license are all Windows-side. Running Claude in WSL means it operates across a filesystem boundary at `/mnt/c/`, which is slow and produces confusing path behavior. Choose WSL only if you have a specific reason.

> **If you do use WSL:** keep project folders inside the WSL filesystem (`~/projects/...`), not on `/mnt/c/`. Cross-boundary file access is dramatically slower and is the most common source of "why is this taking so long" complaints.

**System requirements:** Windows 10 version 1809+ or Windows Server 2019+, 4 GB+ RAM, x64 or ARM64.

## 2. Setting up Claude Code on Windows

### Step 1: Know which shell you are in

This trips people up constantly. Look at your prompt:

- `PS C:\Users\YourName>` — **PowerShell**
- `C:\Users\YourName>` — **Command Prompt (CMD)**

If you run a PowerShell command in CMD you get `'irm' is not recognized`. If you run a CMD command in PowerShell you get `The token '&&' is not a valid statement separator`. Neither error means anything is broken.

### Step 2: Install Claude Code

**PowerShell (recommended):**

```powershell
irm https://claude.ai/install.ps1 | iex
```

**Command Prompt:**

```batch
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

**Or via WinGet:**

```powershell
winget install Anthropic.ClaudeCode
```

You do **not** need to run as Administrator.

> **Auto-update behavior differs by method.** The native installer updates itself in the background. **WinGet installs do not** — run `winget upgrade Anthropic.ClaudeCode` periodically. WinGet upgrades can also fail while Claude Code is running, because Windows locks the running executable; close it first.

**If you are using WSL:** do not run the commands above from PowerShell. Open your WSL distribution and run the Linux installer inside it:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

### Step 3: Install Git for Windows (recommended)

[Git for Windows](https://git-scm.com/install/windows) is optional but worth installing immediately. Download the installer from that page, or use WinGet:

```powershell
winget install --id Git.Git -e --source winget
```

(The WinGet package is not maintained by the Git for Windows project itself and can lag the latest release slightly; either route is fine for this workshop.)

Git for Windows provides Git Bash, which lets Claude Code use its full **Bash tool**. Without it, Claude runs commands through its PowerShell tool — functional, but you will find that most R, pandoc, and shell examples you encounter online assume a POSIX shell.

If Claude Code cannot locate Git Bash after installation, point it there explicitly in `%USERPROFILE%\.claude\settings.json`:

```json
{
  "env": {
    "CLAUDE_CODE_GIT_BASH_PATH": "C:\\Program Files\\Git\\bin\\bash.exe"
  }
}
```

Note the **doubled backslashes** — JSON treats a single backslash as an escape character. This is the single most common Windows configuration error.

WSL users do not need Git for Windows.

### Step 4: Authenticate and Verify

```powershell
claude
```

Log in through the browser prompt. Then verify:

```powershell
claude --version     # prints e.g. 2.1.211 (Claude Code)
claude doctor        # read-only diagnostics
```

### Step 5: Make sure R is on your PATH

**This is a Windows-specific problem with no macOS counterpart.** The R for Windows installer does not put R on your PATH (CRAN's R for Windows FAQ: "The R installer does not put `Rcmd.exe` (nor any other R executable) on your `PATH`"), so Claude cannot run `Rscript` even though R is plainly installed.

Test it:

```powershell
Rscript --version
```

If you get `'Rscript' is not recognized`, add R to your PATH:

1. Press `Win`, type "environment variables," open **Edit the system environment variables**.
2. Click **Environment Variables** → select **Path** under *User variables* → **Edit** → **New**.
3. Add your R `bin` directory, typically `C:\Program Files\R\R-4.6.1\bin\x64` (substitute your actual version — check the folder names under `C:\Program Files\R\`). **When you upgrade R, update this entry**, because the version number is part of the path.
4. **Open a new terminal** — PATH changes do not affect already-running shells — and test again.

## 3. Structuring Your Project Folder for Data Analysis

A predictable layout minimizes context confusion. Claude scans your workspace to find datasets and scripts; structure keeps it from reading caches and temp files.

The workshop's project template (`part2_setup/project_template/` in the workshop repository) uses this layout:

```
my_analysis_project/
├── CLAUDE.md               # Project memory: rules and context Claude reads every session
├── README.md               # Human-facing overview
├── data_raw/               # IMMUTABLE original data (.csv, .dta), exactly as received
├── data_clean/             # Generated only by code/1000-series scripts
├── code/
│   ├── 0000_import.Rmd     # 0000–0999 import
│   ├── 1000_clean.Rmd      # 1000–1999 cleaning → data_clean/
│   ├── 2000_descriptives.Rmd  # 2000–2999 descriptives → outputs/
│   └── 3000_model.Rmd      # 3000+ models → outputs/
├── outputs/
│   ├── figures/            # .png / .pdf
│   └── tables/             # .csv / .tex / .html
├── writing/                # Markdown drafts (Typora / Obsidian)
└── my_analysis_project.Rproj  # RStudio Project file (here::here() root)
```

The 4-digit scheme lets you insert `1500_merge_waves.Rmd` between existing steps without renumbering downstream files.

### Two Windows-specific placement warnings

**Avoid deep paths.** Some R packages and LaTeX toolchains still break past the legacy 260-character path limit. A project at `C:\Users\yourname\Box\1_department\2_project\...\my-analysis-project\` can exceed it once nested output files are generated. Keep projects closer to the drive root — `C:\research\project-name\` — if you hit unexplained "file not found" errors on files that visibly exist.

**Be careful with synced cloud folders.** Box Drive, OneDrive, and Dropbox place projects behind a sync layer. Two failure modes matter:

- **File locks.** The sync client may hold a file open while R tries to write it, producing intermittent permission errors that vanish on retry.
- **On-demand placeholders.** Files shown in Explorer may not actually be on disk. Claude reads a 0-byte stub and concludes your dataset is empty. Right-click the project folder and select **Always keep on this device**.

Neither is a reason to abandon cloud sync — the versioning is genuinely valuable for research data — but when something inexplicable happens, check this first.

### Configuring `CLAUDE.md`

Create `CLAUDE.md` in your project root. Claude Code reads it at the start of every session. Start from the workshop template (`project_template/CLAUDE.md`), or run `/init` inside Claude Code to generate a starter file, then edit it. Use `/memory` to open the memory files in use. The workshop handout `part2_setup/claude_md_guide.md` covers user-level vs. project-level files and how to write rules that work. A minimal example:

```markdown
# Project Configuration

## Response & Writing Guidelines
- Maintain an objective, academic prose style.
- Banned AI-isms: "delve", "testament", "tapestry", "moreover", "foster".
- Never output conversational fluff like "Here is your code:".

## Data Analysis Prescriptions
- Use the `fixest` library (`feols()`) for high-dimensional fixed effects and Sun & Abraham (2021) event studies to conserve memory.
- Always append `gc()` after dropping heavy temporary dataframes.

## Windows Path Rules
- Never hard-code absolute paths like "C:/Users/name/project/data/file.csv".
- Always construct paths with here::here("data_raw", "file.csv").
- Use forward slashes or here::here() — never bare backslashes in R strings.
```

That last block matters more than it looks. Without it, an agent will cheerfully write `read_csv("C:\Users\me\data\file.csv")`, where `\U` is an invalid escape and R fails with a message that explains nothing to a non-programmer.

## 4. Integrating Claude with Your Tools & IDEs

### 4a. Controlling and Optimizing RStudio (`mcptools`)

Use **`mcptools`**, maintained by Posit and available on CRAN. (The older community package `zygi/rstudiomcp` still works but is unofficial and no longer actively maintained.)

#### **Step 1: Install in R**

```r
install.packages("mcptools")
```

#### **Step 2: Register it with Claude Code**

From PowerShell:

```powershell
claude mcp add -s user r-mcptools -- Rscript -e "mcptools::mcp_server()"
```

If this fails with a "command not found" error for `Rscript`, revisit Step 5 in Section 2 — R is not on your PATH. Alternatively, as the `mcptools` documentation suggests for Windows, give the full path to `Rscript.exe` (substitute your R version):

```powershell
claude mcp add -s user r-mcptools -- "C:\Program Files\R\R-4.6.1\bin\Rscript.exe" -e "mcptools::mcp_server()"
```

#### **Step 3: Connect your live R session**

By default the server runs in its own headless R process and cannot see your RStudio environment. To expose your **live** session, run in the RStudio console:

```r
mcptools::mcp_session()
```

To make it permanent, put the call in your `.Rprofile`. Open the file with:

```r
usethis::edit_r_profile()
```

and add this line (the `if (interactive())` wrapper keeps the background `Rscript` runs that Claude starts from registering as sessions):

```r
if (interactive()) mcptools::mcp_session()
```

#### **Step 4: Verify**

Launch `claude` in your project directory and type **`/mcp`**. The server should show as connected. Then try: *"Look at the data frame currently in my environment and identify why the weights are returning NA values."*

### 4b. Connecting and Configuring Visual Studio Code

Anthropic ships an official VS Code extension that authenticates with your existing subscription — **no API key required**.

1. **Install:** Extensions view (`Ctrl+Shift+X`), search **"Claude Code"**, install the one published by Anthropic (`anthropic.claude-code`). Requires VS Code 1.94.0+.
2. **Sign in:** Open the panel via the Spark icon in the editor toolbar, Activity Bar, or status bar. Authorize in the browser. Pro, Max, Team, Enterprise, and Console accounts all work.
3. **What you get:** side-by-side diffs with per-edit approval, plan review before Claude acts, `@`-mentions with line ranges (`Alt+K` references your current selection), tabbed parallel conversations, session history, and checkpoints for rewinding edits. Cursor has its own install link on the extension's docs page; other VS Code forks install it from the Open VSX registry.
4. **The extension does not put `claude` on your PATH.** It bundles a private copy for the chat panel. To run `claude` in the integrated terminal you still need the standalone install from Section 2.

**WSL note:** if your project lives in WSL, install the **WSL extension** and open the folder with **WSL: Connect to WSL**. Run the Claude Code extension from inside that remote window so it sees the Linux filesystem rather than the Windows one.

## 5. Maximizing the Setup with Secondary Materials

### 5a. Obsidian

The **Local REST API** community plugin ships a built-in MCP server — no separate package needed.

1. **Install the plugin:** Obsidian → **Settings > Community Plugins > Browse** → search **Local REST API** → install and enable.
2. **Copy the API key** from plugin settings.
3. **Register the server:**

```powershell
claude mcp add --transport http obsidian https://127.0.0.1:27124/mcp/ --scope user --header "Authorization: Bearer YOUR_API_KEY"
```

> **Most likely failure point:** the plugin serves HTTPS with a certificate from its own **locally issued certificate authority**, which Windows does not trust by default. Either import that certificate into your certificate store, or turn on **Settings → Local REST API → Enable HTTP server** (off by default) and use `http://127.0.0.1:27123/mcp/`. Loopback-only traffic makes plain HTTP acceptable on a personal machine.

*Fallback:* the community server `MarkusPfundstein/mcp-obsidian` (PyPI: `mcp-obsidian`, needs Python 3.11+), run via `uvx mcp-obsidian` with `OBSIDIAN_API_KEY` set. With the plugin's built-in server, most people won't need it.

**Power move:** *"Look at the regression results in outputs/tables/3000_main_estimates.csv, search my Obsidian vault for the 'Literature Review' note, and update the discussion section with the matching coefficients."*

### 5b. Zotero

1. **Enable Zotero's local API:** Requires **Zotero 7+**. In Zotero, go to **Settings → Advanced** and check **"Allow other applications on this computer to communicate with Zotero."** The local API is read-only.
2. **Install the server** — note the naming trap, the PyPI package is `zotero-mcp-server`, not `zotero-mcp`:

```powershell
uv tool install zotero-mcp-server
claude mcp add -s user zotero -e ZOTERO_LOCAL=true -- zotero-mcp
```

Requires Python 3.10+. `ZOTERO_LOCAL=true` tells the server to use Zotero's local API. The package's own `zotero-mcp setup` command configures **Claude Desktop** only; for Claude Code, register it with `claude mcp add` as above. Check with `/mcp` that it shows as connected. If you do not have `uv`, install it with `winget install --id=astral-sh.uv -e`.

> **Verify before relying on it:** full-text search across attachments has historically depended on Zotero build specifics. Confirm on your machine before building a workflow around it.

*Fallback that always works:* install **Better BibTeX** in Zotero, auto-export your collection into the project folder as `references.bib` with "Keep updated" enabled, and let Claude read the file directly. No server, no version drift.

### 5c. Local Git Automation

Claude Code has built-in git awareness — no MCP wrapper needed.

**One Windows-specific setting.** Windows uses CRLF line endings; most research tooling assumes LF. Without configuration, every file Claude touches can appear as fully rewritten in your diffs, making review impossible:

```powershell
git config --global core.autocrlf true
```

## 6. MCP Configuration Reference

Use the CLI rather than hand-editing config files — it validates as it writes and places entries in the correct scope.

```powershell
claude mcp add <name> --scope user -- npx -y <package>          # stdio server
claude mcp add --transport http <name> --scope user <url>       # HTTP server
claude mcp list                                                  # what's registered
```

The `--` separates Claude's own flags from the command it runs for the server.

| Scope | Available in | Shared with collaborators | Written to |
|---|---|---|---|
| `local` (default) | current project only | No | `%USERPROFILE%\.claude.json` |
| `project` | current project only | **Yes** — commit it | `.mcp.json` at project root |
| `user` | all your projects | No | `%USERPROFILE%\.claude.json` |

Precedence runs local > project > user. Entire server entries win or lose; individual fields are **not** merged.

**File roles**, which are easy to conflate:

- `%USERPROFILE%\.claude.json` — MCP servers at local and user scope. CLI-managed.
- `%USERPROFILE%\.claude\settings.json` — settings, permissions, hooks, environment variables. Shared between CLI and VS Code extension. **Does not hold MCP server definitions.**

**Workshop gotcha:** project-scoped servers in a committed `.mcp.json` require interactive approval on first use. Recipients of a shared repo see the server as pending until they launch `claude` and accept the trust prompt. `claude mcp reset-project-choices` resets those approvals.

## 7. Permission Modes: How Much Claude Does Without Asking

Claude Code has several permission modes. **Shift+Tab** cycles through them, and the current mode is shown at the bottom of the terminal.

| Mode | What Claude does | When to use it |
|---|---|---|
| **Auto** | Decides for itself which actions are safe to run without asking. Since v2.1.283 this is the default starting mode in the terminal and in VS Code, where available. | Routine work in a project you trust |
| **Manual** (`default`) | Asks before every file edit and command | Learning, sensitive projects, or when you want to watch every step |
| **Accept edits** | Edits files without asking; still asks before running commands | Long writing or refactoring runs |
| **Plan** | Reads and explores but **cannot edit or run anything**; proposes a plan | Research-design decisions; anything you want to approve before it happens |

You can also start in a mode directly, e.g. `claude --permission-mode plan`. **Esc** interrupts Claude at any point; pressing **Esc** twice opens the rewind menu. In the desktop app, Ctrl+Shift+M opens the mode menu. Source: https://code.claude.com/docs/en/permission-modes (accessed 2026-10-12).

## 8. Session and Cost Management

| Command | What it does |
|---|---|
| `claude` | Start an interactive session in the current directory |
| `claude --continue` | Resume the most recent conversation in this folder |
| `claude --resume` | Reopen a past conversation from a searchable picker |
| `claude doctor` | Diagnose install and settings problems |
| `claude update` | Apply an update immediately |
| `/mcp` | List MCP servers and connection status |
| `/init` | Generate a starter `CLAUDE.md` for this folder |
| `/memory` | Open and edit the `CLAUDE.md` files in use |
| `/context` | Show what is filling the context window, including which memory files loaded |
| `/compact` | Summarize the conversation to reclaim context |
| `/clear` | Wipe context and start fresh in the same directory |
| `/usage` | Show plan limits and what is consuming them (aliases: `/cost`, `/stats`) |
| `/model` | Switch model |

## 9. Companion Tools for Working with Claude Code

None of these are required. Everything in this guide works in **Windows Terminal** and RStudio. Prices and terms were checked on 2026-10-12.

| Tool | What it is for | Cost | Install |
|---|---|---|---|
| **Windows Terminal** | The recommended default terminal: tabs, PowerShell and Git Bash profiles, proper fonts | Free; built into Windows 11 (22H2+); Microsoft Store on Windows 10 | `winget install Microsoft.WindowsTerminal` |
| **Warp** | A modern terminal: tabs, blocks of output you can select and copy, easier text editing at the prompt | Free plan available; login optional ("Skip for now") | `winget install Warp.Warp` or https://www.warp.dev |
| **Typora** | A clean Markdown editor that shows formatted text as you type; good for reading and editing what Claude writes in `writing/` | $14.99 one-time license (up to 3 devices); 15-day free trial | `winget install appmakes.Typora` or https://typora.io |
| **Obsidian** | A Markdown notes app for a literature or project-notes "vault"; can connect to Claude via MCP (Section 5a) | Free, including for work use (optional commercial license) | `winget install Obsidian.Obsidian` or https://obsidian.md |

**Using Warp with Claude Code.**

- **Run `claude` at Warp's normal prompt.** Warp has been generally available on Windows since February 2025. It includes its own AI agent ("Warp Agent"), which is a different product from Claude Code. Type `claude` as usual; you don't need Warp's AI features for anything in the workshop.
- **Privacy.** Warp collects product analytics by default; you can turn this off under **Settings → Privacy**. On the Free plan, Warp's own AI features require telemetry to be on. Don't send research data to Warp's AI.
- **Known glitches.** Some users report duplicated output after clearing the screen while Claude Code is running. These are user reports, not confirmed by Anthropic. If something looks wrong, **Windows Terminal** is a perfectly good substitute for everything in this guide.

**Typora or Obsidian?** Both open plain `.md` files, so they work on the same project folder and nothing is locked in. Use Typora to read and edit one document at a time, like a word processor. Use Obsidian to manage many linked notes, such as a literature vault.

## 10. Windows Troubleshooting Quick Reference

| Symptom | Cause | Fix |
|---|---|---|
| `'claude' is not recognized` | PATH not refreshed after install | Open a **new** terminal window |
| `'irm' is not recognized` | You are in CMD, not PowerShell | Use the CMD install command, or open PowerShell |
| `The token '&&' is not a valid statement separator` | You are in PowerShell, not CMD | Use the PowerShell install command |
| `'Rscript' is not recognized` | R not on PATH | Section 2, Step 5 |
| R error mentioning `\U` or unrecognized escape | Backslashes in an R path string | Use `here::here()` or forward slashes |
| `/mcp` shows `r-mcptools` failed | `Rscript` not found | Add R to PATH (Section 2, Step 5) or register with the full path to `Rscript.exe` (Section 4a) |
| Claude can't see your RStudio data frames | Live session not shared | Run `mcptools::mcp_session()` in RStudio, or add it to `.Rprofile` |
| Every file shows as fully changed in git | CRLF/LF mismatch | `git config --global core.autocrlf true` |
| "File not found" on a file you can see | Path over 260 chars, or cloud placeholder | Move project nearer drive root; **Always keep on this device** |
| Dataset reads as empty | OneDrive/Box on-demand placeholder | Right-click folder → **Always keep on this device** |
| Script is inexplicably slow in WSL | Project on `/mnt/c/` | Move project into the WSL filesystem |
| Terminal renders boxes or garbled characters | Legacy console font | Use Windows Terminal (default font: Cascadia Mono) |
