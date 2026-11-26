#!/usr/bin/env bash
set -euo pipefail

# md2pdf.sh — render a Markdown file to a styled PDF.
# Thin wrapper around the `md-to-pdf` npm package (marked + Puppeteer),
# using the bundled style.css for the look (fonts, cover page, tables).
#
# Usage:
#   ./md2pdf.sh input.md
#
# Requirements:
#   - Node.js / npx (first run downloads a bundled Chromium via
#     Puppeteer — needs internet once, then it's cached)
#
# See README.md for the Markdown conventions style.css expects
# (cover-meta table, <mark> highlights).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STYLE="$SCRIPT_DIR/style.css"

if [ $# -lt 1 ]; then
  echo "Usage: $0 input.md" >&2
  exit 1
fi

INPUT="$1"
if [ ! -f "$INPUT" ]; then
  echo "Input file not found: $INPUT" >&2
  exit 1
fi

npx --yes md-to-pdf "$INPUT" --stylesheet "$STYLE"

echo "Wrote ${INPUT%.md}.pdf"
