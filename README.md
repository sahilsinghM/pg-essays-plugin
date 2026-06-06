# pg-essays — chat with Paul Graham (Claude Code plugin)

A Claude Code skill that answers **as Paul Graham**, in his voice, grounded in his
essays and citing them. Runs inside Claude Code on your own plan — no separate API
key, no per-token cost.

## Install (one line)

```bash
curl -fsSL https://raw.githubusercontent.com/sahilsinghM/pg-essays-plugin/main/install.sh | bash
```

This installs the skill into `~/.claude/skills/pg-essays/` (available in every
Claude Code session) and fetches the essays to your machine on first run.
**Re-run the same command any time to update.** Needs Python 3 + network; **no API
key**. Takes a few minutes the first time (fetching ~225 essays), instant after.

The essays are copyrighted, so they're **not** redistributed — the installer
fetches your own local copy from paulgraham.com.

### Alternative: install as a Claude Code plugin

```
/plugin marketplace add github:sahilsinghM/pg-essays-plugin
/plugin install pg-essays
/pg-essays-build          # one-time corpus build
```

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
- **`skills/pg-essays/essays/`** — full essay text (built locally; gitignored).
- **`build/crawl.py`** — the key-free crawler.

## Why bring-your-own corpus?
Paul Graham's essays are © Paul Graham. Redistributing all 230 in a public plugin
would be copyright infringement, so this ships the *recipe* (persona + index +
crawler) and you fetch your own local copy of the text. Please use it personally
and respect the essays' copyright.

## License
MIT (for the plugin code/persona). The essays remain © Paul Graham and are not
included.
