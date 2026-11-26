# cc-farm

A farm where a collie manages a flock of sheep workers.
Claude Code plugins for issue-driven, manager/worker task orchestration:
tasks live as GitHub Issues, and each worker (sheep) takes one issue and
turns it into a pull request. The overall design lives in
[issue #1](https://github.com/fucso/cc-farm/issues/1).

## Install

```
/plugin marketplace add fucso/cc-farm
/plugin install sheep@cc-farm
```

The sheep plugin delegates its engineering workflow to
[pstack](https://github.com/PickleBoxer/pstack) (poteto-mode), so install
that too:

```
/plugin marketplace add PickleBoxer/claude-plugins
/plugin install pstack@pickleboxer
```

## Use

```
/sheep:graze <issue-number>
```

Reads the issue, implements it via poteto-mode, self-reviews with
interrogate, opens a pull request, watches CI, and reports back on the
issue. It never merges — that is the shepherd's job.
