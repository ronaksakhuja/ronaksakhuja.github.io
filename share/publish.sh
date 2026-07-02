#!/usr/bin/env bash
# Publish a local HTML file to https://ronaksakhuja.github.io/share/<slug>.html
#
# Usage:
#   ./publish.sh <source.html> <slug>
#
# Example:
#   ./publish.sh /tmp/report.html quarterly_review
#   -> https://ronaksakhuja.github.io/share/quarterly_review.html

set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: $0 <source.html> <slug>" >&2
    echo "Example: $0 /tmp/report.html quarterly_review" >&2
    exit 1
fi

SOURCE="$1"
SLUG="$2"

if [ ! -f "$SOURCE" ]; then
    echo "Error: source file not found: $SOURCE" >&2
    exit 1
fi

# Sanitize slug: lowercase, alphanumeric + underscore + dash only
CLEAN_SLUG=$(echo "$SLUG" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_-]/_/g')
if [ -z "$CLEAN_SLUG" ]; then
    echo "Error: slug is empty after sanitization" >&2
    exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$REPO_DIR/share/${CLEAN_SLUG}.html"
URL="https://ronaksakhuja.github.io/share/${CLEAN_SLUG}.html"

cp "$SOURCE" "$DEST"
echo "Copied: $SOURCE -> $DEST"

cd "$REPO_DIR"

# Only commit if there are actual changes
if git diff --quiet "share/${CLEAN_SLUG}.html" 2>/dev/null && ! git ls-files --others --exclude-standard | grep -q "share/${CLEAN_SLUG}.html"; then
    echo "No changes to commit."
    echo "Live at: $URL"
    exit 0
fi

git add "share/${CLEAN_SLUG}.html"
git commit -m "share: publish ${CLEAN_SLUG}.html"
git push

echo ""
echo "Published: $URL"
echo "(GitHub Pages typically rebuilds in ~30-60 seconds)"
