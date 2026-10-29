-- Flat statusline in the style of the JetBrains status bar.
-- Colors (St* groups) come from colors/jetbrains.lua.
-- Left: mode, path › breadcrumbs, git. Right: diagnostics, agent, LSP, line:col, LF, UTF-8, indent.
-- The mode is spelled out and colored (never color only), always the same width.

local M = {}

local modes = {
    n = { "NORMAL", "normal" },
    no = { "PENDING", "normal" },
    v = { "VISUAL", "visual" },
    V = { "V-LINE", "visual" },
    ["\22"] = { "V-BLOCK", "visual" },
    s = { "SELECT", "visual" },
    S = { "S-LINE", "visual" },
    i = { "INSERT", "insert" },
    ic = { "INSERT", "insert" },
    R = { "REPLACE", "replace" },
    c = { "COMMAND", "command" },
    t = { "TERMINAL", "terminal" },
    nt = { "NORMAL", "normal" },
}

local function current_mode()
    local current = vim.api.nvim_get_mode().mode
    return modes[current] or modes[current:sub(1, 1)] or { current:upper(), "normal" }
end

local function hl(group, text)
    return "%#" .. group .. "#" .. text
end

-- Fixed width so the rest of the bar doesn't shift when the mode changes
local MODE_WIDTH = 10

local function mode()
    local item = current_mode()
    local label = item[1]
    local left = math.floor((MODE_WIDTH - #label) / 2)
    local right = math.max(MODE_WIDTH - #label - left, 0)
    return hl("StMode_" .. item[2], string.rep(" ", left) .. label .. string.rep(" ", right))
end

-- Non-file buffers get a plain label instead of a path and file details
local special = {
    snacks_dashboard = "Inicio",
    snacks_picker_input = "Buscar",
    snacks_picker_list = "Buscar",
    snacks_picker_preview = "Buscar",
    snacks_layout_box = "Buscar",
    lazy = "Lazy",
    mason = "Mason",
    checkhealth = "Checkhealth",
    qf = "Quickfix",
    help = "Ayuda",
    oil = "Oil",
    gitcommit = "Commit",
    ["dap-repl"] = "Debug",
}

local function special_label()
    local label = special[vim.bo.filetype]
    if label then
        return label
    end
    if vim.bo.buftype == "terminal" then
        return "Terminal"
    end
    if vim.bo.buftype ~= "" and vim.bo.buftype ~= "acwrite" then
        return vim.bo.filetype ~= "" and vim.bo.filetype or vim.bo.buftype
    end
end

-- Keep the last few folders, like the IDE breadcrumbs when space is short
local MAX_DIRS = 3

local function breadcrumbs(parent)
    if parent == "." or parent == "" then
        return ""
    end
    local parts = vim.split(parent, "/", { plain = true })
    if #parts > MAX_DIRS then
        parts = vim.list_slice(parts, #parts - MAX_DIRS + 1)
        table.insert(parts, 1, "…")
    end
    return table.concat(parts, " › ") .. " › "
end

-- Statusline text must not contain a bare % (file names can)
local function escape(text)
    return (text:gsub("%%", "%%%%"))
end

local function file(show_dirs)
    local name = vim.api.nvim_buf_get_name(0)
    local tail, dir

    if name == "" then
        tail, dir = "[sin nombre]", ""
    else
        local relative = vim.fn.fnamemodify(name, ":~:.")
        tail = vim.fn.fnamemodify(relative, ":t")
        -- Breadcrumbs like the IDE navigation bar: … › lua › config ›
        dir = show_dirs and breadcrumbs(vim.fn.fnamemodify(relative, ":h")) or ""
    end

    local icon, icon_hl = "\u{f15b}", "StFile"
    local ok, icons = pcall(require, "mini.icons")
    if ok and name ~= "" then
        local group
        icon, group = icons.get("file", tail)
        -- Icon color on the statusline background
        local fg = vim.api.nvim_get_hl(0, { name = group, link = false }).fg
        icon_hl = "StIcon_" .. group
        vim.api.nvim_set_hl(0, icon_hl, { fg = fg, bg = vim.api.nvim_get_hl(0, { name = "StBar" }).bg })
    end

    local flags = ""
    if vim.bo.modified then
        flags = hl("StModified", " ●")
    elseif vim.bo.readonly or not vim.bo.modifiable then
        flags = hl("StDir", " \u{f023}")
    end

    return hl(icon_hl, icon .. " ") .. hl("StDir", escape(dir)) .. hl("StFile", escape(tail)) .. flags
end

local function branch(show_counts)
    local head = vim.b.gitsigns_head
    if not head or head == "" then
        return ""
    end

    local status = vim.b.gitsigns_status_dict or {}
    local parts = { hl("StBranch", "\u{e725} " .. escape(head)) }
    if not show_counts then
        return parts[1]
    end
    if (status.added or 0) > 0 then
        table.insert(parts, hl("StAdd", "+" .. status.added))
    end
    if (status.changed or 0) > 0 then
        table.insert(parts, hl("StChange", "~" .. status.changed))
    end
    if (status.removed or 0) > 0 then
        table.insert(parts, hl("StDelete", "-" .. status.removed))
    end
    return table.concat(parts, " ")
end

local function diagnostics()
    local counts = vim.diagnostic.count(0)
    local severity = vim.diagnostic.severity
    local parts = {}
    local items = {
        { severity.ERROR, "\u{f057} ", "StError" },
        { severity.WARN, "\u{f071} ", "StWarn" },
        { severity.INFO, "\u{f05a} ", "StInfo" },
        { severity.HINT, "󰌵 ", "StHint" },
    }

    for _, item in ipairs(items) do
        local count = counts[item[1]]
        if count and count > 0 then
            table.insert(parts, hl(item[3], item[2] .. count))
        end
    end

    return table.concat(parts, " ")
end

local function agent()
    -- package.loaded: don't force-load the plugin just to render this
    local claudecode = package.loaded.claudecode
    if claudecode and claudecode.is_claude_connected() then
        return hl("StAgent", "󰚩 claude")
    end
    return ""
end

local function lsp()
    local names = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, client.name)
    end
    if #names == 0 then
        return ""
    end
    return hl("StLsp", table.concat(names, " "))
end

local function position(full)
    local indent = vim.bo.expandtab and (vim.bo.shiftwidth > 0 and vim.bo.shiftwidth or vim.bo.tabstop) .. " spaces"
        or "Tab"
    local format = ({ unix = "LF", dos = "CRLF", mac = "CR" })[vim.bo.fileformat] or vim.bo.fileformat
    local encoding = (vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding):upper()
    if not full then
        return hl("StPos", "%l:%c")
    end
    return hl("StPos", "%l:%c") .. hl("StSep", "   ") .. hl("StLsp", format .. "   " .. encoding .. "   " .. indent)
end

local function join(parts)
    local result = {}
    for _, part in ipairs(parts) do
        if part ~= "" then
            table.insert(result, part)
        end
    end
    return table.concat(result, hl("StSep", "   "))
end

-- Visible width of a statusline string (highlights and items resolved)
local function width(text)
    text = text:gsub("%%#[^#]-#", ""):gsub("%%[<=]", "")
    text = text:gsub("%%l", tostring(vim.fn.line("."))):gsub("%%c", tostring(vim.fn.col(".")))
    return vim.fn.strdisplaywidth((text:gsub("%%%%", "%%")))
end

-- When space runs out, drop the least useful pieces first (like the IDE does)
local levels = {
    { dirs = true, counts = true, lsp = true, details = true, branch = true },
    { dirs = true, counts = true, lsp = true, details = false, branch = true },
    { dirs = true, counts = true, lsp = false, details = false, branch = true },
    { dirs = true, counts = false, lsp = false, details = false, branch = true },
    { dirs = false, counts = false, lsp = false, details = false, branch = true },
    { dirs = false, counts = false, lsp = false, details = false, branch = false },
}

local function build(show)
    local left = join({ mode(), file(show.dirs), show.branch and branch(show.counts) or "" })
    local right = join({ diagnostics(), agent(), show.lsp and lsp() or "", position(show.details) })
    -- %< : last resort, cut the path (never the mode)
    left = left:gsub(vim.pesc(hl("StSep", "   ")), "%0%%<", 1)
    return left .. hl("StBar", "%=") .. hl("StSep", "   ") .. right .. hl("StBar", "  ")
end

function M.render()
    local label = special_label()
    if label then
        return join({ mode(), hl("StFile", escape(label)) }) .. hl("StBar", "%=") .. agent() .. hl("StBar", "  ")
    end

    local columns = vim.o.laststatus == 3 and vim.o.columns or vim.api.nvim_win_get_width(0)
    local line
    for _, show in ipairs(levels) do
        line = build(show)
        if width(line) <= columns then
            break
        end
    end
    return line
end

vim.o.statusline = "%{%v:lua.require'config.statusline'.render()%}"

local group = vim.api.nvim_create_augroup("yev-statusline", { clear = true })
vim.api.nvim_create_autocmd({ "DiagnosticChanged", "LspAttach", "LspDetach", "ModeChanged" }, {
    group = group,
    callback = function()
        vim.cmd("redrawstatus")
    end,
})

return M
