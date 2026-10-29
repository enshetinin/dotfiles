# Neovim — Yev (JetBrains)

Configuración personal para **frontend**, **Rust/C** y trabajo con **agentes IA**.
Neovim 0.12 + lazy.nvim. Tema **JetBrains** (Dark / IntelliJ Light), igual que Ghostty.

> Si vuelves aquí tras mucho tiempo: abre nvim, pulsa `<Space>` y espera.
> which-key te enseña todos los atajos agrupados.

---

## Qué hay

| Área | Plugin |
| --- | --- |
| Dashboard, buscador, explorador, notificaciones, lazygit, terminal, zen, guías de indentación, scroll suave | `snacks.nvim` |
| Cmdline y búsqueda flotantes, mensajes en la esquina | `noice.nvim` |
| Autocompletado con iconos, docs y firma | `blink.cmp` |
| Ayuda de atajos | `which-key.nvim` |
| Iconos | `mini.icons` (también responde como `nvim-web-devicons`) |
| Estela animada del cursor | `smear-cursor.nvim` |
| Pares, colores hex + `TODO`/`FIXME`/`HACK`/`NOTE`, surround | `mini.pairs`, `mini.hipatterns`, `mini.surround` |
| LSP | nativo + configs de `nvim-lspconfig` |
| Formato | `conform.nvim` |
| Git | `gitsigns.nvim` + lazygit |
| Archivos | `oil.nvim` (flotante) y el explorador de snacks |
| Markdown / notas | `render-markdown.nvim`, `peek.nvim`, `obsidian.nvim` (fork de la comunidad) |
| Agentes | `claudecode.nvim` |
| Debug | `nvim-dap` |

La statusline es propia (`lua/config/statusline.lua`, sin plugin), plana como la del IDE: modo de
ancho fijo, archivo con icono, rama y cambios de git; a la derecha diagnósticos, `claude`, LSP y posición.
Si no cabe, va quitando lo menos útil (detalles, LSP, conteos, carpetas) en vez de cortar el modo.

## Estructura

```text
nvim/
├── init.lua                 orden: options → autocmds → statusline → keymaps → lazy → lsp
├── colors/jetbrains.lua     tema activo (estilo JetBrains New UI)
├── colors/yev.lua           tema antiguo (Kanagawa), ya no se carga
├── lsp/                     overrides de servidores (se fusionan con nvim-lspconfig)
├── lua/config/
│   ├── options.lua          opciones + carga el tema
│   ├── autocmds.lua         recarga de archivos, sangría frontend, yank, terminal
│   ├── statusline.lua       statusline plana estilo IDE
│   ├── keymaps.lua          atajos generales, agentes, tareas
│   ├── agents.lua           copiar @referencias y diagnósticos
│   ├── tasks.lua            :Build :Run :Test :Lint :Task
│   ├── lsp.lua              diagnósticos, LspAttach, activación de servidores
│   └── lazy.lua             bootstrap de lazy.nvim
└── lua/plugins/
    ├── ui.lua               snacks, noice, which-key, mini.icons, smear-cursor
    ├── completion.lua       blink.cmp
    ├── editor.lua           mini.pairs, mini.hipatterns, mini.surround, mini.ai, flash
    ├── ai.lua               claudecode.nvim
    ├── format.lua           conform.nvim
    ├── lsp.lua              nvim-lspconfig (solo aporta configs)
    ├── treesitter.lua       parsers + autotag
    ├── gitsigns.lua
    ├── oil.lua
    ├── markdown.lua         render-markdown + peek
    ├── obsidian.lua
    ├── mermaid.lua
    └── nvim-dap.lua
```

## Dependencias

```sh
brew install neovim git lazygit ripgrep fd tree-sitter llvm deno
brew install --cask font-jetbrains-mono-nerd-font
```

Servidores y formateadores (ninguno es obligatorio; si falta un binario, el servidor no arranca):

```sh
npm i -g typescript-language-server typescript vscode-langservers-extracted \
  @tailwindcss/language-server @olrtg/emmet-language-server @fsouza/prettierd
brew install lua-language-server stylua
rustup component add rust-analyzer rust-src rustfmt clippy
```

Comprobar estado: `:checkhealth`, `:Lazy`, `:ConformInfo`, `:checkhealth vim.lsp`.

---

## Atajos

Leader = `Space`.

### General

| Atajo | Acción |
| --- | --- |
| `<leader>w` / `<leader>q` | guardar / cerrar ventana |
| `<C-h/j/k/l>` | moverse entre ventanas (también desde terminal) |
| `<S-h>` / `<S-l>` | buffer anterior / siguiente |
| `<leader>bd` / `<leader>bo` | cerrar buffer / cerrar los demás |
| `<C-/>` | terminal flotante |
| `-` | oil flotante (directorio del archivo) |
| `<leader>e` | árbol de archivos |
| `<leader>z` | modo zen |
| `J` / `K` (visual) | mover líneas |
| `gsa` / `gsd` / `gsr` | añadir / borrar / cambiar surround |
| `s` + 2 letras + etiqueta | saltar a cualquier sitio (flash) |
| `S` | seleccionar nodo de treesitter (flash) |
| `vaf` / `cif` / `dia` | función entera / cuerpo / argumento (también `c` clase, `o` bloque, `u` llamada, `t` tag) |
| `]f` / `[f` | función siguiente / anterior (`]F` final, `]k` clase) |
| `F5` / `<leader>dc` | debug: iniciar / continuar (lldb-dap; compila antes) |
| `<leader>db` / `dB` | breakpoint / breakpoint condicional |
| `<leader>dv` / `dw` | panel de debug / vigilar expresión |
| `]]` / `[[` | siguiente / anterior referencia de la palabra |

### Buscar

| Atajo | Acción |
| --- | --- |
| `<leader><space>` | búsqueda inteligente (recientes + archivos) |
| `<leader>ff` / `fo` | archivos / recientes |
| `<leader>fg` / `fw` | grep / palabra bajo el cursor |
| `<leader>fb` | buffers |
| `<leader>fr` | reabrir la última búsqueda |
| `<leader>fd` | diagnósticos |
| `<leader>fs` / `fS` | símbolos del documento / workspace |
| `<leader>fh` / `fk` | ayuda / atajos |
| `<leader>fu` | historial de undo |
| `<leader>fn` | historial de notificaciones |
| `<leader>fc` | archivos de esta config |

### Código / LSP

| Atajo | Acción |
| --- | --- |
| `gd` / `gD` / `gy` | definición / declaración / tipo |
| `grr` / `gri` | referencias / implementaciones (en el buscador) |
| `K` | documentación |
| `<leader>rn` | renombrar |
| `<leader>ca` | code actions |
| `<leader>cd` | diagnóstico de la línea |
| `<leader>cf` | formatear |
| `<leader>ch` | inlay hints |

Autocompletado: `<C-space>` abrir · `<C-n>`/`<C-p>` moverse · `<C-y>` aceptar · `<C-e>` cerrar.

### Git — `<leader>g`

| Atajo | Acción |
| --- | --- |
| `gg` | lazygit flotante (también `:Lazygit`) |
| `gf` | historial del archivo en lazygit |
| `gl` / `gS` | log / status en el buscador |
| `gB` | abrir el archivo en GitHub |
| `]h` / `[h` | siguiente / anterior cambio |
| `gp` / `gs` / `gr` / `gu` | preview / stage / descartar / deshacer stage |
| `gb` / `gd` / `gq` | blame / diff / cambios al quickfix |

### UI — `<leader>u`

| Atajo | Acción |
| --- | --- |
| `ub` | tema claro / oscuro |
| `ut` | fondo transparente / sólido |
| `us` | estela del cursor |
| `ud` / `ug` / `uD` | diagnósticos / guías de indentación / atenuar fuera del bloque |
| `uw` / `ul` | wrap / números relativos |
| `un` | cerrar notificaciones |
| `uf` | formato al guardar |

### Agentes — `<leader>a`

| Atajo | Acción |
| --- | --- |
| `ac` / `af` | abrir / enfocar Claude Code |
| `ar` / `aC` | reanudar / continuar sesión |
| `am` | elegir modelo |
| `ab` / `as` | añadir buffer / enviar selección |
| `aa` / `ad` | aceptar / rechazar diff |
| `ay` | copiar `@ruta#L10-24` (sirve para cualquier agente) |
| `ax` | copiar diagnósticos como texto |

Los archivos que editan los agentes se recargan solos al volver a nvim.

### Tareas — `<leader>t`

`tb` build · `tr` run / dev server · `tt` test · `tl` lint. Detectan frontend (gestor según
lockfile), Rust y C/C++. `:Task <comando>` ejecuta cualquier cosa en la raíz del proyecto.

### Markdown — `<leader>m`

`mt` alternar renderizado · `me` / `mc` expandir / contraer · `mp` preview en el navegador.

### Debug

`F5` continuar · `F9` breakpoint · `F10` / `F11` / `S-F11` step over / into / out.

---

## Tema (JetBrains)

`colors/jetbrains.lua` imita los IDEs de JetBrains (New UI): esquema "Dark" en oscuro e "IntelliJ Light" en claro. Como en el IDE, casi todo el código va en el color normal y solo se colorean palabras clave, strings, números, declaraciones, campos y anotaciones. Ghostty usa `themes/jetbrains-dark` / `themes/jetbrains-light`.

- `<leader>ub` alterna claro/oscuro · `<leader>ut` alterna transparencia.
- Barra de estado como la del IDE (`lua/config/statusline.lua`): modo, ruta `… › a › b › archivo` (últimas 3 carpetas), git · diagnósticos, LSP, `línea:col`, `LF`, `UTF-8`, indentación. En picker, explorador, Lazy o terminal muestra solo su nombre.
- Para cambiar colores: edita la paleta `p` al principio de `colors/jetbrains.lua`.
