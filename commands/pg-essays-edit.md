---
name: pg-essays-edit
description: Audit and clean up the pg-essays skill files — remove duplication, stale steps, vague rules, and bloat so the skill stays sharp.
---

A messy skill creates messy output. Use this to keep the `pg-essays` skill lean.

Audit the skill's own files under `${CLAUDE_PLUGIN_ROOT}/skills/pg-essays/`
(`SKILL.md`, `INDEX.md`, `eval.md`, `memory.md`) and the command files under
`${CLAUDE_PLUGIN_ROOT}/commands/`. Do **not** touch `essays/*.txt` — that's the
user's local corpus, not skill instructions.

Read each file, then look for and propose fixes for:

1. **Duplicate instructions** — the same rule stated in two places. Keep one
   canonical statement and remove the echoes.
2. **Stale setup steps** — build/install steps that no longer match
   `build/crawl.py`, `requirements.txt`, or the real folder layout.
3. **Unused files or references** — pointers to files that don't exist, or files
   nothing else references.
4. **Vague rules** — soft, unactionable guidance ("be helpful," "try to be
   accurate"). Make it concrete and checkable, or cut it.
5. **Bloat** — long passages that could be a sentence; repetition that adds words
   but no instruction.
6. **Drift between files** — e.g. an `eval.md` check or `memory.md` learning that
   contradicts `SKILL.md`. Reconcile them.

Then:

- **Show the proposed edits as a concise diff or bullet list, and ask before
  writing** any changes. Never silently rewrite the skill.
- **Preserve Paul Graham's voice rules and the grounding discipline** — those are
  the point of the skill, not bloat. Trim *around* them.
- **Prune `memory.md`** if it has grown past ~20 lines or holds weak/duplicate
  learnings, per the rules in that file.

Report what you changed and why, in one short summary.
