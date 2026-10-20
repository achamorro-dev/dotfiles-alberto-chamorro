# Temas sincronizados

Una pareja de temas para **VSCode, Cursor, Ghostty, OpenCode V2 y Neovim/LazyVim**:

- **Xcode Pitch Dark Theme**: tu tema original, con fondo negro puro.
- **Xcode Pitch Light**: fondo blanco, comentarios verdes, cadenas rojas y acentos magenta/cian/violeta. Los colores principales de texto y sintaxis superan un contraste de 4.5:1 sobre blanco.
- **Ayu Light**: alternativa oficial; conserva su paleta, no se le aplica el ajuste de contraste de Xcode Light.

Los temas de VSCode/Cursor pertenecen a sus extensiones oficiales. Estos dotfiles seleccionan el tema y generan sus adaptaciones para las aplicaciones de terminal; no empaquetan otra copia de la extensión.

## Instalación y uso

```sh
python3 ~/.dotfiles/plugins/dotfiles-alberto-chamorro/themes/theme.py install

# Mientras Xcode Pitch Theme 1.2.0 no esté publicado en Marketplace:
python3 ~/.dotfiles/plugins/dotfiles-alberto-chamorro/themes/theme.py install \
  --pitch-vsix ~/workspace/personal/xcode-pitch-dark-theme/xcode-pitch-dark-theme-1.2.0.vsix

# En una nueva shell, o después de source del archivo zsh/theme.zsh:
theme auto                 # Seguir la apariencia de macOS
theme dark                 # Forzar oscuro en todas las aplicaciones
theme light                # Forzar claro en todas
theme auto --light ayu     # Oscuro Xcode / claro Ayu, según macOS
theme light --light xcode  # Volver a Xcode Light
theme status
```

Requiere Python 3.9+ y las aplicaciones ya instaladas y configuradas. La instalación genera los temas de terminal sin red e instala **Xcode Pitch Theme** (`albertochamorro.xcode-pitch-dark-theme`, versión 1.2.0+) y **Ayu** (`teabyii.ayu`) si faltan. Puede usar Marketplace o un VSIX oficial local para Xcode; no selecciona Light si falta una versión compatible. Modifica **solo los ajustes de tema** de las configuraciones existentes. No instala plugins de Neovim. Las rutas de instalación de los editores gráficos son las habituales de macOS.

La instalación también retira la extensión provisional `albertochamorro.dotfiles-pitch-themes` creada durante la primera implementación, evitando entradas duplicadas en el selector de temas.

La primera vez, recarga las ventanas de VSCode/Cursor y reinicia OpenCode para que descubran los temas nuevos. Neovim necesita reiniciarse una vez para cargar su nueva integración. Después, los cambios de modo se aplican en las sesiones abiertas.

`install` respeta el estado existente; si no existe, usa `auto` con Xcode Light. La alternativa clara se recuerda aunque cambies a oscuro. `--no-reload` permite escribir configuraciones sin intentar recargar Ghostty/Herdr.

## Una referencia común, no una variable global mutable

`~/.config/dotfiles-theme/state.json` (o `$XDG_CONFIG_HOME/dotfiles-theme/state.json`):

```json
{
  "mode": "auto",
  "light": "xcode-light"
}
```

El archivo es la fuente de verdad del **modo y la variante clara**. Usa `theme`, no lo edites directamente: el comando también actualiza los adaptadores.

La sincronización es desde ese punto común hacia las aplicaciones, no bidireccional: elegir otro tema en el selector de una aplicación no cambia las demás.

Zsh expone `DOTFILES_THEME`, `DOTFILES_THEME_LIGHT` y `DOTFILES_THEME_STATE`, actualizadas en cada prompt. Son una instantánea útil para scripts, no la vía de sincronización: cambiar una variable en una shell no modifica el entorno de otras aplicaciones.

No hay LaunchAgent ni demonio global. En `auto`:

| Aplicación | Mecanismo |
| --- | --- |
| VSCode / Cursor | `window.autoDetectColorScheme` y temas preferidos claro/oscuro |
| Ghostty | Selector nativo `dark:xcode-dark,light:xcode-light` (o `ayu-light`) |
| OpenCode V2 | Tema JSON con ambos modos y `theme.mode = system`; sigue la apariencia del terminal |
| Herdr 0.9.5+ | `auto_switch`, base `terminal` y overrides por modo |
| Neovim | Colores locales + estado compartido; comprobación asíncrona de macOS cada cinco segundos |

El modo manual no cambia la apariencia de macOS: fija cada aplicación por separado. Neovim comprueba el estado cada segundo. El comando intenta recargar Ghostty mediante su API AppleScript y Herdr con `server reload-config`, sin cerrar ventanas ni paneles. Si macOS deniega la automatización, recarga Ghostty con **Cmd+S, R**. Si Herdr no actualiza el cliente, usa **Alt+Shift+R**. OpenCode necesita que su terminal comunique correctamente el modo claro/oscuro en `auto`.

## Personalización

- `palettes.json`: roles de color de las adaptaciones para terminales/TUIs.
- [Xcode Pitch Theme](https://github.com/achamorro-dev/xcode-pitch-theme): fuente de los temas de editor y del generador de Light (`palettes/light.json`).
- [Ayu](https://github.com/ayu-theme/vscode-ayu): fuente de la alternativa clara del editor.
- `theme.py`: generadores y adaptadores.
- `generated/`: resultados de terminal; se regeneran y no se versionan.
- `../nvim/config/nvim/lua/config/dotfiles_theme.lua`: resaltado clásico, Treesitter, LSP y seguimiento del estado.

Después de cambiar la paleta de terminal, ejecuta `theme install` para regenerar y reinstalar. Los cambios de los temas del editor se hacen en sus repositorios, no aquí. Para inspeccionar los resultados sin cambiar configuraciones, usa `theme build`. Las reglas de sintaxis entre VSCode, Treesitter y las TUIs no tienen una correspondencia exacta: se comparten roles y colores, no un motor de resaltado.

Las configuraciones actuales de Ghostty, OpenCode, Herdr y Cursor son enlaces a este repositorio. Los cambios manuales de modo también aparecerán como cambios de sus ajustes de tema en Git. Las configuraciones ajenas al tema y los enlaces se conservan. Los ajustes de un proyecto/perfil de VSCode pueden prevalecer sobre los ajustes de usuario; los perfiles no predeterminados no se modifican.

Antes de la primera modificación de cada archivo se guarda `*.before-dotfiles-theme` junto al destino real del enlace. No se sobrescribe esa copia en sucesivas ejecuciones. Para deshacerlo, restaura esas copias sobre los archivos originales; desactiva también `lua/plugins/theme.lua` en Neovim y vuelve a tu colorscheme anterior. La extensión y los temas generados pueden dejarse instalados sin activarlos.

## Validación

```sh
python3 -m unittest discover -s themes -v
zsh -n zsh/theme.zsh
ghostty +validate-config
```

La prueba `test_nvim.lua` debe ejecutarse con `DOTFILES_THEME_TEST=1`, `XDG_CONFIG_HOME` temporal y `DOTFILES_THEME_PALETTES` apuntando a `palettes.json`; escribe exclusivamente en ese directorio temporal.

## Fuentes y licencias

Las paletas de las adaptaciones se basan en:

- [Xcode Pitch Theme](https://github.com/achamorro-dev/xcode-pitch-theme), cuya paleta Dark procede del commit `d2b2e5f8245d86b46b00560db8d26693578c1208`, MIT (`upstream/xcode-LICENSE.txt`).
- [Ayu](https://github.com/ayu-theme/vscode-ayu), commit `7f438df22446f02e79cdfc2f3771b0b273f34654`, MIT (`upstream/ayu-LICENSE.txt`).

Se conservan ambas licencias por atribución. Los dotfiles no publican extensiones en Marketplace.
