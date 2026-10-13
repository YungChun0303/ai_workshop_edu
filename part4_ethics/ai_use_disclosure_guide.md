# AI Use in Research: Disclosure and Data-Security One-Pager

**AI-Empowered Research · Part 4 take-home** · CERP³, Washington University in St. Louis · 2026-10-16

## 1. The Point

If a machine can produce an accurate, novel, well-cited paper, the written artifact no longer certifies the author's understanding. What institutions can still demand is responsibility, a person who answers for the claim, made explicit through contribution statements that "say plainly what the author did and what the machine did" (Chun, 2026, *The Suit Is Not the Scientist*, yungchun.substack.com/p/the-suit-is-not-the-scientist).

## 2. Match the Data to the Workspace

| Data | Where it may go at WashU |
|---|---|
| **Public / published** | Any tool, including Gemini and Claude Code |
| **De-identified research data** | WashU institutional workspaces (Gemini, Claude Edu), once you've confirmed your data use terms allow it |
| **FERPA records, institutional IP** | WashU workspaces approved for FERPA: Claude Edu (incl. Claude Code), Claude Secure, Gemini, Copilot Chat |
| **PHI** | **Only a PHI-approved workspace** (for Claude: Claude Secure; also Ask WashU, ChatGPT Edu chat). **Never Claude Code or any agentic tool** |
| **DUA-restricted, restricted-use federal files** | Institutional review before any AI touches them; the agreement wins over the tool's approval |

Personal accounts (free, Pro, Max) carry no WashU data agreement, so keep university data out of them. Sources: ai.washu.edu/tools and it.washu.edu/claude-for-education (accessed 2026-10-12).

## 3. Five Red Lines

1. No PHI in Claude Code, Claude Edu, or any agentic tool.
2. No citation you have not personally opened and verified.
3. No AI-only qualitative coding.
4. No uploading manuscripts (or grant proposals) you are reviewing.
5. No credentials or secrets committed to a repository or written into `CLAUDE.md`.

## 4. When to Disclose

| If AI… | Then… |
|---|---|
| touched **analysis, data transformation, or results** | disclose in **Methods**: tool, version, dates, what it did |
| generated or substantially revised **prose** | disclose per the venue's policy (Acknowledgments, author note, or an AI declaration) |
| helped with **literature search or ideas** | increasingly expected; check the venue |
| fixed **grammar, spelling, formatting only** | often exempt, **but not everywhere** (see below) |

**AI is never an author.** Where policies differ: grammar-only editing is exempt at Elsevier, Wiley, SAGE (AERA's journals), and AERA programs, but **must be disclosed** at APA and Taylor & Francis journals, and ICMJE journals give no exemption. NIH won't treat applications "substantially developed by AI" as the applicant's original ideas. Reviewers must not upload manuscripts or proposals to AI tools (NIH, NSF, APA, Taylor & Francis); the few publishers that allow anything allow only secured tools in a supporting role.

*Sources, accessed 2026-10-12: ICMJE Recommendations (Jan. 2026); COPE; APA Journals (Aug. 2025); AERA AI Guidelines; Elsevier (June 2026); Springer Nature; Taylor & Francis; Wiley; SAGE; NIH NOT-OD-23-149 and NOT-OD-25-132; NSF notice (2023, updated 2026).*

## 5. Three Statements You Can Adapt

- **Analysis (Methods):** "Data cleaning and estimation code were drafted with Claude Code ([version], Anthropic) between [dates]. The author specified the cleaning rules and the research design, reviewed every script, re-ran the full pipeline, and verified all reported estimates against the output files."
- **Writing (Acknowledgments or as the venue requires):** "[Tool] was used to [edit for clarity / draft an initial version of section X]. The author revised the text and takes full responsibility for its content."
- **Pipeline (Methods or replication note):** "Analysis followed a scripted pipeline (import → cleaning → descriptives → models); all scripts, logs, and outputs are in the replication package. An AI coding agent drafted scripts under written project rules; the author approved each step and made all design decisions."

## 6. Contribution Statement Template

| Task | What the author did | What AI did (tool, version) |
|---|---|---|
| Research question and design | [e.g., formulated the question; chose the identification strategy] | [e.g., listed candidate designs and their assumptions] |
| Data | [e.g., obtained data under the DUA; decided each cleaning rule] | [e.g., wrote the cleaning scripts; produced the audit counts] |
| Analysis | [e.g., specified models; checked estimates against benchmarks] | [e.g., wrote and ran estimation code] |
| Interpretation | [e.g., all claims, framing, and limitations] | [e.g., none / summarized outputs for review] |
| Writing | [e.g., drafted and revised the manuscript] | [e.g., copyediting / first draft of Methods] |

**Accountability:** "[Author name(s)] reviewed all AI-assisted work, verified every reported number and citation, and take full responsibility for the content."

## 7. Before You Rely on This

Institutional, journal, and funder policies change quickly. This page is a durable framework, not legal advice. Check **WashU IT** (it.washu.edu, ai.washu.edu/tools), **your IRB** and data use agreement, and **the venue's or funder's current AI policy** each time you submit.
