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
