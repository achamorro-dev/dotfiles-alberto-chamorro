---
name: convoy-ship
description: "Run the Convoy ship pipeline headless from this session: sync the branch with its base, review it, fix the accepted findings, and reach 90/100."
argument-hint: "[focus, task, or OpenSpec change id]"
disable-model-invocation: true
---
<!-- convoy:command -->

Run the Convoy `ship` pipeline from this session, headless: sync the branch with its base, review it, fix the accepted findings, and reach 90/100.

Request: $ARGUMENTS

Follow the `convoy` skill for every step (load it now if it isn't loaded; `convoy skill show` prints it). This command only fixes the pipeline to `ship`, launched as `convoy -p ship`; everything else works as the skill says.

1. **Inspect.** In the repository this session works in, run `convoy pipelines show ship`. A project pipeline of the same name replaces the built-in, so describe what will actually run.
2. **Choose the contract.** If the repository has active OpenSpec changes (the directories under `openspec/changes/` other than `archive/`), follow "Choose the contract" in the skill: a change id named in the request becomes `--change <id>` (repeatable, in that order); otherwise list the active changes, say which one fits (the one named like the current branch, or the only one), and ask the user whether to run against it, against others, or without one (`--manual`). Never pick a change or fall back to `--manual` without asking. Without OpenSpec, pass `--manual`.
3. **Prompt.** The pipeline has a default prompt. Pass the request as `--prompt-file` (written to a scratch file) only when it adds focus or scope; with a change selected, the spec is the contract.
4. **Plan.** `convoy -p ship <--change <id> … | --manual> [--prompt-file <file>] --smart --plan < /dev/null`, then summarize the plan for the user.
5. **Launch.** This pipeline changes code. Confirm with the user first: the plan summary, where it runs (the current branch or a new worktree), and that it bills their providers. Launch the same command with `--detach` in place of `--plan` and keep the run id.
6. **Follow it through.** Monitor with `convoy runs <run-id> --wait`, relay anything it asks, and report the results, as the skill's sections 6 to 8 describe.
