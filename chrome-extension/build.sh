#!/usr/bin/env bash
# Build a Chrome Web Store upload zip (files at archive root, no parent folder).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
OUT="${ROOT}/../dist"
ZIP="${OUT}/salesflow-workflows-token-grabber.zip"

mkdir -p "$OUT"
rm -f "$ZIP"

(
  cd "$ROOT"
  zip -r "$ZIP" \
    manifest.json \
    popup.html \
    popup.js \
    icon16.png \
    icon48.png \
    icon128.png \
    -x "*.DS_Store"
)

echo "Built: $ZIP"
echo "Upload this file at https://chrome.google.com/webstore/devconsole"
