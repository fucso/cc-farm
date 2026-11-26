---
name: graze
description: Implement one GitHub Issue and open a pull request. Use when asked to work on a specific issue in this repository (e.g. "/sheep:graze 12" or "graze issue #12"). Delegates the implementation workflow to pstack's poteto-mode and the self-review to interrogate. Never merges.
argument-hint: "[issue-number-or-url]"
---

# graze

- One sheep, one issue: read a GitHub Issue, implement it, and open a pull request.
- The engineering workflow is delegated to pstack; this skill owns only the entrance, the exit, and the guardrails.

## Arguments

- `issue` (required): the issue number or URL in the current repository, given as `$ARGUMENTS`.
- If `issue` is missing, ask for it before doing anything else.

## Prerequisites

- The pstack plugin is installed (michael-denyer/pstack-claude), providing `/pstack:poteto-mode` and `/pstack:interrogate`.
- `gh` is available and authenticated.

## Steps

- **Read the issue**
  - Run `gh issue view <issue>` and treat the issue title and body as the task.
  - Check for an already-open pull request that references the issue.
  - If one exists, stop and report instead of starting duplicate work.
- **Branch first**
  - Before writing any code, create a branch for this issue and link it to the issue.
  - Prefer `gh issue develop <issue> --checkout` when available.
  - Otherwise create a branch whose name contains the issue number, e.g. `issue-<issue>-<short-slug>`.
- **Implement with poteto-mode**
  - Invoke `/pstack:poteto-mode` with the issue title and body as the task.
  - Add these completion conditions: the work ends with a pull request and green CI; merging is out of scope.
  - Do not name a playbook; poteto-mode's router chooses it.
  - Verification is poteto-mode's job, including its use of a project verify skill when the repository has one.
  - If real verification is impossible in this environment, state that in the pull request body instead of faking evidence.
- **Self-review**
  - Run `/pstack:interrogate` on the diff.
  - Fix what it files under "act on".
  - Leave anything else that matters visible in the pull request body.
- **Open the pull request**
  - Keep commits small and reviewable.
  - The body links the issue with `Closes #<issue>`, summarises the change, and records the verification evidence.
  - Do not merge.
- **Watch CI, then stop**
  - Watch the pull request's checks and fix failures caused by your change.
  - Report failures that are unrelated or environmental instead of chasing them.
  - Once CI is green, stop watching; do not react to comments that arrive afterwards (that is mend's job).
- **Report on the issue**
  - Post one comment on the issue: the pull request link, what was done, how it was verified, and anything that blocked or remains.

## Guardrails

- Work only on the given issue; put ideas for other work in the report comment, not in the diff.
- Never merge, and never close the issue by hand (the pull request's `Closes` does it).
- If the issue is ambiguous, already done, or blocked by something you cannot resolve, stop and say why in an issue comment; a clear stop is a valid outcome.
