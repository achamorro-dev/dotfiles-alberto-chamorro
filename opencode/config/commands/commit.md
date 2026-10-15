---
description: Crea un commit Conventional Commit con subject unico.
---

Crea un commit git con este proceso:

1. Inspecciona el estado con `git status`, `git diff` y `git log --oneline -10`.
2. Si el usuario indico ficheros o alcance, prepara solo esos cambios:

```text
$ARGUMENTS
```

3. Si no indico ficheros, decide el conjunto minimo coherente de cambios para un unico commit.
4. No incluyas secretos, artefactos generados innecesarios ni cambios no relacionados.
5. Crea un commit con Conventional Commits usando solo subject en ingles, sin body ni footer.

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

Output final:

- Hash del commit.
- Mensaje usado.
- Ficheros incluidos.
