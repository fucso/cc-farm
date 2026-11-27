#!/usr/bin/env bash
# ブランチを作って Issue に紐付け、着手状態にする。
# 使い方: start.sh <issue> <branch>
set -euo pipefail
dir=$(dirname "$0")
issue=$1
branch=$2
gh issue develop "$issue" --name "$branch" --checkout
"$dir/set-status.sh" "$issue" in-progress
