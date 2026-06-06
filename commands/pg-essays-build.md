---
name: pg-essays-build
description: One-time build of the local Paul Graham essay corpus for the pg-essays skill
---

Build the local Paul Graham essay corpus so the `pg-essays` skill can answer
grounded, cited questions. The essay text is fetched to the user's machine (not
redistributed), and no API key is needed.

Run these steps and report the result:

1. Install the build dependencies:
   `pip install -r ${CLAUDE_PLUGIN_ROOT}/build/requirements.txt`

2. Run the crawler:
   `python ${CLAUDE_PLUGIN_ROOT}/build/crawl.py`

This fetches ~225 essays from paulgraham.com into
`${CLAUDE_PLUGIN_ROOT}/skills/pg-essays/essays/` (a few minutes). When it finishes,
tell the user how many essays were written and that they can now ask Paul Graham
questions.
