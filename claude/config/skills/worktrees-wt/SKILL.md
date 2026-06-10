---
name: worktrees-wt
description: Use when working with git worktrees, worktrunk, the wt CLI, chained PRs, branch switching, or isolated feature worktrees.
---

# Worktrees With wt

Usa esta skill cuando una tarea implique worktrees, `wt`, worktrunk o PRs encadenadas.

Para PRs encadenadas, combina esta skill con `github-stack-prs`: `wt` aisla ramas/worktrees
y GitHub Stack organiza las PRs para revision.

Principios:

- Trata cada worktree como un contexto aislado de trabajo.
- Antes de editar, inspecciona `pwd`, `git status --short --branch` y `wt list` si esta
  disponible.
- No cambies de worktree, crees ramas, merges ni elimines worktrees sin que el plan o la
  persona lo indique.
- Para chained PRs, trabaja una slice por worktree/rama y usa GitHub Stack como mecanismo
  de PRs.
- Evita `git add .` si hay cambios no relacionados en el worktree.

Comandos utiles:

- `wt list`: lista worktrees y estado.
- `wt switch <branch>`: cambia a un worktree existente o crea uno para una rama existente.
- `wt switch --create <branch>`: crea rama y worktree desde la rama por defecto.
- `wt switch --create <branch> --base <base>`: crea una slice basada en otra rama o PR.
- `wt switch pr:<N>`: abre el worktree asociado a una PR de GitHub.
- `wt merge [target]`: fusiona la rama actual en target y puede limpiar el worktree.
- `wt remove [branch]`: elimina worktree; puede borrar rama si ya esta integrada.

Reglas de seguridad:

- Considera `wt merge`, `wt remove`, `wt remove -f`, `wt remove -D`, `--clobber` y `--yes`
  como acciones que requieren confirmacion explicita.
- No uses `wt merge` para integrar PRs encadenadas si falta validar la slice actual.
- No uses `wt remove` si el worktree esta sucio o hay dudas sobre el estado de la rama.

Checklist para chained PRs con GitHub Stack:

1. Identifica rama base de la cadena.
2. Define slices pequenas con dependencias lineales.
3. Crea cada slice desde la rama anterior con `wt switch --create <slice> --base <base>`
   cuando este aprobado.
4. Verifica y commitea cada slice antes de avanzar.
5. Usa `gh stack link --base <base> <branch-1> <branch-2> ...` para enlazar ramas
   gestionadas con `wt` cuando la persona apruebe publicar o actualizar PRs.
6. Manten el plan actualizado con rama, base, estado y pruebas por slice.
