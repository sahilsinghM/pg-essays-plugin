# pg-essays — chat with Paul Graham (Claude Code plugin)

Talk to **Paul Graham** inside Claude Code, in his voice, grounded in his essays and
citing them. Two modes, one shared corpus:

- **`pg-essays`** — the quick grounded lookup. Ask a question, get an answer in his
  voice with a `Sources:` line.
- **`pg-office-hours`** — the structured grilling. Bring a decision or idea and he
  interrogates you one question at a time, pushes back on the weak parts, and ends
  with an assignment plus 2–3 essays to read.

Runs on your own plan — no separate API key, no per-token cost.

## Install (one line)

```bash
curl -fsSL https://raw.githubusercontent.com/sahilsinghM/pg-essays-plugin/main/install.sh | bash
```

This installs both skills (`~/.claude/skills/pg-essays/` and
`~/.claude/skills/pg-office-hours/`, available in every Claude Code session) and
fetches the essays to your machine on first run. Office hours reuses the same corpus,
so there's nothing extra to build.
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

**Quick answer** — just ask, inside Claude Code:

```
how do I get startup ideas?
what does Paul Graham think about raising money?
/pg-essays should I drop out to do a startup?
```

It reads the index, pulls the one or two most relevant essays, and answers in PG's
voice with a `Sources:` line. If a topic isn't in his essays, it says so in
character rather than making something up.

**Office hours** — bring a decision or idea and get grilled:

```
/pg-office-hours should I open-source my dev tool?
/pg-office-hours I want to build an app for dog walkers — is the idea any good?
```

He asks one sharp question at a time, pushes back where your framing conflicts with
what his essays argue, and ends with an assignment plus 2–3 essays to read. Say
"just give me your take" any time to drop the grilling and get a straight answer.

## How it works
- **`skills/pg-essays/SKILL.md`** — the persona + grounding rules + index-then-read retrieval.
- **`skills/pg-essays/INDEX.md`** — one-line thesis + keywords per essay (shipped).
- **`skills/pg-essays/essays/`** — full essay text (built locally; gitignored).
- **`skills/pg-office-hours/SKILL.md`** — the office-hours loop (interrogate → grounded pushback → assignment + reads); ships no essays of its own and reuses the `pg-essays` corpus above.
- **`build/crawl.py`** — the key-free crawler.

## Why bring-your-own corpus?
Paul Graham's essays are © Paul Graham. Redistributing all 230 in a public plugin
would be copyright infringement, so this ships the *recipe* (persona + index +
crawler) and you fetch your own local copy of the text. Please use it personally
and respect the essays' copyright.

## License
MIT (for the plugin code/persona). The essays remain © Paul Graham and are not
included.
