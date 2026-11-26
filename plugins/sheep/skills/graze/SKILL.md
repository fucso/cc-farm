---
name: graze
description: Implement one GitHub Issue and open a pull request. Use when asked to work on a specific issue in this repository (e.g. "/sheep:graze 12" or "graze issue #12"). Delegates the implementation workflow to pstack's poteto-mode and the self-review to interrogate. Never merges.
---

# graze

One sheep, one issue. Read a GitHub Issue, implement it, and open a pull
request. The engineering workflow itself is delegated to pstack; this skill
only owns the entrance, the exit, and the guardrails.

Prerequisites: the pstack plugin is installed (for `/pstack:poteto-mode` and
`/pstack:interrogate`), and `gh` is available and authenticated.

## Input

An issue number or URL in the current repository. If none is given, ask.

## Steps

1. **Read the issue.** `gh issue view <N>` — the issue body is the task.
   Check for an already-open pull request that references the issue; if one
   exists, stop and report instead of starting duplicate work.
2. **Implement with poteto-mode.** Invoke `/pstack:poteto-mode` with the
   issue title and body as the task, plus these completion conditions:
   the work ends with a pull request and green CI; merging is out of scope.
   Do not name a playbook — poteto-mode's router chooses it.
3. **Verify.** Follow the verification the playbook asks for. Prefer, in
   order: a project verification skill if this repository has one (created
   by `/pstack:create-verification-skill`), the verification section of
   CLAUDE.md if present, the commands CI runs (`.github/workflows`), then
   package.json / Makefile scripts (test, typecheck, lint). If real-interface
   verification is impossible in this environment, say so in the PR body
   instead of faking evidence; tests and CI are then the evidence.
4. **Self-review.** Run `/pstack:interrogate` on the diff. Fix what it files
   under "act on"; leave the rest visible in the PR body if it matters.
5. **Open the pull request.** Small, reviewable commits. The PR body links
   the issue (`Closes #<N>`), summarises the change, and records the
   verification evidence (commands run and what was observed). Do not merge.
6. **Watch CI.** After opening the PR, watch its checks. Fix failures caused
   by your change and push again; report failures that are unrelated or
   environmental instead of chasing them.
7. **Report on the issue.** One comment on the issue: the PR link, what was
   done, how it was verified, and anything that blocked or remains.

## Guardrails

- Work only on the given issue. Ideas for other work go in the report
  comment, not into the diff.
- Never merge, never close the issue by hand (the PR's `Closes` does it).
- If the issue is ambiguous, already done, or blocked by something you
  cannot resolve, stop and say why in an issue comment. A clear stop is a
  valid outcome.
