---
name: github-stack-prs
description: Use when planning or implementing chained PRs, stacked PRs, GitHub Stack, gh stack, multi-PR features, or stack review workflows.
---

# GitHub Stack PRs

Usa esta skill cuando una feature deba dividirse en varias PRs encadenadas.

Decision:

- GitHub Stack es el mecanismo preferido para `Chained PRs`.
- Si GitHub Stack no esta disponible, no hagas fallback manual sin confirmacion de la persona.
- Cada PR debe ser una slice pequena, revisable y con pruebas propias.

Prechecks no destructivos:

- `gh --version`: confirma GitHub CLI.
- `gh auth status`: confirma autenticacion OAuth.
- `gh stack --help`: confirma extension `github/gh-stack`.
- `gh stack view`: inspecciona stack actual si ya existe; puede fallar si no hay stack.

Disponibilidad:

- GitHub Stacked PRs esta en private preview y debe estar habilitado en el repo.
- Si `gh stack --help` indica que falta la extension, pide aprobacion antes de instalar con `gh extension install github/gh-stack`.
- No ejecutes `gh skill install github/gh-stack` sin aprobacion; modifica configuracion global del usuario.

Flujo recomendado con una sola worktree activa:

1. `gh stack init <first-branch>` para iniciar la cadena.
2. Implementa, prueba y commitea la primera slice.
3. `gh stack add <next-branch>` para crear la siguiente capa.
4. Repite implementacion, pruebas y commits por cada slice.
5. `gh stack push` para publicar ramas cuando la persona lo apruebe.
6. `gh stack submit` para crear o actualizar PRs cuando la persona lo apruebe.
7. `gh stack view` para revisar estado y enlaces.

Flujo recomendado con `wt`:

- Usa `wt` para aislar ramas/worktrees de cada slice.
- Usa `gh stack link --base <base> <branch-1> <branch-2> ...` para crear o actualizar la Stack a partir de ramas gestionadas con `wt`.
- Manten el orden de argumentos de `gh stack link` de bottom a top.
- Si necesitas tracking local de la stack, considera `gh stack init <branch-1> <branch-2> ...` tras confirmar que no rompe el flujo con worktrees.

Comandos utiles:

- `gh stack init [--base <branch>] <branches...>`: inicia o adopta una stack local.
- `gh stack add <branch>`: anade una rama encima de la stack actual.
- `gh stack view [--json]`: muestra ramas, orden y PRs.
- `gh stack push`: pushea todas las ramas de la stack.
- `gh stack submit [--auto] [--open]`: crea o actualiza PRs y la Stack en GitHub.
- `gh stack link [--base <branch>] <branch-or-pr>...`: enlaza ramas o PRs existentes sin tracking local.
- `gh stack sync`: fetch, rebase, push y sincroniza estado.
- `gh stack rebase`: rebase en cascada de la stack.

Reglas de seguridad:

- Considera `gh stack push`, `submit`, `sync`, `rebase`, `modify`, `unstack`, `link --open` e instalaciones como acciones que requieren aprobacion explicita.
- No mezcles varias slices en el mismo commit o PR.
- No cambies bases de PRs manualmente si `gh stack` puede mantenerlas.
- Si el repo devuelve error de preview o exit code 9, bloquea y pide decision.
