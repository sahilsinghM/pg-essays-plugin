#!/usr/bin/env bash
#
# Install or update the pg-essays Claude Code plugin (two modes).
#
#   curl -fsSL https://raw.githubusercontent.com/sahilsinghM/pg-essays-plugin/main/install.sh | bash
#
# Installs two skills into ~/.claude/skills:
#   - pg-essays        quick grounded lookup, answers in PG's voice
#   - pg-office-hours  structured office-hours interrogation (reuses the same corpus)
# Both work in every Claude Code session. Re-run any time to update the personas +
# index. Paul Graham's essays are fetched to your machine on first install (no API
# key); they are copyrighted and never redistributed.
set -euo pipefail

RAW="https://raw.githubusercontent.com/sahilsinghM/pg-essays-plugin/main"
DEST="${HOME}/.claude/skills/pg-essays"
OH_DEST="${HOME}/.claude/skills/pg-office-hours"

echo "==> Installing/updating pg-essays into $DEST"
mkdir -p "$DEST/essays"

# Always refresh the persona + index (cheap; this is the "update").
curl -fsSL "$RAW/skills/pg-essays/SKILL.md" -o "$DEST/SKILL.md"
curl -fsSL "$RAW/skills/pg-essays/INDEX.md" -o "$DEST/INDEX.md"

# Office-hours mode is a companion skill: just its persona, no corpus of its own —
# it reuses the pg-essays essays + INDEX built below.
echo "==> Installing/updating pg-office-hours into $OH_DEST"
mkdir -p "$OH_DEST"
curl -fsSL "$RAW/skills/pg-office-hours/SKILL.md" -o "$OH_DEST/SKILL.md"

# Build the essay corpus once (the copyrighted text — fetched locally, not shipped).
if [ -z "$(ls -A "$DEST/essays" 2>/dev/null)" ]; then
  echo "==> Building the essay corpus (one-time, a few minutes, no API key)"
  if ! command -v python3 >/dev/null 2>&1; then
    echo "    Python 3 is required to fetch the essays. Install it and re-run."
    exit 1
  fi
  tmp="$(mktemp)"
  curl -fsSL "$RAW/build/crawl.py" -o "$tmp"

  # Use an isolated venv so we never touch system packages (avoids PEP 668
  # "externally-managed-environment" on Debian/Ubuntu/etc.). Fall back to
  # --user / --break-system-packages if venv isn't available.
  venv="${HOME}/.cache/pg-essays/venv"
  if python3 -m venv "$venv" >/dev/null 2>&1; then
    pybin="$venv/bin/python"
    "$venv/bin/pip" install --quiet --upgrade pip >/dev/null 2>&1 || true
    "$venv/bin/pip" install --quiet requests beautifulsoup4
  else
    pybin="python3"
    python3 -m pip install --quiet --user requests beautifulsoup4 >/dev/null 2>&1 \
      || python3 -m pip install --quiet --user --break-system-packages requests beautifulsoup4 >/dev/null 2>&1 \
      || { echo "    Could not install requests/beautifulsoup4. Install python3-venv (e.g. 'sudo apt install python3-venv') and re-run."; exit 1; }
  fi
  PG_ESSAYS_DIR="$DEST/essays" "$pybin" "$tmp"
  rm -f "$tmp"
else
  echo "==> Essays already present ($(ls "$DEST/essays" | wc -l | tr -d ' ') files); skipping fetch."
  echo "    To re-fetch the essays, delete $DEST/essays and re-run this command."
fi

echo "✅ pg-essays + pg-office-hours ready. In Claude Code, two ways to talk to PG:"
echo "     /pg-essays how do I get startup ideas?          # quick grounded answer"
echo "     /pg-office-hours should I drop out to do a startup?   # office-hours grilling"
