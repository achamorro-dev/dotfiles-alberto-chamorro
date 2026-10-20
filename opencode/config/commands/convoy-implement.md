---
description: "Run the Convoy implement pipeline headless from this session: implement a task or an OpenSpec change, then audit it, with a one-page recap."
---
<!-- convoy:command -->

Run the Convoy `implement` pipeline from this session, headless: implement a task or an OpenSpec change, then audit it, with a one-page recap.

Request: $ARGUMENTS

Follow the `convoy` skill for every step (load it now if it isn't loaded; `convoy skill show` prints it). This command only fixes the pipeline to `implement`, launched as `convoy -p implement`; everything else works as the skill says.

1. **Inspect.** In the repository this session works in, run `convoy pipelines show implement`. A project pipeline of the same name replaces the built-in, so describe what will actually run.
2. **Choose the contract.** If the repository has active OpenSpec changes (the directories under `openspec/changes/` other than `archive/`), follow "Choose the contract" in the skill: a change id named in the request becomes `--change <id>` (repeatable, in that order); otherwise list the active changes, say which one fits (the one named like the current branch, or the only one), and ask the user whether to run against it, against others, or without one (`--manual`). Never pick a change or fall back to `--manual` without asking. Without OpenSpec, pass `--manual`.
3. **Prompt.** With a change selected, the spec is the contract and the request, if any, is extra guidance. Without one, the request is the task: if it is empty, ask the user what to build before going on. Write the prompt to a scratch file for `--prompt-file`.
4. **Plan.** `convoy -p implement <--change <id> … | --manual> [--prompt-file <file>] --smart --plan < /dev/null`, then summarize the plan for the user.
5. **Launch.** This pipeline changes code. Confirm with the user first: the plan summary, where it runs (the current branch or a new worktree), and that it bills their providers. Launch the same command with `--detach` in place of `--plan` and keep the run id.
6. **Follow it through.** Monitor with `convoy runs <run-id> --wait`, relay anything it asks, and report the results, as the skill's sections 6 to 8 describe.
