#!/usr/bin/env bash
# Issue の farm: ステータスラベルを指定のものに付け替える。
# 使い方: set-status.sh <issue> <status>   例: set-status.sh 12 in-progress
set -euo pipefail
issue=$1
target="farm:$2"
current=$(gh issue view "$issue" --json labels --jq '.labels[].name | select(startswith("farm:"))')
args=(--add-label "$target")
while IFS= read -r label; do
  if [ -n "$label" ] && [ "$label" != "$target" ]; then
    args+=(--remove-label "$label")
  fi
done <<< "$current"
gh issue edit "$issue" "${args[@]}"
