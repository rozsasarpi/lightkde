#!/usr/bin/env bash
# Reject a commit message that credits an AI assistant as author or co-author.
set -euo pipefail

commit_msg_file="$1"
message=$(grep -v '^#' "$commit_msg_file" || true)

if echo "$message" | grep -qiE 'co-authored-by:.*(claude|anthropic|chatgpt|openai\b|copilot|codex|gemini|gpt-?[0-9])'; then
  echo "commit message credits an AI assistant as co-author -- this repo does not list AI tools among its contributors. Remove the attribution line."
  exit 1
fi

if echo "$message" | grep -qiE 'generated (with|by) \[?(claude|chatgpt|copilot|codex|gemini)'; then
  echo "commit message credits an AI assistant as generator -- this repo does not list AI tools among its contributors. Remove the attribution line."
  exit 1
fi

if echo "$message" | grep -q '🤖'; then
  echo "commit message contains an AI-generated marker (🤖) -- this repo does not list AI tools among its contributors. Remove the attribution line."
  exit 1
fi
