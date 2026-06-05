#!/usr/bin/env bash
#
# render-all.sh — render every Marp slide deck in this folder.
#
# Usage:
#   ./render-all.sh            # render all decks to PDF (default)
#   ./render-all.sh pdf        # same as above
#   ./render-all.sh pptx       # render to PowerPoint
#   ./render-all.sh html       # render to standalone HTML (no browser needed)
#
# Output goes to a subfolder named after the format (pdf/, pptx/, html/).
# Requires Node.js. PDF/PPTX export also needs a Chrome/Chromium browser
# (set CHROME_PATH to point at one if it isn't auto-detected).
#
set -euo pipefail

SLIDES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SLIDES_DIR"

FORMAT="${1:-pdf}"
THEME="themes/bootstrap.css"
OUTDIR="$FORMAT"

case "$FORMAT" in
  pdf|pptx|html) ;;
  *) echo "Usage: $0 [pdf|pptx|html]"; exit 1 ;;
esac

# --- pick a Marp runner: prefer an installed binary, else fall back to npx ---
if command -v marp >/dev/null 2>&1; then
  MARP=(marp)
else
  echo "marp-cli not found on PATH; using 'npx @marp-team/marp-cli' (downloads on first run)."
  MARP=(npx --yes @marp-team/marp-cli)
fi

# --- locate a Chrome/Chromium for PDF/PPTX export (HTML needs none) ---
find_chrome() {
  if [ -n "${CHROME_PATH:-}" ] && [ -x "${CHROME_PATH:-}" ]; then
    echo "$CHROME_PATH"; return 0
  fi
  for b in google-chrome google-chrome-stable chromium chromium-browser; do
    if p=$(command -v "$b" 2>/dev/null); then echo "$p"; return 0; fi
  done
  # puppeteer's downloaded browser cache (Linux + macOS)
  for p in \
    "$HOME"/.cache/puppeteer/chrome/*/chrome-linux64/chrome \
    "$HOME"/.cache/puppeteer/chrome/*/chrome-mac*/Google\ Chrome\ for\ Testing.app/Contents/MacOS/Google\ Chrome\ for\ Testing; do
    [ -x "$p" ] && { echo "$p"; return 0; }
  done
  return 1
}

if [ "$FORMAT" != "html" ]; then
  if chrome=$(find_chrome); then
    export CHROME_PATH="$chrome"
    echo "Using browser: $CHROME_PATH"
  else
    echo "WARNING: no Chrome/Chromium found. PDF/PPTX export may fail."
    echo "         Install Chrome or set CHROME_PATH=/path/to/chrome and re-run."
  fi
fi

mkdir -p "$OUTDIR"

shopt -s nullglob
decks=(00-course-intro.md unit-*.md)
if [ ${#decks[@]} -eq 0 ]; then
  echo "No decks found in $SLIDES_DIR"; exit 1
fi

echo "Rendering ${#decks[@]} deck(s) to $FORMAT/ ..."
fail=0
for f in "${decks[@]}"; do
  out="$OUTDIR/${f%.md}.$FORMAT"
  if "${MARP[@]}" "$f" --theme-set "$THEME" --allow-local-files "--$FORMAT" -o "$out" >/dev/null 2>&1; then
    echo "  ok   $out"
  else
    echo "  FAIL $f"; fail=$((fail + 1))
  fi
done

echo "Done: $(( ${#decks[@]} - fail )) succeeded, $fail failed."
[ "$fail" -eq 0 ]
