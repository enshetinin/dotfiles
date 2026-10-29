-- Yev — personal colorscheme, Kanagawa palette (Wave dark / Lotus light).
--
-- Same highlight layout as before (statusline, snacks, blink...), colors from
-- rebelot/kanagawa.nvim. Mirrors ghostty/themes/yev.
--
-- vim.g.yev_transparent = true  -> let the terminal (and its blur) show through
-- vim.o.background = "light"    -> light variant

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.g.colors_name = "yev"

local dark = vim.o.background ~= "light"
local transparent = dark and vim.g.yev_transparent == true

-- stylua: ignore
local p = dark and {
    -- Kanagawa Wave
    bg      = "#1F1F28", -- sumiInk3
    mantle  = "#16161D", -- sumiInk0
    surface = "#1A1A22", -- sumiInk2
    raised  = "#2A2A37", -- sumiInk4
    line    = "#2A2A37",
    visual  = "#2D4F67", -- waveBlue2
    border  = "#54546D", -- sumiInk6
    faint   = "#54546D",
    comment = "#727169", -- fujiGray
    muted   = "#938AA9", -- springViolet1
    fg      = "#DCD7BA", -- fujiWhite
    strong  = "#E9E4C6",

    signal  = "#7E9CD8", -- crystalBlue (main accent)
    orange  = "#FFA066", -- surimiOrange
    yellow  = "#E6C384", -- carpYellow
    green   = "#98BB6C", -- springGreen
    teal    = "#7AA89F", -- waveAqua2
    cyan    = "#7FB4CA", -- springBlue
    blue    = "#7E9CD8", -- crystalBlue
    purple  = "#957FB8", -- oniViolet
    pink    = "#D27E99", -- sakuraPink
    red     = "#E46876", -- waveRed

    violet2 = "#B8B4D0", -- oniViolet2 (parameters)
    punct   = "#9CABCA", -- springViolet2
    sand    = "#C0A36E", -- boatYellow2 (operators)
    peach   = "#FF5D62", -- peachRed
    warn    = "#FF9E3B", -- roninYellow
    error   = "#E82424", -- samuraiRed
    git_add = "#76946A", -- autumnGreen
    git_chg = "#DCA561", -- autumnYellow
    git_del = "#C34043", -- autumnRed
} or {
    -- Kanagawa Lotus
    bg      = "#F2ECBC", -- lotusWhite3
    mantle  = "#E7DBA0", -- lotusWhite4
    surface = "#E5DDB0", -- lotusWhite2
    raised  = "#DCD5AC", -- lotusWhite1
    line    = "#E4D794",
    visual  = "#C9CBD1", -- lotusViolet3
    border  = "#A09CAC", -- lotusViolet1
    faint   = "#A09CAC",
    comment = "#8A8980", -- lotusGray3
    muted   = "#716E61", -- lotusGray2
    fg      = "#545464", -- lotusInk1
    strong  = "#43436C", -- lotusInk2

    signal  = "#4D699B", -- lotusBlue4
    orange  = "#CC6D00", -- lotusOrange
    yellow  = "#77713F", -- lotusYellow
    green   = "#6F894E", -- lotusGreen
    teal    = "#597B75", -- lotusAqua
    cyan    = "#6693BF", -- lotusTeal2
    blue    = "#4D699B", -- lotusBlue4
    purple  = "#624C83", -- lotusViolet4
    pink    = "#B35B79", -- lotusPink
    red     = "#C84053", -- lotusRed

    violet2 = "#5D57A3", -- lotusBlue5
    punct   = "#4E8CA2", -- lotusTeal1
    sand    = "#836F4A", -- lotusYellow2
    peach   = "#D7474B", -- lotusRed2
    warn    = "#E98A00", -- lotusOrange2
    error   = "#E82424", -- lotusRed3
    git_add = "#6E915F", -- lotusGreen2
    git_chg = "#DE9800", -- lotusYellow3
    git_del = "#D7474B", -- lotusRed2
}

-- Mix `color` over `base` (alpha 0..1). Used for tinted backgrounds.
local function blend(color, alpha, base)
    base = base or p.bg
    local function rgb(hex)
        return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
    end
    local r1, g1, b1 = rgb(color)
    local r2, g2, b2 = rgb(base)
    local function mix(a, b)
        return math.floor(a * alpha + b * (1 - alpha) + 0.5)
    end
    return string.format("#%02X%02X%02X", mix(r1, r2), mix(g1, g2), mix(b1, b2))
end

local bg = transparent and "NONE" or p.bg

-- stylua: ignore
local groups = {
    -- Editor ---------------------------------------------------------------
    Normal        = { fg = p.fg, bg = bg },
    NormalNC      = { fg = p.fg, bg = bg },
    NormalFloat   = { fg = p.fg, bg = p.surface },
    FloatBorder   = { fg = p.border, bg = p.surface },
    FloatTitle    = { fg = p.bg, bg = p.signal, bold = true },
    FloatFooter   = { fg = p.muted, bg = p.surface },
    WinSeparator  = { fg = p.raised },
    EndOfBuffer   = { fg = p.bg },
    Cursor        = { fg = p.bg, bg = p.signal },
    lCursor       = { link = "Cursor" },
    TermCursor    = { link = "Cursor" },
    CursorLine    = { bg = p.line },
    CursorColumn  = { bg = p.line },
    ColorColumn   = { bg = p.line },
    CursorLineNr  = { fg = p.warn, bold = true },
    LineNr        = { fg = p.faint },
    LineNrAbove   = { fg = p.faint },
    LineNrBelow   = { fg = p.faint },
    SignColumn    = { bg = "NONE" },
    CursorLineSign = { bg = p.line },
    FoldColumn    = { fg = p.faint },
    Folded        = { fg = p.muted, bg = p.surface, italic = true },
    NonText       = { fg = p.faint },
    Whitespace    = { fg = p.raised },
    SpecialKey    = { fg = p.faint },
    Conceal       = { fg = p.comment },
    Directory     = { fg = p.blue, bold = true },
    Title         = { fg = p.signal, bold = true },
    Visual        = { bg = p.visual },
    VisualNOS     = { bg = p.visual },
    Search        = { fg = p.fg, bg = p.visual },
    IncSearch     = { fg = p.bg, bg = p.warn, bold = true },
    CurSearch     = { link = "IncSearch" },
    Substitute    = { fg = p.bg, bg = p.pink },
    MatchParen    = { fg = p.warn, bold = true },
    QuickFixLine  = { bg = p.raised, bold = true },
    ModeMsg       = { fg = p.muted, bold = true },
    MoreMsg       = { fg = p.green, bold = true },
    Question      = { fg = p.cyan },
    MsgArea       = { fg = p.fg },
    ErrorMsg      = { fg = p.error, bold = true },
    WarningMsg    = { fg = p.warn, bold = true },
    WildMenu      = { fg = p.bg, bg = p.purple },

    StatusLine    = { fg = p.muted, bg = transparent and "NONE" or p.mantle },
    StatusLineNC  = { fg = p.faint, bg = transparent and "NONE" or p.mantle },
    TabLine       = { fg = p.muted, bg = p.mantle },
    TabLineFill   = { bg = transparent and "NONE" or p.mantle },
    TabLineSel    = { fg = p.bg, bg = p.signal, bold = true },
    WinBar        = { fg = p.muted, bg = bg },
    WinBarNC      = { fg = p.faint, bg = bg },

    Pmenu         = { fg = p.fg, bg = p.surface },
    PmenuSel      = { fg = p.strong, bg = p.visual, bold = true },
    PmenuKind     = { fg = p.purple, bg = p.surface },
    PmenuKindSel  = { fg = p.purple, bg = p.visual },
    PmenuExtra    = { fg = p.comment, bg = p.surface },
    PmenuExtraSel = { fg = p.muted, bg = p.visual },
    PmenuMatch    = { fg = p.signal, bg = p.surface, bold = true },
    PmenuMatchSel = { fg = p.signal, bg = p.visual, bold = true },
    PmenuSbar     = { bg = p.surface },
    PmenuThumb    = { bg = p.border },

    SpellBad      = { undercurl = true, sp = p.red },
    SpellCap      = { undercurl = true, sp = p.yellow },
    SpellLocal    = { undercurl = true, sp = p.cyan },
    SpellRare     = { undercurl = true, sp = p.purple },

    DiffAdd       = { bg = blend(p.git_add, 0.25) },
    DiffChange    = { bg = blend(p.blue, 0.15) },
    DiffDelete    = { fg = p.git_del, bg = blend(p.git_del, 0.20) },
    DiffText      = { bg = blend(p.git_chg, 0.30) },
    Added         = { fg = p.git_add },
    Changed       = { fg = p.git_chg },
    Removed       = { fg = p.git_del },

    -- Syntax ---------------------------------------------------------------
    Comment       = { fg = p.comment, italic = true },
    Constant      = { fg = p.orange },
    String        = { fg = p.green },
    Character     = { fg = p.green },
    Number        = { fg = p.pink },
    Boolean       = { fg = p.orange, bold = true },
    Float         = { fg = p.pink },
    Identifier    = { fg = p.fg },
    Function      = { fg = p.blue },
    Statement     = { fg = p.purple, bold = true },
    Conditional   = { fg = p.purple },
    Repeat        = { fg = p.purple },
    Label         = { fg = p.pink },
    Operator      = { fg = p.sand },
    Keyword       = { fg = p.purple, italic = true },
    Exception     = { fg = p.peach },
    PreProc       = { fg = p.red },
    Include       = { fg = p.red },
    Define        = { fg = p.red },
    Macro         = { fg = p.red },
    Type          = { fg = p.teal },
    StorageClass  = { fg = p.purple },
    Structure     = { fg = p.teal },
    Typedef       = { fg = p.teal },
    Special       = { fg = p.cyan },
    SpecialChar   = { fg = p.sand, bold = true },
    Tag           = { fg = p.pink },
    Delimiter     = { fg = p.punct },
    SpecialComment = { fg = p.muted, italic = true },
    Debug         = { fg = p.signal },
    Underlined    = { underline = true },
    Bold          = { bold = true },
    Italic        = { italic = true },
    Error         = { fg = p.error },
    Todo          = { fg = p.bg, bg = p.signal, bold = true },

    -- Treesitter -----------------------------------------------------------
    ["@variable"]                 = { fg = p.fg },
    ["@variable.builtin"]         = { fg = p.red, italic = true },
    ["@variable.parameter"]       = { fg = p.violet2 },
    ["@variable.member"]          = { fg = p.yellow },
    ["@property"]                 = { fg = p.yellow },
    ["@constant"]                 = { fg = p.orange },
    ["@constant.builtin"]         = { fg = p.orange, bold = true },
    ["@constant.macro"]           = { fg = p.red },
    ["@module"]                   = { fg = p.orange },
    ["@label"]                    = { fg = p.pink },
    ["@string"]                   = { link = "String" },
    ["@string.escape"]            = { fg = p.sand, bold = true },
    ["@string.regexp"]            = { fg = p.sand },
    ["@string.special"]           = { fg = p.teal },
    ["@string.special.url"]       = { fg = p.cyan, underline = true },
    ["@character"]                = { link = "Character" },
    ["@number"]                   = { link = "Number" },
    ["@boolean"]                  = { link = "Boolean" },
    ["@type"]                     = { fg = p.teal },
    ["@type.builtin"]             = { fg = p.teal },
    ["@type.definition"]          = { fg = p.teal },
    ["@attribute"]                = { fg = p.orange },
    ["@function"]                 = { fg = p.blue },
    ["@function.builtin"]         = { fg = p.cyan },
    ["@function.call"]            = { fg = p.blue },
    ["@function.macro"]           = { fg = p.red },
    ["@function.method"]          = { fg = p.blue },
    ["@function.method.call"]     = { fg = p.blue },
    ["@constructor"]              = { fg = p.cyan },
    ["@operator"]                 = { fg = p.sand },
    ["@keyword"]                  = { fg = p.purple, italic = true },
    ["@keyword.function"]         = { fg = p.purple },
    ["@keyword.return"]           = { fg = p.peach, italic = true },
    ["@keyword.import"]           = { fg = p.red },
    ["@keyword.operator"]         = { fg = p.sand, bold = true },
    ["@keyword.exception"]        = { fg = p.peach },
    ["@punctuation.delimiter"]    = { fg = p.punct },
    ["@punctuation.bracket"]      = { fg = p.punct },
    ["@punctuation.special"]      = { fg = p.cyan },
    ["@comment"]                  = { link = "Comment" },
    ["@comment.todo"]             = { fg = p.bg, bg = p.signal, bold = true },
    ["@comment.note"]             = { fg = p.bg, bg = p.cyan, bold = true },
    ["@comment.warning"]          = { fg = p.bg, bg = p.yellow, bold = true },
    ["@comment.error"]            = { fg = p.bg, bg = p.red, bold = true },
    ["@tag"]                      = { fg = p.purple },
    ["@tag.builtin"]              = { fg = p.purple },
    ["@tag.attribute"]            = { fg = p.yellow, italic = true },
    ["@tag.delimiter"]            = { fg = p.punct },
    ["@markup.heading"]           = { fg = p.signal, bold = true },
    ["@markup.strong"]            = { fg = p.strong, bold = true },
    ["@markup.italic"]            = { italic = true },
    ["@markup.strikethrough"]     = { strikethrough = true },
    ["@markup.underline"]         = { underline = true },
    ["@markup.quote"]             = { fg = p.muted, italic = true },
    ["@markup.link"]              = { fg = p.cyan },
    ["@markup.link.url"]          = { fg = p.cyan, underline = true },
    ["@markup.link.label"]        = { fg = p.blue },
    ["@markup.raw"]               = { fg = p.teal },
    ["@markup.list"]              = { fg = p.signal },
    ["@markup.list.checked"]      = { fg = p.green },
    ["@markup.list.unchecked"]    = { fg = p.muted },
    ["@diff.plus"]                = { fg = p.git_add },
    ["@diff.minus"]               = { fg = p.git_del },
    ["@diff.delta"]               = { fg = p.git_chg },

    -- LSP semantic tokens
    ["@lsp.type.namespace"]       = { link = "@module" },
    ["@lsp.type.parameter"]       = { link = "@variable.parameter" },
    ["@lsp.type.property"]        = { link = "@property" },
    ["@lsp.type.enumMember"]      = { link = "@constant" },
    ["@lsp.type.interface"]       = { fg = p.teal },
    ["@lsp.type.macro"]           = { link = "@function.macro" },
    ["@lsp.type.lifetime"]        = { fg = p.pink, italic = true },
    ["@lsp.mod.mutable"]          = { underline = true },
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    LspReferenceText              = { bg = p.raised },
    LspReferenceRead              = { bg = p.raised },
    LspReferenceWrite             = { bg = p.raised, underline = true },
    LspInlayHint                  = { fg = p.comment, bg = blend(p.purple, 0.08), italic = true },
    LspSignatureActiveParameter   = { fg = p.signal, bold = true, underline = true },
    LspCodeLens                   = { fg = p.comment, italic = true },

    -- Diagnostics
    DiagnosticError               = { fg = p.error },
    DiagnosticWarn                = { fg = p.warn },
    DiagnosticInfo                = { fg = p.cyan },
    DiagnosticHint                = { fg = p.teal },
    DiagnosticOk                  = { fg = p.green },
    DiagnosticVirtualTextError    = { fg = p.error, bg = blend(p.error, 0.10), italic = true },
    DiagnosticVirtualTextWarn     = { fg = p.warn, bg = blend(p.warn, 0.08), italic = true },
    DiagnosticVirtualTextInfo     = { fg = p.cyan, bg = blend(p.cyan, 0.08), italic = true },
    DiagnosticVirtualTextHint     = { fg = p.teal, bg = blend(p.teal, 0.08), italic = true },
    DiagnosticUnderlineError      = { undercurl = true, sp = p.error },
    DiagnosticUnderlineWarn       = { undercurl = true, sp = p.warn },
    DiagnosticUnderlineInfo       = { undercurl = true, sp = p.cyan },
    DiagnosticUnderlineHint       = { undercurl = true, sp = p.teal },
    DiagnosticUnnecessary         = { fg = p.comment, italic = true },
    DiagnosticDeprecated          = { strikethrough = true },

    -- Git signs ------------------------------------------------------------
    GitSignsAdd                   = { fg = p.git_add },
    GitSignsChange                = { fg = p.git_chg },
    GitSignsDelete                = { fg = p.git_del },
    GitSignsUntracked             = { fg = p.faint },
    GitSignsCurrentLineBlame      = { fg = p.comment, italic = true },

    -- Statusline (lua/config/statusline.lua) -------------------------------
    YevStBar      = { fg = p.muted, bg = transparent and "NONE" or p.mantle },
    YevStPill     = { fg = p.fg, bg = p.raised },
    YevStPillCap  = { fg = p.raised, bg = transparent and "NONE" or p.mantle },
    YevStFile     = { fg = p.strong, bg = p.raised, bold = true },
    YevStDir      = { fg = p.comment, bg = p.raised },
    YevStMuted    = { fg = p.comment, bg = transparent and "NONE" or p.mantle },
    YevStBranch   = { fg = p.purple, bg = transparent and "NONE" or p.mantle, bold = true },
    YevStModified = { fg = p.warn, bg = p.raised, bold = true },
    YevStError    = { fg = p.error, bg = transparent and "NONE" or p.mantle },
    YevStWarn     = { fg = p.warn, bg = transparent and "NONE" or p.mantle },
    YevStInfo     = { fg = p.cyan, bg = transparent and "NONE" or p.mantle },
    YevStHint     = { fg = p.teal, bg = transparent and "NONE" or p.mantle },
    YevStAgent    = { fg = p.orange, bg = transparent and "NONE" or p.mantle, bold = true },
    YevStLsp      = { fg = p.teal, bg = transparent and "NONE" or p.mantle },

    -- Dashboard gradient (snacks) -------------------------------------------
    YevGrad1 = { fg = p.cyan, bold = true },
    YevGrad2 = { fg = p.blue, bold = true },
    YevGrad3 = { fg = p.purple, bold = true },
    YevGrad4 = { fg = p.pink, bold = true },
    YevGrad5 = { fg = p.red, bold = true },
    YevGrad6 = { fg = p.orange, bold = true },

    -- snacks.nvim ----------------------------------------------------------
    SnacksNormal               = { link = "NormalFloat" },
    SnacksDashboardNormal      = { fg = p.fg, bg = bg },
    SnacksDashboardDesc        = { fg = p.fg },
    SnacksDashboardIcon        = { fg = p.purple },
    SnacksDashboardKey         = { fg = p.signal, bold = true },
    SnacksDashboardFooter      = { fg = p.comment, italic = true },
    SnacksDashboardSpecial     = { fg = p.pink },
    SnacksDashboardTitle       = { fg = p.cyan, bold = true },
    SnacksDashboardDir         = { fg = p.comment },
    SnacksDashboardFile        = { fg = p.fg },
    SnacksPickerBorder         = { fg = p.border, bg = p.surface },
    SnacksPickerTitle          = { fg = p.bg, bg = p.signal, bold = true },
    SnacksPickerInputBorder    = { fg = p.purple, bg = p.surface },
    SnacksPickerInputTitle     = { fg = p.bg, bg = p.purple, bold = true },
    SnacksPickerPreviewTitle   = { fg = p.bg, bg = p.cyan, bold = true },
    SnacksPickerListTitle      = { fg = p.bg, bg = p.signal, bold = true },
    SnacksPickerPrompt         = { fg = p.signal, bold = true },
    SnacksPickerMatch          = { fg = p.signal, bold = true },
    SnacksPickerDir            = { fg = p.comment },
    SnacksPickerFile           = { fg = p.fg },
    SnacksPickerListCursorLine = { bg = p.raised },
    SnacksPickerSelected       = { fg = p.pink },
    SnacksPickerTotals         = { fg = p.comment },
    SnacksIndent               = { fg = p.raised },
    SnacksIndentScope          = { fg = p.purple },
    SnacksIndentChunk          = { fg = p.purple },
    SnacksNotifierInfo         = { fg = p.fg, bg = p.surface },
    SnacksNotifierBorderInfo   = { fg = p.cyan, bg = p.surface },
    SnacksNotifierTitleInfo    = { fg = p.cyan, bg = p.surface, bold = true },
    SnacksNotifierIconInfo     = { fg = p.cyan },
    SnacksNotifierBorderWarn   = { fg = p.yellow, bg = p.surface },
    SnacksNotifierTitleWarn    = { fg = p.yellow, bg = p.surface, bold = true },
    SnacksNotifierIconWarn     = { fg = p.yellow },
    SnacksNotifierBorderError  = { fg = p.red, bg = p.surface },
    SnacksNotifierTitleError   = { fg = p.red, bg = p.surface, bold = true },
    SnacksNotifierIconError    = { fg = p.red },
    SnacksInputBorder          = { fg = p.signal, bg = p.surface },
    SnacksInputTitle           = { fg = p.bg, bg = p.signal, bold = true },
    SnacksInputIcon            = { fg = p.signal },
    SnacksWinBar               = { fg = p.fg, bg = p.surface, bold = true },
    SnacksBackdrop             = { bg = p.mantle },

    -- blink.cmp ------------------------------------------------------------
    BlinkCmpMenu               = { fg = p.fg, bg = p.surface },
    BlinkCmpMenuBorder         = { fg = p.border, bg = p.surface },
    BlinkCmpMenuSelection      = { bg = p.visual, bold = true },
    BlinkCmpScrollBarThumb     = { bg = p.border },
    BlinkCmpLabelMatch         = { fg = p.signal, bold = true },
    BlinkCmpLabelDeprecated    = { fg = p.comment, strikethrough = true },
    BlinkCmpLabelDescription   = { fg = p.comment },
    BlinkCmpLabelDetail        = { fg = p.comment },
    BlinkCmpGhostText          = { fg = p.faint, italic = true },
    BlinkCmpDoc                = { fg = p.fg, bg = p.surface },
    BlinkCmpDocBorder          = { fg = p.border, bg = p.surface },
    BlinkCmpDocSeparator       = { fg = p.raised, bg = p.surface },
    BlinkCmpSignatureHelp      = { fg = p.fg, bg = p.surface },
    BlinkCmpSignatureHelpBorder = { fg = p.purple, bg = p.surface },
    BlinkCmpKind               = { fg = p.purple },
    BlinkCmpKindFunction       = { fg = p.blue },
    BlinkCmpKindMethod         = { fg = p.blue },
    BlinkCmpKindConstructor    = { fg = p.cyan },
    BlinkCmpKindVariable       = { fg = p.fg },
    BlinkCmpKindField          = { fg = p.yellow },
    BlinkCmpKindProperty       = { fg = p.yellow },
    BlinkCmpKindClass          = { fg = p.teal },
    BlinkCmpKindInterface      = { fg = p.teal },
    BlinkCmpKindStruct         = { fg = p.teal },
    BlinkCmpKindEnum           = { fg = p.teal },
    BlinkCmpKindEnumMember     = { fg = p.orange },
    BlinkCmpKindConstant       = { fg = p.orange },
    BlinkCmpKindModule         = { fg = p.orange },
    BlinkCmpKindKeyword        = { fg = p.purple },
    BlinkCmpKindSnippet        = { fg = p.green },
    BlinkCmpKindText           = { fg = p.muted },
    BlinkCmpKindFile           = { fg = p.fg },
    BlinkCmpKindFolder         = { fg = p.blue },
    BlinkCmpKindColor          = { fg = p.pink },
    BlinkCmpKindTypeParameter  = { fg = p.violet2 },

    -- noice.nvim -----------------------------------------------------------
    NoiceCmdlinePopup              = { fg = p.fg, bg = p.surface },
    NoiceCmdlinePopupBorder        = { fg = p.signal, bg = p.surface },
    NoiceCmdlinePopupTitle         = { fg = p.bg, bg = p.signal, bold = true },
    NoiceCmdlineIcon               = { fg = p.signal },
    NoiceCmdlinePopupBorderSearch  = { fg = p.yellow, bg = p.surface },
    NoiceCmdlineIconSearch         = { fg = p.yellow },
    NoiceCmdlinePopupBorderLua     = { fg = p.blue, bg = p.surface },
    NoiceCmdlineIconLua            = { fg = p.blue },
    NoiceCmdlinePopupBorderFilter  = { fg = p.teal, bg = p.surface },
    NoiceCmdlineIconFilter         = { fg = p.teal },
    NoicePopupmenu                 = { link = "Pmenu" },
    NoicePopupmenuBorder           = { fg = p.border, bg = p.surface },
    NoicePopupmenuSelected         = { link = "PmenuSel" },
    NoicePopupmenuMatch            = { link = "PmenuMatch" },
    NoiceMini                      = { fg = p.muted, bg = p.surface },

    -- which-key ------------------------------------------------------------
    WhichKey          = { fg = p.signal, bold = true },
    WhichKeyGroup     = { fg = p.purple },
    WhichKeyDesc      = { fg = p.fg },
    WhichKeySeparator = { fg = p.faint },
    WhichKeyNormal    = { bg = p.surface },
    WhichKeyBorder    = { fg = p.border, bg = p.surface },
    WhichKeyTitle     = { fg = p.bg, bg = p.signal, bold = true },
    WhichKeyIcon      = { fg = p.cyan },
    WhichKeyValue     = { fg = p.comment },

    -- mini.icons -----------------------------------------------------------
    MiniIconsAzure  = { fg = p.cyan },
    MiniIconsBlue   = { fg = p.blue },
    MiniIconsCyan   = { fg = p.teal },
    MiniIconsGreen  = { fg = p.green },
    MiniIconsGrey   = { fg = p.muted },
    MiniIconsOrange = { fg = p.orange },
    MiniIconsPurple = { fg = p.purple },
    MiniIconsRed    = { fg = p.red },
    MiniIconsYellow = { fg = p.yellow },

    -- oil / lazy / misc ----------------------------------------------------
    OilDir           = { fg = p.blue, bold = true },
    OilDirIcon       = { fg = p.blue },
    OilLink          = { fg = p.cyan },
    OilCreate        = { fg = p.green, bold = true },
    OilDelete        = { fg = p.red, bold = true },
    OilMove          = { fg = p.yellow, bold = true },
    OilCopy          = { fg = p.teal, bold = true },
    LazyH1           = { fg = p.bg, bg = p.signal, bold = true },
    LazyButton       = { fg = p.fg, bg = p.raised },
    LazyButtonActive = { fg = p.bg, bg = p.purple, bold = true },
    LazySpecial      = { fg = p.pink },
    LazyProgressDone = { fg = p.signal },
    LazyProgressTodo = { fg = p.raised },
    MiniHipatternsTodo  = { fg = p.bg, bg = p.signal, bold = true },
    MiniHipatternsFixme = { fg = p.bg, bg = p.red, bold = true },
    MiniHipatternsHack  = { fg = p.bg, bg = p.yellow, bold = true },
    MiniHipatternsNote  = { fg = p.bg, bg = p.cyan, bold = true },

    -- render-markdown: rainbow headings ------------------------------------
    RenderMarkdownH1   = { fg = p.blue, bold = true },
    RenderMarkdownH2   = { fg = p.purple, bold = true },
    RenderMarkdownH3   = { fg = p.teal, bold = true },
    RenderMarkdownH4   = { fg = p.green, bold = true },
    RenderMarkdownH5   = { fg = p.yellow, bold = true },
    RenderMarkdownH6   = { fg = p.orange, bold = true },
    RenderMarkdownH1Bg = { bg = blend(p.blue, 0.13) },
    RenderMarkdownH2Bg = { bg = blend(p.purple, 0.13) },
    RenderMarkdownH3Bg = { bg = blend(p.teal, 0.11) },
    RenderMarkdownH4Bg = { bg = blend(p.green, 0.11) },
    RenderMarkdownH5Bg = { bg = blend(p.yellow, 0.11) },
    RenderMarkdownH6Bg = { bg = blend(p.orange, 0.11) },
    RenderMarkdownCode       = { bg = p.surface },
    RenderMarkdownCodeInline = { fg = p.teal, bg = p.surface },
    RenderMarkdownBullet     = { fg = p.signal },
    RenderMarkdownTableHead  = { fg = p.purple },
    RenderMarkdownTableRow   = { fg = p.border },
    RenderMarkdownQuote      = { fg = p.purple },
    RenderMarkdownChecked    = { fg = p.green },
    RenderMarkdownUnchecked  = { fg = p.muted },
    RenderMarkdownLink       = { fg = p.cyan },
    RenderMarkdownDash       = { fg = p.border },

    -- nvim-dap
    DapBreakpoint = { fg = p.error },
    DapStopped    = { fg = p.yellow },
}

for name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, name, spec)
end

-- Terminal palette (:terminal, lazygit, Claude). Same as Ghostty.
-- stylua: ignore
local term = dark and {
    "#16161D", "#C34043", "#76946A", "#C0A36E", "#7E9CD8", "#957FB8", "#6A9589", "#C8C093",
    "#727169", "#E82424", "#98BB6C", "#E6C384", "#7FB4CA", "#938AA9", "#7AA89F", "#DCD7BA",
} or {
    "#1F1F28", "#C84053", "#6F894E", "#77713F", "#4D699B", "#B35B79", "#597B75", "#545464",
    "#8A8980", "#D7474B", "#6E915F", "#836F4A", "#6693BF", "#624C83", "#5E857A", "#43436C",
}
for index, color in ipairs(term) do
    vim.g["terminal_color_" .. (index - 1)] = color
end

-- Exposed for the statusline (mode colors) and anyone else who wants it
package.loaded["yev.palette"] = p
