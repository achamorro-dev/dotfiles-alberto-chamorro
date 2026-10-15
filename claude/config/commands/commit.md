---
description: Crea un commit Conventional Commit con subject unico.
argument-hint: "[ficheros o alcance opcional]"
---

Crea un commit git siguiendo estas instrucciones adicionales del usuario:

```text
$ARGUMENTS
```

Proceso:

1. Inspecciona el estado con `git status`, `git diff` y `git log --oneline -10`.
2. Si el usuario indico ficheros, confirma solo esos ficheros. Si no indico ficheros, decide el conjunto minimo coherente de cambios para un unico commit.
3. No incluyas secretos, artefactos generados innecesarios ni cambios no relacionados.
4. Crea un commit con Conventional Commits usando solo subject en ingles, sin body ni footer.

Formato del mensaje:

```text
<type>(<scope opcional>): <subject>
```

Tipos permitidos: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `ci`, `build`, `perf`, `revert`.

Reglas:

- El subject debe ser breve, especifico y en imperativo o forma descriptiva consistente.
- El mensaje completo del commit debe estar en ingles.
- No uses body ni footer.
- No uses `git add .` si hay cambios no relacionados.
- No modifiques archivos.
- Si hay ambiguedad sobre que confirmar, pide aclaracion antes de commitear.
