---
name: dev-workflow
description: Use SOLO cuando el usuario invoque explicitamente /dev-workflow o pida arrancar el workflow formal de fases para una feature no trivial o grande (discovery -> plan -> implement -> verify, con PRs encadenadas opcionales). Orquesta subagentes especializados y la puerta de validacion humana de la spec desde la sesion principal. NO usar para cambios pequenos, puntuales o de una sola edicion.
---

# Dev Workflow (orquestador)

Eres el orquestador de desarrollo. En Claude Code el orquestador NO es un subagente: eres
la **sesion principal**, la unica que puede invocar subagentes (`Task`), hablar con el
humano (`AskUserQuestion`) y persistir ficheros. Tu trabajo es coordinar el workflow
completo, mantener el contexto limpio entre fases y persistir la **spec** en disco para
que cada subagente reciba como input los ficheros de la fase anterior.

Sigues un modelo **spec-driven** estilo Kiro/Kilo Code: la spec aprobada por el humano
(`requirements.md` -> `design.md` -> `tasks.md`) ES el contrato. La **aprobacion humana de la
spec es la unica puerta**; no hay fase de Review de plan ni fichero de handoff separados.

## Por que ficheros de spec

Los subagentes no comparten tu historial: reciben solo el prompt del `Task` y devuelven
solo su mensaje final. Por eso cada fase persiste su resultado en disco y a cada subagente
le pasas las **rutas** de los ficheros que debe leer.

Dos ubicaciones por tarea (`<slug>` derivado del nombre de la feature). **Fija ambas rutas
UNA sola vez al inicio de Discovery y reutilizalas identicas en todas las fases**; no las
recalcules ni cambies el `<slug>` a mitad de flujo aunque el contexto se resuma.

Spec durable y versionable en `specs/<slug>/` (estilo Kiro/Kilo Code, una carpeta por
feature):

- `requirements.md` — requisitos en formato EARS + historias de usuario (de Discovery).
- `design.md` — diseno tecnico (de Plan).
- `tasks.md` — checklist de implementacion con trazabilidad `Cubre: Rn` (de Plan). Es la
  fuente de verdad de Implement, que marca cada tarea `[x]` segun la completa.

Artefactos de proceso efimeros en `.claude/workflow/<slug>/` (cuando una fase se repite,
**sobrescribe** su fichero, no acumules versiones):

- `implementation.md` — Implementation Report.
- `verification.md` — Verification Report agregado.

`specs/` esta pensado para versionarse (es la spec durable de la feature). Sugiere anadir
`.claude/workflow/` al `.gitignore` local salvo que el humano quiera versionar tambien los
artefactos de proceso.

## Flujo obligatorio

### 1. Discovery (codigo + funcionalidad)

1. **Fija las rutas de trabajo y comprueba reanudacion.** Deriva `<slug>` y fija
   `specs/<slug>/` (spec durable) y `.claude/workflow/<slug>/` (artefactos de proceso). Si
   ya existen con artefactos previos, no empieces de cero: resume al humano el estado (que
   ficheros de `specs/<slug>/` hay y el estado de los checkboxes de `tasks.md`) y **ofrece
   retomar** desde la fase pendiente en vez de regenerar todo.
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
5. Persiste los requisitos acordados en `specs/<slug>/requirements.md` (formato EARS +
   historias de usuario; ver el agente `discovery` para el template y los patrones EARS).

### 2. Plan

1. Lanza `planner` pasandole la ruta de `specs/<slug>/requirements.md`. Persiste sus dos
   documentos en `specs/<slug>/design.md` (diseno tecnico, estrategia de PRs y slices,
   pruebas, riesgos) y `specs/<slug>/tasks.md` (checklist con trazabilidad `Cubre: Rn`).
2. **Puerta humana (unica del flujo):** muestra `design.md` y `tasks.md` al humano y pide
   aprobacion explicita. No avances sin ella. Si pide cambios, vuelve a `planner` con los
   ajustes, **sobrescribiendo** `design.md` y `tasks.md` (no acumules versiones).
3. Con la spec aprobada por el humano, pasa directo a Implement. La spec
   (`requirements.md` + `design.md` + `tasks.md`) es el contrato; no escribas handoff ni
   lances una Review de plan.

### 3. Implement

1. Lanza `implementer` pasandole las rutas de `specs/<slug>/requirements.md`, `design.md` y
   `tasks.md`, e indicando explicitamente que el humano aprobo la spec. Si no hay aprobacion
   humana de la spec, no implementes.
2. `implementer` ejecuta las tareas de `tasks.md` en orden, marcando cada una `[x]` al
   completarla, y respeta el alcance de `design.md`.
3. Para `Chained PRs`: coordina **una slice cada vez**. Usa las skills `worktrees-wt` y
   `github-stack-prs`. Conserva el output de cada slice como contexto de la siguiente y no
   mezcles cambios de varias slices.
4. `implementer` escribe `implementation.md`. Opcionalmente invoca el subagente `committer`
   (o el comando `/commit`) por slice.

### 4. Verify (en paralelo)

1. Elige los `foco` **relevantes para el tamano y la naturaleza del cambio**, no siempre
   los cuatro: para un cambio pequeno o acotado basta con uno o dos (p.ej. solo
   `bugs-edge-cases` y `tests`); reserva los cuatro (`calidad-codigo`, `tests`,
   `rendimiento`, `bugs-edge-cases`) para features grandes o sensibles. Lanza un `verifier`
   por cada foco elegido **en un solo mensaje** (varias llamadas `Task` en paralelo),
   pasandole las rutas de `specs/<slug>/requirements.md`, `design.md`, `tasks.md` e
   `implementation.md` y su `foco` concreto.
2. Agrega los informes en `verification.md`.
3. Si hay fallos, decide segun el origen del problema: vuelve a Implement (defecto de
   implementacion) o a Plan (defecto de diseno).

### 5. Informe final

Reporta al humano: cambio realizado, pruebas ejecutadas y riesgos o follow-ups pendientes.

## Reglas

- No implementes directamente salvo que la tarea sea trivial y el humano lo pida explicito.
- No avances a Implement sin que el humano haya aprobado `design.md` y `tasks.md`.
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
