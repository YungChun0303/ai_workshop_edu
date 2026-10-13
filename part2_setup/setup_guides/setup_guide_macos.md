# A Comprehensive Guide to Claude Code & MCP for Data Analysis on macOS

author: "Yung Chun"

date: "2026-06-24"

revised: "2026-10-12"

goal: This guide provides a foundational overview of **Claude Code** and the **Model Context Protocol (MCP)**, along with a step-by-step setup guide for your Mac, best practices for structuring data analysis projects, and instructions on how to give Claude control over your workflows in **RStudio**, **Visual Studio Code**, and **Obsidian**.

> **Revision note (2026-07-30).** Verified against official Claude Code documentation and upstream package repositories. Five things changed materially since the 2026-06-24 draft:
>
> 1. **The npm install is no longer the recommended path** — a native installer now exists and auto-updates.
> 2. **A correction with teeth:** the old draft told you to delete `~/.local/bin/claude` as a "conflicting binary." That path is now where the *official* native installer puts Claude. Do not delete it.
> 3. **VS Code has an official Anthropic extension.** The Cline + API-key route is obsolete for this purpose and costs you money your subscription already covers.
> 4. **RStudio integration moved to Posit.** The `mcptools` package (on CRAN) supersedes the community `rstudiomcp` package.
> 5. **The Obsidian config block in the old draft pointed at an npm package that does not exist.** Corrected below.
>
> Version numbers and third-party packages drift fast. Re-verify anything that fails rather than assuming the guide is right.

> **Revision note (2026-10-12).** Re-verified against the Claude Code docs (code.claude.com/docs: setup, mcp, vs-code, commands, permission-modes, memory), CRAN, and each tool's own site. Changes: WashU access note; project folder aligned with the workshop template; a new section on permission modes (auto mode is now the default); `mcp_session()` wrapped in `if (interactive())`; Zotero setup for Claude Code corrected (`zotero-mcp setup` configures Claude Desktop only); `mcp-obsidian` needs Python 3.11+; session table updated; new section 8 on companion tools (Warp, Typora, Obsidian).

## 0. What is Claude Code and MCP?

- **Claude Code** is a command-line interface (CLI) tool and terminal-based assistant developed by Anthropic. It allows Claude to run directly inside your local development environment, execute terminal commands, read and write files, and automate tasks.
- **Model Context Protocol (MCP)** is an open standard that acts as a secure bridge between an AI assistant (like Claude) and external data sources or software tools. Instead of relying on rigid, hard-coded integrations, MCP allows developers to build or plug in "servers" that expose databases, local filesystems, web APIs, or specialized applications directly to Claude.

**Account requirement:** Claude Code requires a paid plan — Pro, Max, Team, Enterprise, or a Console (API) account. The free Claude.ai tier does not include Claude Code access.

> **At WashU:** Claude Code comes with the **Claude Edu** workspace (approved for FERPA data, **not PHI**). **Claude Secure does not include Claude Code.** WashU's page describes Claude Code for faculty and staff; students should confirm with WashU IT that their free seat includes it. Sign in at claude.ai with your WashU email → *Continue with SSO*. Details: https://it.washu.edu/claude-for-education/

## 1. Setting up Claude Code on macOS

**System requirements:** macOS 13.0+, 4 GB+ RAM, Apple Silicon or Intel.

### Step 1: Install Claude Code

Use the **native installer**. This is now the recommended method and it updates itself in the background:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Alternatively, install via Homebrew:

```bash
brew install --cask claude-code
```

Two casks exist: `claude-code` tracks the stable channel (roughly a week behind, skips releases with major regressions), and `claude-code@latest` ships new versions immediately. **Homebrew installs do not auto-update** — run `brew upgrade claude-code` (or `brew upgrade claude-code@latest`) periodically, and `brew cleanup` now and then to remove old versions.

<details>
<summary>Legacy npm install (only if you have a specific reason)</summary>

```bash
npm install -g @anthropic-ai/claude-code
```

Requires Node.js 22+. Do **not** use `sudo npm install -g` — it causes the permission problems the old version of this guide then tried to fix. The `sudo chown -R $(whoami) /opt/homebrew/lib/node_modules` workaround from the previous draft is unnecessary on the native installer and is retained here only for people maintaining an existing npm install.

Note that the npm package now just downloads the same native binary; there is little reason to prefer it.

</details>

### Step 2: Authenticate and Verify

```bash
claude
```

Log in through the browser prompt when it appears. Then confirm the install:

```bash
claude --version     # prints e.g. 2.1.211 (Claude Code)
claude doctor        # read-only diagnostics: install health, settings validation
```

> **Do not follow the old advice about `~/.local/bin/claude`.** The previous draft described that path as a "lingering native binary" to remove with `rm -rf`. It is the launcher the native installer manages, symlinked into `~/.local/share/claude/versions/`. Deleting it uninstalls Claude Code. If `claude doctor` genuinely reports conflicting installations, read its output — it names the specific conflict and the fix.

## 2. Structuring Your Project Folder for Data Analysis

When using an AI assistant to analyze data, a clear, predictable folder layout minimizes context confusion. Claude scans your active workspace to find datasets and scripts; a structured layout keeps it from reading unnecessary cache files or temporary outputs.

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

The 4-digit scheme leaves room to insert `1500_merge_waves.Rmd` between existing steps without renumbering everything downstream. Whatever convention you choose, write it into `CLAUDE.md` so the agent stops guessing.

### Configuring `CLAUDE.md`

Create a `CLAUDE.md` file in your root folder. Claude Code reads it at the start of every session. Start from the workshop template (`project_template/CLAUDE.md`), or run `/init` inside Claude Code to generate a starter file, then edit it. Use `/memory` to open the memory files in use. The workshop handout `part2_setup/claude_md_guide.md` covers user-level vs. project-level files and how to write rules that work. A minimal example:

```markdown
# Project Configuration

## Response & Writing Guidelines
- Maintain an objective, academic prose style.
- Banned AI-isms: "delve", "testament", "tapestry", "moreover", "foster".
- Never output conversational fluff like "Here is your code:".

## Data Analysis Prescriptions
- Use the `fixest` library (`feols()`) for high-dimensional fixed effects and Sun & Abraham (2021) event studies to conserve memory.
- Always append `gc()` after dropping heavy temporary dataframes to return memory to macOS.
```

## 3. Integrating Claude with Your Tools & IDEs

### 3a. Controlling and Optimizing RStudio (`mcptools`)

**This section replaces the `zygi/rstudiomcp` instructions in the previous draft.** That package still exists and still works as documented, but it is an unofficial hobby project whose last commit was October 2025, and its own README notes it is not an RStudio product. Posit now maintains a first-party option.

Use **`mcptools`**, maintained by Posit and available on CRAN:

#### **Step 1: Install the package in R**

```r
install.packages("mcptools")
```

#### **Step 2: Register it with Claude Code**

From your terminal:

```bash
claude mcp add -s user r-mcptools -- Rscript -e "mcptools::mcp_server()"
```

#### **Step 3: Connect your live R session**

This step is the one people miss. By default the MCP server runs in its own headless R process — it cannot see the data frames sitting in your RStudio environment. To expose your **live** session, run this in the RStudio console:

```r
mcptools::mcp_session()
```

To avoid retyping it every time, Posit recommends putting the call in your `.Rprofile`. Open the file with:

```r
usethis::edit_r_profile()
```

and add this line (the `if (interactive())` wrapper keeps the background `Rscript` runs that Claude starts from registering as sessions):

```r
if (interactive()) mcptools::mcp_session()
```

#### **Step 4: Grant System-Level Permissions**

When Claude executes background scripts or compiles documents (rendering an RMarkdown/Quarto file to HTML, for instance), macOS may prompt with *"Terminal would like to access files..."*. Click **Allow**. To prevent recurring interruptions, go to **System Settings > Privacy & Security > Full Disk Access** and enable your terminal app.

#### **Step 5: Execute via Claude Code**

Launch Claude from your project directory and type **`/mcp`** to verify the server shows as connected. You can then prompt with live context cues: *"Look at the data frame currently in my environment and identify why the weights are returning NA values."*

### 3b. Connecting and Configuring Visual Studio Code

**This section replaces the Cline instructions in the previous draft.** Anthropic now ships an official VS Code extension, and it authenticates with your existing Pro/Max subscription — no API key, no separate metered billing.

1. **Install the Extension:** Open the Extensions view (`Cmd+Shift+X`), search for **"Claude Code"**, and install the one published by Anthropic (`anthropic.claude-code`). Requires VS Code 1.94.0+. Cursor has its own install link on the extension's docs page; other VS Code forks install it from the Open VSX registry.
2. **Sign in:** Open the panel via the Spark icon in the editor toolbar, the Activity Bar, or the status bar. Click **Sign in** and authorize in the browser. **No API key is required** for Pro, Max, Team, Enterprise, or Console accounts.
3. **What you get:** side-by-side diffs with per-edit approval, plan review before Claude acts, `@`-mentions of files with line ranges (`Option+K` inserts a reference to your current selection), tabbed parallel conversations, session history, and checkpoints for rewinding Claude's edits.
4. **Note on the CLI:** the extension bundles its own private copy of Claude Code for the chat panel, but it does **not** add `claude` to your shell PATH. If you want to run `claude` in the integrated terminal, you still need the standalone install from Section 1.

Useful settings live under Extensions → Claude Code (`Cmd+,`). `initialPermissionMode` is worth setting to `plan` if you want Claude to propose before it acts.

## 4. Maximizing the Setup with Secondary Materials

### 4a. Obsidian

**The config block in the previous draft was wrong** — the npm package `@modelcontextprotocol/server-obsidian` does not exist and never did. Here is the working setup.

The **Local REST API** community plugin now ships a built-in MCP server, which is the cleanest route and requires no separate package:

1. **Install the plugin:** In Obsidian, go to **Settings > Community Plugins > Browse**, search for **Local REST API**, install and enable it.
2. **Copy the API key** from the plugin settings.
3. **Register the server:**

```bash
claude mcp add --transport http obsidian https://127.0.0.1:27124/mcp/ \
  --scope user \
  --header "Authorization: Bearer YOUR_API_KEY"
```

> **Most likely failure point:** the plugin serves HTTPS with a certificate from its own **locally issued certificate authority**, which your Mac does not trust by default. If the connection fails, either trust that certificate in Keychain Access, or turn on **Settings → Local REST API → Enable HTTP server** (off by default) and use `http://127.0.0.1:27123/mcp/` instead. Loopback-only traffic makes the plain-HTTP option acceptable on a personal machine.

*Fallback:* the community server `MarkusPfundstein/mcp-obsidian` (PyPI: `mcp-obsidian`, needs Python 3.11+) still works, run via `uvx mcp-obsidian` with `OBSIDIAN_API_KEY` set in the environment. With the plugin's built-in server, most people won't need it.

**Power move:** *"Look at the regression results in outputs/tables/3000_main_estimates.csv, search my Obsidian vault for the 'Literature Review' note, and update the discussion section with the matching coefficients."*

### 4b. Zotero

**Correction:** the previous draft stated that Claude "cannot natively browse your Zotero account." A real Zotero MCP server now exists, built on Zotero's local API.

1. **Enable Zotero's local API:** Requires **Zotero 7+**. In Zotero, go to **Settings → Advanced** and check **"Allow other applications on this computer to communicate with Zotero."** The local API is read-only.
2. **Install the server** (note the naming trap — the PyPI package is `zotero-mcp-server`, not `zotero-mcp`):

```bash
uv tool install zotero-mcp-server
claude mcp add -s user zotero -e ZOTERO_LOCAL=true -- zotero-mcp
```

Requires Python 3.10+. `ZOTERO_LOCAL=true` tells the server to use Zotero's local API rather than the web API. Note that the package's own `zotero-mcp setup` command configures **Claude Desktop** only; for Claude Code, register it with `claude mcp add` as above (this guide's rule: never hand-edit `~/.claude.json`). Check with `/mcp` that it shows as connected.

> **Verify before relying on it:** full-text search across attachments has historically depended on Zotero build specifics. Confirm it works on your machine before building a workflow around it.

*Fallback that always works:* install **Better BibTeX** in Zotero, auto-export your collection to your project folder as `references.bib` with "Keep updated" enabled, and let Claude read the file directly from the filesystem. No MCP server required, no version drift. For many researchers this remains the better option precisely because it is boring.

### 4c. Local Git Automation

Claude Code has built-in git awareness. If Git is initialized in your project directory, you do not need an MCP wrapper.

- *"Review the changes I just made to my R model script, verify there are no syntax errors, and write a descriptive, human-sounding commit message."*

## 5. MCP Configuration Reference

The previous draft told you to hand-edit `~/.claude.json`. **Use the CLI instead** — it validates as it writes, and it puts entries in the right scope.

```bash
claude mcp add <name> --scope user -- npx -y <package>          # stdio server
claude mcp add --transport http <name> --scope user <url>       # HTTP server
claude mcp list                                                  # what's registered
```

The `--` separates Claude's own flags from the command it should run for the server.

| Scope | Available in | Shared with collaborators | Written to |
|---|---|---|---|
| `local` (default) | current project only | No | `~/.claude.json` |
| `project` | current project only | **Yes** — commit it | `.mcp.json` at project root |
| `user` | all your projects | No | `~/.claude.json` |

Precedence runs local > project > user. Entire server entries win or lose; individual fields are **not** merged.

**Two file-role clarifications**, since these are easy to conflate:

- `~/.claude.json` — MCP servers at local and user scope. CLI-managed.
- `~/.claude/settings.json` — settings, permissions, hooks, environment variables. Shared between the CLI and the VS Code extension. **Does not hold MCP server definitions.**

**Workshop gotcha:** project-scoped servers in a committed `.mcp.json` require interactive approval the first time anyone uses them. If you distribute a repo with `.mcp.json` included, recipients will see the server as pending until they launch `claude` and accept the trust prompt. `claude mcp reset-project-choices` resets those approvals.

## 6. Permission Modes: How Much Claude Does Without Asking

Claude Code has several permission modes. **Shift+Tab** cycles through them, and the current mode is shown at the bottom of the terminal.

| Mode | What Claude does | When to use it |
|---|---|---|
| **Auto** | Decides for itself which actions are safe to run without asking. Since v2.1.283 this is the default starting mode in the terminal and in VS Code, where available. | Routine work in a project you trust |
| **Manual** (`default`) | Asks before every file edit and command | Learning, sensitive projects, or when you want to watch every step |
| **Accept edits** | Edits files without asking; still asks before running commands | Long writing or refactoring runs |
| **Plan** | Reads and explores but **cannot edit or run anything**; proposes a plan | Research-design decisions; anything you want to approve before it happens |

You can also start in a mode directly, e.g. `claude --permission-mode plan`. **Esc** interrupts Claude at any point; pressing **Esc** twice opens the rewind menu. In the desktop app, Cmd+Shift+M opens the mode menu. Source: https://code.claude.com/docs/en/permission-modes (accessed 2026-10-12).

## 7. Session and Cost Management

| Command | What it does |
|---|---|
| `claude` | Start an interactive session in the current directory |
| `claude --continue` | Resume the most recent conversation in this folder |
| `claude --resume` | Reopen a past conversation from a searchable picker |
| `claude doctor` | Diagnose install and settings problems |
| `claude update` | Apply an update immediately |
| `/mcp` | List MCP servers and their connection status |
| `/init` | Generate a starter `CLAUDE.md` for this folder |
| `/memory` | Open and edit the `CLAUDE.md` files in use |
| `/context` | Show what is filling the context window, including which memory files loaded |
| `/compact` | Summarize the conversation to reclaim context |
| `/clear` | Wipe context and start fresh in the same directory |
| `/usage` | Show plan limits and what is consuming them (aliases: `/cost`, `/stats`) |
| `/model` | Switch model |

`/usage` is worth knowing if you are on Pro rather than Max: it attributes recent consumption to specific skills, subagents, and MCP servers, and flags behaviors like cache misses or long context that are quietly expensive.

## 8. Companion Tools for Working with Claude Code

None of these are required. Everything in this guide works in the built-in **Terminal** app and RStudio. Prices and terms were checked on 2026-10-12.

| Tool | What it is for | Cost | Install |
|---|---|---|---|
| **Warp** | A modern terminal: tabs, blocks of output you can select and copy, easier text editing at the prompt | Free plan available; login optional ("Skip for now") | `brew install --cask warp` or https://www.warp.dev |
| **Typora** | A clean Markdown editor that shows formatted text as you type; good for reading and editing what Claude writes in `writing/` | $14.99 one-time license (up to 3 devices); 15-day free trial | `brew install --cask typora` or https://typora.io |
| **Obsidian** | A Markdown notes app for a literature or project-notes "vault"; can connect to Claude via MCP (section 4a) | Free, including for work use (optional commercial license) | `brew install --cask obsidian` or https://obsidian.md |

**Using Warp with Claude Code.**

- **Run `claude` at Warp's normal prompt.** Warp includes its own AI agent ("Warp Agent"), which is a different product from Claude Code. Type `claude` as usual; you don't need Warp's AI features for anything in the workshop.
- **Privacy.** Warp collects product analytics by default; you can turn this off under **Settings → Privacy**. On the Free plan, Warp's own AI features require telemetry to be on. Don't send research data to Warp's AI.
- **Known glitches.** Some users report duplicated output after clearing the screen while Claude Code is running. These are user reports, not confirmed by Anthropic. If the display gets confusing, press `Ctrl+L`, or use Terminal.app.

**Typora or Obsidian?** Both open plain `.md` files, so they work on the same project folder and nothing is locked in. Use Typora to read and edit one document at a time, like a word processor. Use Obsidian to manage many linked notes, such as a literature vault. Whichever you use, check your editor's settings so it doesn't hard-wrap lines inside paragraphs.
