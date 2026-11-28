#!/usr/bin/env bash
# PR を ready for review にし、Issue をレビュー待ちにする。
# 使い方: finish.sh <issue> <pr>
set -euo pipefail
dir=$(dirname "$0")
issue=$1
pr=$2
gh pr ready "$pr"
"$dir/set-status.sh" "$issue" in-review
