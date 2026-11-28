#!/usr/bin/env bash
# PR 本文末尾に Closes を追記し、ドラフトでなければドラフトに戻す。
# 使い方: prepare-pr.sh <issue> <pr>
set -euo pipefail
issue=$1
pr=$2
body=$(gh pr view "$pr" --json body --jq .body)
if ! grep -qE "Closes #$issue\b" <<< "$body"; then
  gh pr edit "$pr" --body "$body"$'\n\n'"Closes #$issue"
fi
if [ "$(gh pr view "$pr" --json isDraft --jq .isDraft)" = "false" ]; then
  gh pr ready "$pr" --undo
fi
