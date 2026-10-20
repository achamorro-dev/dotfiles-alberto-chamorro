---
description: "Run the Convoy hunter pipeline headless from this session: a maximum-coverage audit of the branch across six tracks and five models; it doesn't change code."
---
<!-- convoy:command -->

Run the Convoy `hunter` pipeline from this session, headless: a maximum-coverage audit of the branch across six tracks and five models; it doesn't change code.

Request: $ARGUMENTS

Follow the `convoy` skill for every step (load it now if it isn't loaded; `convoy skill show` prints it). This command only fixes the pipeline to `hunter`, launched as `convoy -p hunter`; everything else works as the skill says.

1. **Inspect.** In the repository this session works in, run `convoy pipelines show hunter`. A project pipeline of the same name replaces the built-in, so describe what will actually run.
2. **Choose the contract.** If the repository has active OpenSpec changes (the directories under `openspec/changes/` other than `archive/`), follow "Choose the contract" in the skill: a change id named in the request becomes `--change <id>` (repeatable, in that order); otherwise list the active changes, say which one fits (the one named like the current branch, or the only one), and ask the user whether to run against it, against others, or without one (`--manual`). Never pick a change or fall back to `--manual` without asking. Without OpenSpec, pass `--manual`.
3. **Prompt.** The pipeline has a default prompt. Pass the request as `--prompt-file` (written to a scratch file) only when it adds focus or scope; with a change selected, the spec is the contract.
4. **Plan.** `convoy -p hunter <--change <id> … | --manual> [--prompt-file <file>] --smart --plan < /dev/null`, then summarize the plan for the user.
5. **Launch.** This pipeline only reads the repository and the user asked for it by name: launch without another round-trip, unless the plan shows something they wouldn't expect (a model, a cost, a checkout). Launch the same command with `--detach` in place of `--plan` and keep the run id.
6. **Follow it through.** Monitor with `convoy runs <run-id> --wait`, relay anything it asks, and report the results, as the skill's sections 6 to 8 describe.
