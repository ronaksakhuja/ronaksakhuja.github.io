#!/usr/bin/env bash
# Publish a local HTML file to https://ronaksakhuja.github.io/share/<slug>.html
#
# GitHub Pages for this repo serves from the `master` branch (with .nojekyll),
# not gh-pages. This script pushes directly to master so Jekyll is bypassed
# and self-contained HTML files are served as-is.
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

CLEAN_SLUG=$(echo "$SLUG" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_-]/_/g')
if [ -z "$CLEAN_SLUG" ]; then
    echo "Error: slug is empty after sanitization" >&2
    exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST_REL="share/${CLEAN_SLUG}.html"
DEST="$REPO_DIR/$DEST_REL"
URL="https://ronaksakhuja.github.io/${DEST_REL}"

cd "$REPO_DIR"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "master" ]; then
    echo "Switching from $CURRENT_BRANCH to master (served branch)..."
    git checkout master
fi

git pull --ff-only origin master

cp "$SOURCE" "$DEST"
echo "Copied: $SOURCE -> $DEST"

git add "$DEST_REL"

if git diff --cached --quiet; then
    echo "No changes to commit."
    echo "Live at: $URL"
    exit 0
fi

git commit -m "share: publish ${CLEAN_SLUG}.html"
git push origin master

echo ""
echo "Published: $URL"
echo "(GitHub Pages typically serves within ~30 seconds)"
