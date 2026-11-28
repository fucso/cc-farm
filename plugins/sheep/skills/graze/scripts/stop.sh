#!/usr/bin/env bash
# 作業を止め、人間の判断待ちにして理由をコメントする。
# 使い方: stop.sh <issue> <理由>
set -euo pipefail
dir=$(dirname "$0")
issue=$1
reason=$2
"$dir/set-status.sh" "$issue" needs-human
gh issue comment "$issue" --body "<!-- farm:comment -->"$'\n'"$reason"
