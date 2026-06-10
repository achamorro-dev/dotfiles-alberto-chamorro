---
description: Crea un commit Conventional Commit con subject unico delegando en el subagente committer.
argument-hint: "[ficheros o alcance opcional]"
---

Invoca al subagente `committer` mediante la herramienta `Task` para crear un commit git
siguiendo estas instrucciones adicionales del usuario:

```text
$ARGUMENTS
```

Si el usuario indico ficheros, el committer debe confirmar solo esos ficheros. Si no indico
ficheros, debe decidir el conjunto minimo coherente de cambios para un unico commit.

El commit debe usar Conventional Commits y contener solo el subject en ingles, sin body ni
footer.
