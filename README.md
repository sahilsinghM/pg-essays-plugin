# pg-essays — chat with Paul Graham (Claude Code plugin)

A Claude Code skill that answers **as Paul Graham**, in his voice, grounded in his
essays and citing them. Runs inside Claude Code on your own plan — no separate API
key, no per-token cost.

## Install

```
/plugin marketplace add github:sahilsinghM/pg-essays-plugin
/plugin install pg-essays
```

## One-time build (required)

The plugin ships the persona and the essay **index**, but **not** Paul Graham's
essay text — that's copyrighted, so you fetch your own local copy:

```
/pg-essays-build
```
(or manually: `pip install -r ${CLAUDE_PLUGIN_ROOT}/build/requirements.txt && python ${CLAUDE_PLUGIN_ROOT}/build/crawl.py`)

This fetches ~225 essays from paulgraham.com into the plugin's local `essays/`
folder. Takes a few minutes; needs Python + network; **no API key**.

## Use

Just ask, inside Claude Code:

```
how do I get startup ideas?
what does Paul Graham think about raising money?
/pg-essays should I drop out to do a startup?
```

It reads the index, pulls the one or two most relevant essays, and answers in PG's
voice with a `Sources:` line. If a topic isn't in his essays, it says so in
character rather than making something up.

## How it works
- **`skills/pg-essays/SKILL.md`** — the persona + grounding rules + index-then-read retrieval.
- **`skills/pg-essays/INDEX.md`** — one-line thesis + keywords per essay (shipped).
- **`skills/pg-essays/eval.md`** — yes/no checks run before each answer (grounding, voice, sources).
- **`skills/pg-essays/memory.md`** — one-sentence learnings the skill accrues over time.
- **`skills/pg-essays/essays/`** — full essay text (built locally; gitignored).
- **`build/crawl.py`** — the key-free crawler.

### Maintenance
- **`/pg-essays-edit`** — audits the skill's own files and trims duplication, stale
  steps, vague rules, and bloat (a messy skill makes messy output).

## Why bring-your-own corpus?
Paul Graham's essays are © Paul Graham. Redistributing all 230 in a public plugin
would be copyright infringement, so this ships the *recipe* (persona + index +
crawler) and you fetch your own local copy of the text. Please use it personally
and respect the essays' copyright.

## License
MIT (for the plugin code/persona). The essays remain © Paul Graham and are not
included.
