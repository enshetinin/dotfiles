# Ghostty — atajos

Config: `config` · Tema: `themes/yev` (Yev Neon)
Abrir config: `Cmd+,` · Recargar: `Cmd+Shift+,`

## Pestañas

| Acción                       | Atajo                     |
| ---------------------------- | ------------------------- |
| Nueva pestaña                | `Cmd+T`                   |
| Cerrar pestaña / split       | `Cmd+W`                   |
| Pestaña siguiente / anterior | `Cmd+Shift+]` / `Cmd+Shift+[` |
| Pestaña siguiente / anterior | `Ctrl+Tab` / `Ctrl+Shift+Tab` |
| Ir a la pestaña N            | `Cmd+1` … `Cmd+9`         |
| Nueva ventana                | `Cmd+N`                   |
| Cerrar ventana               | `Cmd+Shift+W`             |

## Splits

| Acción                         | Atajo               |
| ------------------------------ | ------------------- |
| Dividir a la derecha           | `Cmd+D`             |
| Dividir hacia abajo            | `Cmd+Shift+D`       |
| Moverse (estilo vim)           | `Cmd+Alt+H/J/K/L`   |
| Moverse con flechas            | `Cmd+Alt+←↓↑→`      |
| Split anterior / siguiente     | `Cmd+[` / `Cmd+]`   |
| Maximizar / restaurar split    | `Cmd+Shift+Enter`   |
| Igualar tamaños                | `Cmd+Shift+E` / `Cmd+Ctrl+=` |
| Redimensionar                  | `Cmd+Ctrl+←↓↑→`     |

## Ventana

| Acción                         | Atajo          |
| ------------------------------ | -------------- |
| Pantalla completa              | `Cmd+Enter`    |
| Terminal desplegable (global)  | `` Ctrl+` ``   |

> La terminal desplegable necesita permiso en
> Ajustes del Sistema → Privacidad y seguridad → Accesibilidad → Ghostty.

## Texto y scroll

| Acción                      | Atajo                     |
| --------------------------- | ------------------------- |
| Buscar                      | `Cmd+F`                   |
| Siguiente / anterior resultado | `Cmd+G` / `Cmd+Shift+G` |
| Buscar lo seleccionado      | `Cmd+E`                   |
| Cerrar búsqueda             | `Esc`                     |
| Copiar / pegar              | `Cmd+C` / `Cmd+V`         |
| Copiar al seleccionar       | automático                |
| Limpiar pantalla            | `Cmd+K`                   |
| Seleccionar todo            | `Cmd+A`                   |
| Ir al prompt anterior / siguiente | `Cmd+↑` / `Cmd+↓`   |
| Scroll arriba / abajo del todo | `Cmd+Home` / `Cmd+End` |
| Tamaño de letra             | `Cmd++` / `Cmd+-` / `Cmd+0` |

## Comandos útiles

```sh
ghostty +list-keybinds           # todos los atajos activos
ghostty +list-themes             # temas incluidos (con preview)
ghostty +list-fonts              # fuentes disponibles
ghostty +show-config --default --docs   # todas las opciones documentadas
ghostty +validate-config         # comprobar la config
```

En macOS el binario está en `/Applications/Ghostty.app/Contents/MacOS/ghostty`.
