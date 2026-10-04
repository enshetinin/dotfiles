-- Yev — personal colorscheme built on Yev Design System v0.2.
--
-- Ink, Paper and Signal are the foundation. Neutrals stay warm.
-- Syntax is mostly neutral: hierarchy comes from weight, italics and
-- a few low-chroma hues. Yev Signal is ink, not a primary color: it only
-- marks orientation (current line, active window, current match, TODOs,
-- first-level headings). Semantic states never reuse it.
--
-- vim.g.yev_transparent = true  -> let the terminal background show (dark only)

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.g.colors_name = "yev"

local dark = vim.o.background ~= "light"
local transparent = dark and vim.g.yev_transparent == true

local p = dark
        and {
            bg = "#11100E", -- ink
            surface = "#1A1916",
            raised = "#24221E",
            line = "#181714",
            visual = "#332E27",
            edge = "#6B655C",
            separator = "#2E2B27",
            faint = "#4F4A43",
            muted = "#A49E94",
            fg = "#E6E1D6",
            strong = "#F2EFE8", -- paper
            sand = "#C8BDAA",
            signal = "#FF4D1F",

            string = "#B4C29A",
            constant = "#DDB77E",
            type = "#A9BCCB",

            error = "#F0717F",
            warn = "#E2B04F",
            info = "#86B1D9",
            hint = "#9DB89A",
            ok = "#9DB89A",

            add = "#1E2A1C",
            change = "#2A2618",
            delete = "#33191C",
            text = "#3D3520",
        }
    or {
        bg = "#F2EFE8", -- paper
        surface = "#E9E5DC",
        raised = "#DFDAD0",
        line = "#EAE6DD",
        visual = "#DCD3C4",
        edge = "#8B857C",
        separator = "#D3CDC2",
        faint = "#A8A296",
        muted = "#514D47",
        fg = "#11100E", -- ink
        strong = "#000000",
        sand = "#6B5D49",
        signal = "#FF4D1F",

        string = "#4A6633",
        constant = "#875A13",
        type = "#3A5A76",

        error = "#B3263A",
        warn = "#8A5F00",
        info = "#2D5F8F",
        hint = "#3F6B3C",
        ok = "#3F6B3C",

        add = "#DCE6D2",
        change = "#ECE2C6",
        delete = "#F0D6D6",
        text = "#E3D3A8",
    }

local bg = transparent and "NONE" or p.bg

local groups = {
    -- Editor surfaces
    Normal = { fg = p.fg, bg = bg },
    NormalNC = { fg = p.fg, bg = bg },
    NormalFloat = { fg = p.fg, bg = p.surface },
    FloatBorder = { fg = p.edge, bg = p.surface },
    FloatTitle = { fg = p.strong, bg = p.surface, bold = true },
    FloatFooter = { fg = p.muted, bg = p.surface },
    WinSeparator = { fg = p.separator },
    EndOfBuffer = { fg = p.bg, bg = bg },

    Cursor = { fg = p.bg, bg = p.fg },
    CursorLine = { bg = transparent and "NONE" or p.line },
    CursorColumn = { bg = p.line },
    ColorColumn = { bg = p.line },
    CursorLineNr = { fg = p.signal, bold = true },
    LineNr = { fg = p.edge },
    SignColumn = { bg = "NONE" },
    FoldColumn = { fg = p.faint },
    Folded = { fg = p.muted, bg = p.surface, italic = true },

    StatusLine = { fg = p.muted, bg = bg },
    StatusLineNC = { fg = p.faint, bg = bg },
    TabLine = { fg = p.muted, bg = bg },
    TabLineFill = { bg = bg },
    TabLineSel = { fg = p.strong, bg = bg, bold = true, underline = true },
    WinBar = { fg = p.muted, bg = bg },
    WinBarNC = { fg = p.faint, bg = bg },

    Pmenu = { fg = p.fg, bg = p.surface },
    PmenuSel = { fg = p.strong, bg = p.raised, bold = true },
    PmenuKind = { fg = p.muted, bg = p.surface },
    PmenuKindSel = { fg = p.fg, bg = p.raised },
    PmenuExtra = { fg = p.muted, bg = p.surface },
    PmenuExtraSel = { fg = p.fg, bg = p.raised },
    PmenuMatch = { fg = p.strong, bg = p.surface, bold = true, underline = true },
    PmenuMatchSel = { fg = p.strong, bg = p.raised, bold = true, underline = true },
    PmenuSbar = { bg = p.surface },
    PmenuThumb = { bg = p.edge },
    ComplMatchIns = { fg = p.muted },

    Visual = { bg = p.visual },
    VisualNOS = { bg = p.visual },
    Search = { fg = p.strong, bg = p.raised, underline = true },
    -- Ink on Signal reads at 5.7:1 in both modes
    IncSearch = { fg = "#11100E", bg = p.signal, bold = true },
    CurSearch = { fg = "#11100E", bg = p.signal, bold = true },
    Substitute = { fg = p.bg, bg = p.sand },
    MatchParen = { fg = p.strong, bold = true, underline = true },

    NonText = { fg = p.faint },
    Whitespace = { fg = p.separator },
    SpecialKey = { fg = p.faint },
    Conceal = { fg = p.muted },
    Directory = { fg = p.fg, bold = true },
    Title = { fg = p.strong, bold = true },
    Question = { fg = p.fg, bold = true },
    MoreMsg = { fg = p.fg, bold = true },
    ModeMsg = { fg = p.fg, bold = true },
    MsgArea = { fg = p.fg },
    ErrorMsg = { fg = p.error, bold = true },
    WarningMsg = { fg = p.warn, bold = true },
    OkMsg = { fg = p.ok },
    WildMenu = { link = "PmenuSel" },
    QuickFixLine = { bg = p.raised, bold = true },
    Underlined = { underline = true },

    SpellBad = { undercurl = true, sp = p.error },
    SpellCap = { undercurl = true, sp = p.warn },
    SpellLocal = { undercurl = true, sp = p.info },
    SpellRare = { undercurl = true, sp = p.hint },

    DiffAdd = { bg = p.add },
    DiffChange = { bg = p.change },
    DiffDelete = { fg = p.error, bg = p.delete },
    DiffText = { bg = p.text, bold = true },
    Added = { fg = p.ok },
    Changed = { fg = p.warn },
    Removed = { fg = p.error },

    -- Syntax: neutral first, hue only where it helps scanning
    Comment = { fg = p.muted, italic = true },
    Constant = { fg = p.constant },
    String = { fg = p.string },
    Character = { fg = p.string },
    Number = { fg = p.constant },
    Boolean = { fg = p.constant },
    Float = { fg = p.constant },
    Identifier = { fg = p.fg },
    Function = { fg = p.strong, bold = true },
    Statement = { fg = p.sand },
    Keyword = { fg = p.sand },
    Conditional = { fg = p.sand },
    Repeat = { fg = p.sand },
    Label = { fg = p.sand },
    Exception = { fg = p.sand },
    Operator = { fg = p.muted },
    PreProc = { fg = p.sand },
    Include = { fg = p.sand },
    Define = { fg = p.sand },
    Macro = { fg = p.sand, italic = true },
    Type = { fg = p.type },
    StorageClass = { fg = p.sand },
    Structure = { fg = p.type },
    Typedef = { fg = p.type },
    Special = { fg = p.sand },
    SpecialChar = { fg = p.constant },
    Tag = { fg = p.type },
    Delimiter = { fg = p.edge },
    SpecialComment = { fg = p.muted, italic = true },
    Debug = { fg = p.warn },
    Error = { fg = p.error },
    Todo = { fg = p.signal, bold = true },

    -- Treesitter
    ["@variable"] = { fg = p.fg },
    ["@variable.builtin"] = { fg = p.sand, italic = true },
    ["@variable.parameter"] = { fg = p.fg, italic = true },
    ["@variable.member"] = { fg = p.fg },
    ["@property"] = { fg = p.fg },
    ["@constant"] = { fg = p.constant },
    ["@constant.builtin"] = { fg = p.constant },
    ["@module"] = { fg = p.fg },
    ["@label"] = { fg = p.sand },
    ["@string"] = { link = "String" },
    ["@string.escape"] = { fg = p.constant },
    ["@string.regexp"] = { fg = p.constant },
    ["@string.special.url"] = { fg = p.fg, underline = true },
    ["@character"] = { link = "Character" },
    ["@number"] = { link = "Number" },
    ["@boolean"] = { link = "Boolean" },
    ["@type"] = { link = "Type" },
    ["@type.builtin"] = { fg = p.type, italic = true },
    ["@attribute"] = { fg = p.sand, italic = true },
    ["@function"] = { link = "Function" },
    ["@function.builtin"] = { fg = p.fg },
    ["@function.call"] = { fg = p.fg },
    ["@function.method"] = { link = "Function" },
    ["@function.method.call"] = { fg = p.fg },
    ["@constructor"] = { fg = p.type },
    ["@keyword"] = { link = "Keyword" },
    ["@keyword.return"] = { fg = p.sand, bold = true },
    ["@keyword.import"] = { fg = p.sand },
    ["@operator"] = { link = "Operator" },
    ["@punctuation"] = { fg = p.edge },
    ["@punctuation.bracket"] = { fg = p.edge },
    ["@punctuation.delimiter"] = { fg = p.edge },
    ["@punctuation.special"] = { fg = p.sand },
    ["@comment"] = { link = "Comment" },
    ["@comment.todo"] = { fg = p.signal, bold = true },
    ["@comment.note"] = { fg = p.info, bold = true },
    ["@comment.warning"] = { fg = p.warn, bold = true },
    ["@comment.error"] = { fg = p.error, bold = true },

    -- HTML / JSX: tags carry the structure of frontend code
    ["@tag"] = { fg = p.type },
    ["@tag.builtin"] = { fg = p.type },
    ["@tag.attribute"] = { fg = p.sand, italic = true },
    ["@tag.delimiter"] = { fg = p.edge },

    -- Markup
    ["@markup.heading"] = { fg = p.strong, bold = true },
    ["@markup.heading.1"] = { fg = p.signal, bold = true },
    ["@markup.strong"] = { fg = p.strong, bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.link"] = { fg = p.fg, underline = true },
    ["@markup.link.label"] = { fg = p.fg, underline = true },
    ["@markup.link.url"] = { fg = p.muted, underline = true },
    ["@markup.raw"] = { fg = p.string },
    ["@markup.quote"] = { fg = p.muted, italic = true },
    ["@markup.list"] = { fg = p.sand },
    ["@diff.plus"] = { fg = p.ok },
    ["@diff.minus"] = { fg = p.error },
    ["@diff.delta"] = { fg = p.warn },

    -- LSP
    ["@lsp.type.parameter"] = { link = "@variable.parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.namespace"] = { link = "@module" },
    ["@lsp.type.interface"] = { link = "Type" },
    ["@lsp.mod.deprecated"] = { strikethrough = true },
    LspReferenceText = { bg = p.raised },
    LspReferenceRead = { bg = p.raised },
    LspReferenceWrite = { bg = p.raised, underline = true },
    LspInlayHint = { fg = p.faint, italic = true },
    LspSignatureActiveParameter = { fg = p.strong, bold = true, underline = true },
    LspCodeLens = { fg = p.faint },

    -- Diagnostics: semantic, never Signal
    DiagnosticError = { fg = p.error },
    DiagnosticWarn = { fg = p.warn },
    DiagnosticInfo = { fg = p.info },
    DiagnosticHint = { fg = p.hint },
    DiagnosticOk = { fg = p.ok },
    DiagnosticUnderlineError = { undercurl = true, sp = p.error },
    DiagnosticUnderlineWarn = { undercurl = true, sp = p.warn },
    DiagnosticUnderlineInfo = { underline = true, sp = p.info },
    DiagnosticUnderlineHint = { underline = true, sp = p.hint },
    DiagnosticUnnecessary = { fg = p.faint },
    DiagnosticDeprecated = { strikethrough = true },

    -- Git
    GitSignsAdd = { fg = p.ok },
    GitSignsChange = { fg = p.warn },
    GitSignsDelete = { fg = p.error },

    -- mini.pick / mini.clue
    MiniPickNormal = { link = "NormalFloat" },
    MiniPickBorder = { link = "FloatBorder" },
    MiniPickBorderText = { fg = p.strong, bg = p.surface, bold = true },
    MiniPickPrompt = { fg = p.strong, bg = p.surface, bold = true },
    MiniPickPromptCaret = { fg = p.signal, bg = p.surface },
    MiniPickPromptPrefix = { fg = p.signal, bg = p.surface },
    MiniPickMatchCurrent = { bg = p.raised, bold = true },
    MiniPickMatchMarked = { fg = p.strong, bg = p.visual },
    MiniPickMatchRanges = { fg = p.strong, bold = true, underline = true },
    MiniPickHeader = { fg = p.muted, bold = true },
    MiniClueTitle = { fg = p.strong, bg = p.surface, bold = true },
    MiniClueBorder = { link = "FloatBorder" },
    MiniClueDescGroup = { fg = p.sand, bg = p.surface, bold = true },
    MiniClueDescSingle = { fg = p.fg, bg = p.surface },
    MiniClueNextKey = { fg = p.strong, bg = p.surface, bold = true },
    MiniClueNextKeyWithPostkeys = { fg = p.warn, bg = p.surface, bold = true },
    MiniClueSeparator = { fg = p.faint, bg = p.surface },

    -- oil
    OilDir = { fg = p.fg, bold = true },
    OilFile = { fg = p.fg },
    OilHidden = { fg = p.muted },

    -- render-markdown
    RenderMarkdownH1 = { fg = p.signal, bold = true },
    RenderMarkdownH2 = { fg = p.strong, bold = true },
    RenderMarkdownH3 = { fg = p.strong, bold = true },
    RenderMarkdownH4 = { fg = p.fg, bold = true },
    RenderMarkdownH5 = { fg = p.fg, bold = true },
    RenderMarkdownH6 = { fg = p.muted, bold = true },
    RenderMarkdownH1Bg = { bg = "NONE" },
    RenderMarkdownH2Bg = { bg = "NONE" },
    RenderMarkdownH3Bg = { bg = "NONE" },
    RenderMarkdownH4Bg = { bg = "NONE" },
    RenderMarkdownH5Bg = { bg = "NONE" },
    RenderMarkdownH6Bg = { bg = "NONE" },
    RenderMarkdownCode = { bg = p.surface },
    RenderMarkdownCodeInline = { fg = p.fg, bg = p.surface },
    RenderMarkdownBullet = { fg = p.sand },
    RenderMarkdownDash = { fg = p.separator },
    RenderMarkdownTableHead = { fg = p.edge },
    RenderMarkdownTableRow = { fg = p.separator },

    -- Statusline (lua/config/statusline.lua)
    YevStatusMarker = { fg = p.signal, bg = bg, bold = true },
    YevStatusMode = { fg = p.strong, bg = bg, bold = true },
    YevStatusFile = { fg = p.fg, bg = bg, bold = true },
    YevStatusMuted = { fg = p.muted, bg = bg },
    YevStatusError = { fg = p.error, bg = bg },
    YevStatusWarn = { fg = p.warn, bg = bg },
    YevStatusInfo = { fg = p.info, bg = bg },
    YevStatusHint = { fg = p.hint, bg = bg },
}

for name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, name, spec)
end

for _, kind in ipairs({ "Error", "Warn", "Info", "Hint", "Ok" }) do
    vim.api.nvim_set_hl(0, "DiagnosticVirtualText" .. kind, { link = "Diagnostic" .. kind })
    vim.api.nvim_set_hl(0, "DiagnosticSign" .. kind, { link = "Diagnostic" .. kind })
    vim.api.nvim_set_hl(0, "DiagnosticFloating" .. kind, { link = "Diagnostic" .. kind })
end

-- Terminal palette (lazygit, agents, test runners)
local terminal = {
    p.bg, p.error, p.string, p.warn, p.info, p.sand, p.type, p.fg,
    p.edge, p.error, p.string, p.constant, p.info, p.sand, p.type, p.strong,
}
for index, color in ipairs(terminal) do
    vim.g["terminal_color_" .. (index - 1)] = color
end
