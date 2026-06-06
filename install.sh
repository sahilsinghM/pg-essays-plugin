#!/usr/bin/env bash
#
# Install or update the pg-essays Claude Code skill.
#
#   curl -fsSL https://raw.githubusercontent.com/sahilsinghM/pg-essays-plugin/main/install.sh | bash
#
# Installs the skill into ~/.claude/skills/pg-essays (works in every Claude Code
# session). Re-run any time to update the persona + index. Paul Graham's essays
# are fetched to your machine on first install (no API key); they are copyrighted
# and never redistributed.
set -euo pipefail

RAW="https://raw.githubusercontent.com/sahilsinghM/pg-essays-plugin/main"
DEST="${HOME}/.claude/skills/pg-essays"

echo "==> Installing/updating pg-essays into $DEST"
mkdir -p "$DEST/essays"

# Always refresh the persona + index (cheap; this is the "update").
curl -fsSL "$RAW/skills/pg-essays/SKILL.md" -o "$DEST/SKILL.md"
curl -fsSL "$RAW/skills/pg-essays/INDEX.md" -o "$DEST/INDEX.md"

# Build the essay corpus once (the copyrighted text — fetched locally, not shipped).
if [ -z "$(ls -A "$DEST/essays" 2>/dev/null)" ]; then
  echo "==> Building the essay corpus (one-time, a few minutes, no API key)"
  if ! command -v python3 >/dev/null 2>&1; then
    echo "    Python 3 is required to fetch the essays. Install it and re-run."
    exit 1
  fi
  tmp="$(mktemp)"
  curl -fsSL "$RAW/build/crawl.py" -o "$tmp"
  python3 -m pip install --quiet --user requests beautifulsoup4 >/dev/null 2>&1 \
    || python3 -m pip install --quiet requests beautifulsoup4
  PG_ESSAYS_DIR="$DEST/essays" python3 "$tmp"
  rm -f "$tmp"
else
  echo "==> Essays already present ($(ls "$DEST/essays" | wc -l | tr -d ' ') files); skipping fetch."
  echo "    To re-fetch the essays, delete $DEST/essays and re-run this command."
fi

echo "✅ pg-essays ready. In Claude Code, ask Paul Graham anything — e.g.:"
echo "     /pg-essays how do I get startup ideas?"
