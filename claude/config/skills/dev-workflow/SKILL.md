---
name: dev-workflow
description: Use SOLO cuando el usuario invoque explicitamente /dev-workflow o pida arrancar el workflow formal de fases para una feature no trivial o grande (discovery -> plan -> review -> implement -> verify, con PRs encadenadas opcionales). Orquesta subagentes especializados y puertas de validacion humana desde la sesion principal. NO usar para cambios pequenos, puntuales o de una sola edicion.
---

# Dev Workflow (orquestador)

Eres el orquestador de desarrollo. En Claude Code el orquestador NO es un subagente: eres
la **sesion principal**, la unica que puede invocar subagentes (`Task`), hablar con el
humano (`AskUserQuestion`) y persistir ficheros. Tu trabajo es coordinar el workflow
completo, mantener el contexto limpio entre fases y persistir los handoffs en disco para
que cada subagente reciba como input el output de la fase anterior.

## Por que ficheros de handoff

Los subagentes no comparten tu historial: reciben solo el prompt del `Task` y devuelven
solo su mensaje final. Por eso cada fase persiste su resultado en disco y a cada subagente
le pasas las **rutas** de los ficheros que debe leer.

Directorio de trabajo por tarea: `.claude/workflow/<slug>/` en el proyecto actual
(`<slug>` derivado del nombre de la feature). **Fija esta ruta UNA sola vez al inicio de
Discovery y reutilizala identica en todas las fases**; no la recalcules ni cambies el
`<slug>` a mitad de flujo aunque el contexto se resuma. Crea estos ficheros segun avanzas
(cuando una fase se repite, **sobrescribe** su fichero, no acumules versiones):

- `discovery.md` — Discovery Brief.
- `plan.md` — Implementation Plan.
- `review.md` — Plan Review.
- `handoff.md` — contrato canonico que lee `implementer` (plan aprobado, ficheros
  permitidos, pasos, pruebas y los flags de validacion).
- `implementation.md` — Implementation Report.
- `verification.md` — Verification Report agregado.

Sugiere anadir `.claude/workflow/` al `.gitignore` local salvo que el humano quiera
versionar los artefactos para trazabilidad.

## Flujo obligatorio

### 1. Discovery (codigo + funcionalidad)

1. **Fija la ruta de trabajo y comprueba reanudacion.** Deriva `<slug>` y fija
   `.claude/workflow/<slug>/`. Si ese directorio ya existe con artefactos previos, no
   empieces de cero: resume al humano el estado (que fases hay y los flags de `handoff.md`)
   y **ofrece retomar** desde la fase pendiente en vez de regenerar todo.
2. Lanza el subagente `discovery` (read-only) para el descubrimiento a nivel de codigo:
   mapa de la zona afectada, patrones existentes, utilidades reutilizables y una lista de
   **preguntas abiertas / ambiguedades / edge cases** para el humano.
3. Con esa lista, conduce TU el **debate socratico** con el humano (`AskUserQuestion` y
   preguntas), llevandolo a casos extremos. Cubre: objetivo real y resultado esperado,
   alcance y limites, edge cases/errores/estados vacios, restricciones (tecnicas, producto,
   seguridad, rendimiento), compatibilidad/migraciones, criterios de aceptacion, y la
   **estrategia de PR** (`Single PR` vs `Chained PRs` con GitHub Stack) y de worktree/`wt`.
4. Pregunta solo dudas que puedan cambiar el plan o evitar retrabajo; para dudas menores
   declara un supuesto en vez de bloquear.
5. Persiste el resultado en `discovery.md` (Discovery Brief).

### 2. Plan

1. Lanza `planner` pasandole la ruta de `discovery.md`. Genera `plan.md` (que se cambia,
   ficheros afectados, que NO se toca, diseno tecnico, estrategia de PRs y slices, pruebas,
   riesgos, pasos de implementacion).
2. **Puerta humana:** muestra el plan al humano y pide aprobacion explicita. No avances
   sin ella. Si pide cambios, vuelve a `planner` con los ajustes.
3. Cuando el humano apruebe, escribe en `handoff.md` el plan aprobado, los ficheros
   permitidos, los pasos y las pruebas esperadas, con el flag
   `Plan validation: APPROVED_BY_USER`.

### 3. Review (del plan)

1. Lanza `reviewer` pasandole la ruta de `plan.md`. Devuelve `APPROVED | REVISION_REQUIRED`
   con comentarios (arquitectura, Lean, Clean Code, riesgos, suficiencia de tests, calidad
   de la estrategia de stack). Persiste en `review.md`.
2. Si `REVISION_REQUIRED`, vuelve a la fase Plan con los comentarios (bucle) hasta resolver,
   **sobrescribiendo** `plan.md` y `review.md` en cada iteracion (no acumules versiones).
3. Si `APPROVED`, muestra la review al humano y pide confirmacion explicita antes de
   implementar. Al confirmar, actualiza `handoff.md` con el flag
   `Review validation: APPROVED_BY_USER`.

### 4. Implement

1. Lanza `implementer` pasandole la ruta de `handoff.md`. Exige que `handoff.md` contenga
   **ambos** flags (`Plan validation: APPROVED_BY_USER` y `Review validation:
   APPROVED_BY_USER`); si faltan, no implementes.
2. Para `Chained PRs`: coordina **una slice cada vez**. Usa las skills `worktrees-wt` y
   `github-stack-prs`. Conserva el output de cada slice como contexto de la siguiente y no
   mezcles cambios de varias slices.
3. `implementer` escribe `implementation.md`. Opcionalmente invoca el subagente `committer`
   (o el comando `/commit`) por slice.

### 5. Verify (en paralelo)

1. Elige los `foco` **relevantes para el tamano y la naturaleza del cambio**, no siempre
   los cuatro: para un cambio pequeno o acotado basta con uno o dos (p.ej. solo
   `bugs-edge-cases` y `tests`); reserva los cuatro (`calidad-codigo`, `tests`,
   `rendimiento`, `bugs-edge-cases`) para features grandes o sensibles. Lanza un `verifier`
   por cada foco elegido **en un solo mensaje** (varias llamadas `Task` en paralelo),
   pasandole las rutas de `plan.md`, `handoff.md` e `implementation.md` y su `foco` concreto.
2. Agrega los informes en `verification.md`.
3. Si hay fallos, decide segun el origen del problema: vuelve a Implement (defecto de
   implementacion) o a Plan (defecto de diseno).

### 6. Informe final

Reporta al humano: cambio realizado, pruebas ejecutadas y riesgos o follow-ups pendientes.

## Reglas

- No implementes directamente salvo que la tarea sea trivial y el humano lo pida explicito.
- No avances a Implement sin plan y review aprobados por el humano en `handoff.md`.
- No implementes una feature grande como un unico cambio si el plan requiere PRs encadenadas.
- Para Chained PRs, GitHub Stack es el mecanismo preferido (skill `github-stack-prs`); si
  no esta instalado/autenticado/habilitado, bloquea o pide confirmacion antes de instalar
  o de hacer fallback manual.
- Con worktrees y `wt`, usa la skill `worktrees-wt` y respeta el worktree y la rama actuales
  salvo instruccion explicita del plan o del humano.
- No ejecutes acciones destructivas de `wt` (`merge`, `remove`) ni de `gh stack` (`push`,
  `submit`, `sync`, `rebase`, `modify`, `unstack`) sin aprobacion explicita.
- Cada fase produce un artefacto que es input de la siguiente; informa al humano solo de
  decisiones, bloqueos o resultado final.
