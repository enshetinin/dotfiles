# Neovim

Configuración personal para **frontend**, **Rust/C** y trabajo con **agentes IA**.
Basada en Neovim 0.12 nativo (LSP, completado, snippets) + pocos plugins.
Visualmente sigue **Yev Design**: Ink / Paper / Signal, geometría rectilínea, jerarquía
por tipografía y no por color.

> Si vuelves aquí tras mucho tiempo: abre nvim y pulsa `<Space>` y espera.
> `mini.clue` te enseña todos los atajos agrupados.

---

## Índice

- [Estructura](#estructura)
- [Dependencias](#dependencias)
- [Atajos](#atajos)
- [Agentes IA](#agentes-ia)
- [Frontend](#frontend)
- [Tareas](#tareas)
- [Tema `yev`](#tema-yev)
- [Cómo extender](#cómo-extender)
- [Problemas comunes](#problemas-comunes)

---

## Estructura

```text
nvim/
├── init.lua                 orden de carga (ver abajo)
├── colors/yev.lua           colorscheme propio (oscuro + claro)
├── lsp/                     overrides de servidores LSP (se fusionan con nvim-lspconfig)
│   ├── clangd.lua
│   ├── lua_ls.lua
│   └── rust_analyzer.lua    clippy como check
├── lua/config/
│   ├── options.lua          opciones + carga el tema
│   ├── autocmds.lua         recarga de archivos, sangría frontend, yank, terminal
│   ├── statusline.lua       statusline nativa (sin plugin)
│   ├── keymaps.lua          atajos generales, lazygit, tareas
│   ├── agents.lua           copiar @referencias y diagnósticos para agentes
│   ├── tasks.lua            :Build :Run :Test :Lint :Task
│   ├── lsp.lua              diagnósticos, LspAttach, activación de servidores
│   └── lazy.lua             bootstrap de lazy.nvim
└── lua/plugins/             un archivo por área
    ├── ai.lua               claudecode.nvim
    ├── format.lua           conform.nvim (biome / prettier / LSP)
    ├── lsp.lua              nvim-lspconfig (solo aporta configs)
    ├── treesitter.lua       parsers + autotag HTML/JSX
    ├── mini.lua             pairs, hipatterns (colores hex), clue (ayuda de atajos)
    ├── pick.lua             mini.pick (buscador)
    ├── gitsigns.lua
    ├── oil.lua              explorador de archivos
    ├── markdown.lua         render-markdown + peek (preview con mermaid)
    ├── obsidian.lua         vault en ~/Desktop/personal/personal_brain/notes
    ├── mermaid.lua
    └── nvim-dap.lua         debugger (sin adaptadores configurados aún)
```

**Orden de carga** (`init.lua`): options → autocmds → statusline → keymaps → lazy → lsp.
`config.lsp` va **después** de lazy porque necesita las configs de `nvim-lspconfig`
en el runtimepath.

---

## Dependencias

Base (también en el README raíz de los dotfiles):

```sh
brew install neovim git lazygit ripgrep fd tree-sitter llvm deno
```

- `tree-sitter` CLI: lo usa nvim-treesitter (rama `main`) para compilar parsers.
- `deno`: para compilar `peek.nvim` (preview de markdown).

Servidores y formateadores:

```sh
# frontend
npm i -g typescript-language-server typescript \
  vscode-langservers-extracted \
  @tailwindcss/language-server \
  @olrtg/emmet-language-server \
  @fsouza/prettierd

# lua
brew install lua-language-server stylua

# rust (rustup)
rustup component add rust-analyzer rust-src rustfmt clippy
```

Agentes: [Claude Code](https://docs.claude.com/claude-code) (`claude` en el PATH).

> Ningún servidor es obligatorio. Si un binario no existe (ni global ni en
> `node_modules/.bin` del proyecto) el servidor simplemente no arranca, sin errores.
> Biome, eslint y tailwind se suelen instalar **por proyecto** y se detectan solos.

Comprobar estado: `:checkhealth`, `:Lazy`, `:ConformInfo`, `:checkhealth vim.lsp`.

---

## Atajos

Leader = `Space`. Local leader = `\`.

### General

| Atajo | Acción |
| --- | --- |
| `<leader>w` / `<leader>q` | guardar / cerrar ventana |
| `<Esc>` | quitar resaltado de búsqueda |
| `<C-h/j/k/l>` | moverse entre ventanas (también desde terminal) |
| `<Esc><Esc>` | salir del modo terminal |
| `J` / `K` (visual) | mover líneas seleccionadas |
| `<` / `>` (visual) | indentar manteniendo la selección |
| `-` | abrir oil (directorio del archivo) |
| `<leader>ub` | alternar tema claro / oscuro |
| `<leader>uf` | activar / desactivar formato al guardar |

### Buscar — `<leader>f`

| Atajo | Acción |
| --- | --- |
| `ff` | archivos |
| `fg` | grep en vivo (requiere `rg`) |
| `fw` | grep de la palabra bajo el cursor |
| `fb` | buffers |
| `fh` | ayuda |
| `fr` | reabrir la última búsqueda |

### Código / LSP

| Atajo | Acción |
| --- | --- |
| `gd` / `gD` | definición / declaración |
| `K` | documentación |
| `<leader>rn` | renombrar símbolo |
| `<leader>ca` | code actions (normal y visual) |
| `<leader>cf` | formatear archivo / selección |
| `<leader>ch` | alternar inlay hints |
| `<leader>e` | diagnóstico flotante de la línea |
| `<C-Space>` (insert) | forzar completado |
| `<C-n>` / `<C-p>` / `<C-y>` | navegar / aceptar completado (nativo) |

Defaults de nvim 0.12 que conviene recordar: `grr` referencias, `gri` implementación,
`gra` code action, `grn` renombrar, `gO` símbolos del documento, `[d` / `]d` diagnósticos,
`<C-s>` (insert) signature help.

### Git — `<leader>g`

| Atajo | Acción |
| --- | --- |
| `gg` | lazygit en una pestaña nueva (`:Lazygit`) |
| `]h` / `[h` | siguiente / anterior cambio |
| `gp` | previsualizar cambio |
| `gs` / `gr` | stage / descartar cambio (o selección en visual) |
| `gu` | deshacer último stage |
| `gb` | blame de la línea |
| `gd` | diff del archivo |
| `gq` | cambios del archivo al quickfix |

### Markdown — `<leader>m`

| Atajo | Acción |
| --- | --- |
| `mt` | alternar renderizado en el buffer |
| `me` / `mc` | expandir / contraer texto original |
| `mp` | preview en navegador (con mermaid) |

### Debug — `<leader>d` y teclas F

`F5` continuar · `F9` breakpoint · `F10` step over · `F11` step into · `S-F11` step out ·
`<leader>db` breakpoint · `<leader>dr` REPL · `<leader>dt` terminar.

> nvim-dap no tiene adaptadores configurados todavía (ni `codelldb` ni `js-debug`).

---

## Agentes IA

Dos capas: integración específica con **Claude Code** y utilidades que sirven con
**cualquier** agente.

### Claude Code — `<leader>a`

`claudecode.nvim` hace que el CLI `claude` use nvim como su IDE (el mismo protocolo que
la extensión de VS Code): ve tu selección, los diagnósticos y propone cambios como
**diffs nativos** que aceptas o rechazas.

| Atajo | Acción |
| --- | --- |
| `ac` | abrir / cerrar Claude (split derecho, 38 %) |
| `af` | enfocar Claude |
| `ar` | reanudar sesión (`--resume`) |
| `aC` | continuar la última (`--continue`) |
| `am` | elegir modelo |
| `ab` | añadir el buffer actual al contexto |
| `as` | enviar selección (visual) · añadir archivo (en oil) |
| `aa` / `ad` | aceptar / rechazar el diff propuesto |

El plugin se carga solo al usarlo. Cuando está conectado aparece `claude` en la statusline.

### Para cualquier agente

| Atajo | Acción |
| --- | --- |
| `<leader>ay` | copia `@ruta/archivo.tsx` (o `#L10-24` si hay selección) |
| `<leader>ax` | copia los diagnósticos de la línea (o del archivo) como texto |

Pegas eso en Claude, Codex, opencode, un chat… y sabe exactamente a qué te refieres.

### Recarga automática

Los agentes escriben archivos desde fuera. `autoread` + `checktime` en `FocusGained`,
`BufEnter`, `CursorHold` y `TermLeave` recargan los buffers y avisan con
"Recargado desde disco: …". Si tenías cambios sin guardar en ese buffer, nvim pregunta.

---

## Frontend

- **LSP**: ts_ls, html, cssls, jsonls, eslint, tailwindcss, emmet, biome (cada uno solo si
  está instalado). Configs base de `nvim-lspconfig`.
- **Formato al guardar** (`conform.nvim`): `biome` si hay `biome.json` en el proyecto,
  si no `prettierd` → `prettier`, y si no hay ninguno, el formateador del LSP.
  Usa binarios de `node_modules` cuando existen.
- **Treesitter**: html, css, scss, js, ts, tsx, jsdoc, json, astro, svelte, vue, graphql…
  Se instalan solos al arrancar si faltan (`:TSUpdate` para actualizar).
- **Autotag**: cierra y renombra etiquetas HTML/JSX.
- **Colores hex** (`#FF4D1F`) se pintan en línea en cualquier archivo.
- **Sangría**: 2 espacios en archivos frontend, json, yaml y markdown; 4 en el resto.
  Un `.editorconfig` en el proyecto siempre manda.

---

## Tareas

Detectan el tipo de proyecto por el `filetype` del buffer y se ejecutan en la raíz del
proyecto, en una terminal abajo.

| Atajo | Comando | Frontend | Rust | C / C++ |
| --- | --- | --- | --- | --- |
| `<leader>tb` | `:Build` | script `build` | `cargo build` | `make` o `clang` directo |
| `<leader>tr` | `:Run` | `dev` → `start` → `preview` | `cargo run` | compila y ejecuta |
| `<leader>tt` | `:Test` | `test` → `test:unit` | `cargo test` | `make test` |
| `<leader>tl` | `:Lint` | `lint` → `check` → `typecheck` | `cargo clippy` | — |

- En frontend usa el **primer script que exista** en `package.json`, y el gestor según
  el lockfile: `pnpm-lock.yaml` → pnpm, `bun.lock(b)` → bun, `yarn.lock` → yarn, si no npm.
- `:Task <comando>` ejecuta cualquier cosa en la raíz del proyecto (`:Task pnpm add zod`).

---

## Tema `yev`

`colors/yev.lua`, sin dependencias. Cargado desde `options.lua`.

| Token | Oscuro | Claro | Uso |
| --- | --- | --- | --- |
| Ink | `#11100E` | texto | fondo oscuro |
| Paper | texto fuerte | `#F2EFE8` | fondo claro |
| Signal | `#FF4D1F` | `#FF4D1F` | **solo orientación** |

Reglas que sigue (por si lo tocas):

- **Signal es tinta, no "color primario".** Solo aparece en: número de la línea actual,
  match de búsqueda actual, `TODO`, H1 de markdown, marca `▌` de la statusline y prompt
  del buscador. Nada más. Si añades algo con Signal, quita otra cosa.
- **Semánticos separados**: error, warn, info, hint tienen sus propios colores; el error
  nunca usa Signal.
- **Sintaxis casi neutra**: keywords en arena, funciones definidas en negrita, strings /
  constantes / tipos con poco croma. En HTML/JSX las etiquetas usan el color de tipo.
- **Contraste**: todo el texto ≥ 4.5:1 (AA) en ambos modos. Las líneas no actuales
  numeradas ~3.3:1.
- **Nunca solo color**: diagnósticos con forma (`■ ▲ ● ·`) y letra en la statusline
  (`E2 W1`); el modo se escribe en palabra.
- **Rectilíneo**: `winborder = "single"`, sin bordes redondeados.

Opciones:

```lua
vim.g.yev_transparent = true  -- deja ver el fondo del terminal (solo en oscuro)
vim.o.background = "light"    -- o <leader>ub
```

La statusline (`lua/config/statusline.lua`) usa los grupos `YevStatus*` del tema.
Izquierda: marca, modo, ruta (atenuada) + archivo, estado. Derecha: diagnósticos,
claude, LSP activos, rama, posición. `laststatus = 3` (una sola global).

---

## Cómo extender

**Añadir un servidor LSP**

1. Instalar el binario.
2. Añadirlo a la tabla `servers` de `lua/config/lsp.lua` (`nombre = "binario"`).
   El nombre es el de `nvim-lspconfig` (`:help lspconfig-all`).
3. Si necesitas ajustes propios, crea `lsp/<nombre>.lua`; se fusiona con la config base.

**Añadir un formateador**: en `lua/plugins/format.lua` → `formatters_by_ft`.

**Añadir un parser**: en la lista `parsers` de `lua/plugins/treesitter.lua`.

**Añadir un grupo de atajos**: definir los atajos y añadir la entrada
`{ mode = "n", keys = "<Leader>x", desc = "+grupo" }` en `clues` de `lua/plugins/mini.lua`.

**Plugins**: un archivo por área en `lua/plugins/`. Versiones fijadas en
`lazy-lock.json` (`:Lazy sync` actualiza, `:Lazy restore` vuelve al lock).

---

## Problemas comunes

| Síntoma | Causa probable |
| --- | --- |
| Un servidor no arranca | binario no instalado → `:checkhealth vim.lsp` |
| No formatea al guardar | `<leader>uf` desactivado, o sin prettier/biome → `:ConformInfo` |
| Sin colores de sintaxis | parser no instalado → `:TSUpdate` (requiere `tree-sitter` CLI) |
| `peek` no abre | falta `deno` o no se compiló → `:Lazy build peek.nvim` |
| Claude no conecta | `claude` fuera del PATH, o abrir con `<leader>ac` desde nvim |
| Archivo editado por un agente no se actualiza | volver a la ventana de nvim o `:checktime` |
| Iconos raros en markdown | la fuente del terminal no es Nerd Font |

**Deuda conocida**

- `obsidian.nvim` (epwalsh) está archivado y arrastra `nvim-cmp` solo por él.
  Alternativa: el fork `obsidian-nvim/obsidian.nvim`.
- `nvim-dap` sin adaptadores.
- La fuente de código de Yev Design es *Atkinson Hyperlegible Mono*; Alacritty sigue con
  JetBrains Mono Nerd Font.
