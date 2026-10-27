-- Pill statusline. Left: mode, file, git. Right: diagnostics, agent, LSP, position.
-- The mode pill changes color; the mode is also spelled out (never color only).

local M = {}

local L, R = "\u{e0b6}", "\u{e0b4}" -- rounded pill caps

local modes = {
    n = { "NORMAL", "signal" },
    no = { "PENDING", "signal" },
    v = { "VISUAL", "purple" },
    V = { "V-LINE", "purple" },
    ["\22"] = { "V-BLOCK", "purple" },
    s = { "SELECT", "purple" },
    S = { "S-LINE", "purple" },
    i = { "INSERT", "green" },
    ic = { "INSERT", "green" },
    R = { "REPLACE", "red" },
    c = { "COMMAND", "yellow" },
    t = { "TERMINAL", "cyan" },
    nt = { "NORMAL", "signal" },
}

local function palette()
    return package.loaded["yev.palette"] or {}
end

-- Mode highlights are recreated on every ColorScheme
local function define_mode_groups()
    local p = palette()
    local bar = vim.g.yev_transparent and vim.o.background == "dark" and "NONE" or p.mantle
    for _, color in ipairs({ "signal", "purple", "green", "red", "yellow", "cyan" }) do
        local name = color:gsub("^%l", string.upper)
        vim.api.nvim_set_hl(0, "YevStMode" .. name, { fg = p.bg, bg = p[color], bold = true })
        vim.api.nvim_set_hl(0, "YevStModeCap" .. name, { fg = p[color], bg = bar })
    end
end

local function hl(group, text)
    return "%#" .. group .. "#" .. text
end

local function mode()
    local current = vim.api.nvim_get_mode().mode
    local item = modes[current] or modes[current:sub(1, 1)] or { current:upper(), "signal" }
    local name = item[2]:gsub("^%l", string.upper)
    return hl("YevStModeCap" .. name, L)
        .. hl("YevStMode" .. name, " " .. item[1] .. " ")
        .. hl("YevStModeCap" .. name, R)
end

local function file()
    local name = vim.api.nvim_buf_get_name(0)
    local tail, dir

    if name == "" then
        tail, dir = "[sin nombre]", ""
    elseif vim.bo.buftype == "terminal" then
        tail, dir = vim.fn.fnamemodify(name, ":t"), ""
    else
        local relative = vim.fn.fnamemodify(name, ":~:.")
        tail = vim.fn.fnamemodify(relative, ":t")
        local parent = vim.fn.fnamemodify(relative, ":h")
        dir = parent == "." and "" or parent .. "/"
    end

    local icon, icon_hl = "\u{f15b}", "YevStPill"
    local ok, icons = pcall(require, "mini.icons")
    if ok and name ~= "" then
        icon, icon_hl = icons.get("file", tail)
        -- Icon on the pill background, with its own color
        local fg = vim.api.nvim_get_hl(0, { name = icon_hl, link = false }).fg
        vim.api.nvim_set_hl(0, "YevStIcon_" .. icon_hl, { fg = fg, bg = palette().raised })
        icon_hl = "YevStIcon_" .. icon_hl
    end

    local flags = ""
    if vim.bo.modified then
        flags = hl("YevStModified", " ●")
    elseif vim.bo.readonly or not vim.bo.modifiable then
        flags = hl("YevStDir", " \u{f023}")
    end

    return hl("YevStPillCap", L)
        .. hl(icon_hl, icon .. " ")
        .. hl("YevStDir", dir)
        .. hl("YevStFile", tail)
        .. flags
        .. hl("YevStPillCap", R)
end

local function branch()
    local head = vim.b.gitsigns_head
    if not head or head == "" then
        return ""
    end

    local status = vim.b.gitsigns_status_dict or {}
    local parts = { hl("YevStBranch", "\u{e0a0} " .. head) }
    if (status.added or 0) > 0 then
        table.insert(parts, hl("GitSignsAdd", "+" .. status.added))
    end
    if (status.changed or 0) > 0 then
        table.insert(parts, hl("GitSignsChange", "~" .. status.changed))
    end
    if (status.removed or 0) > 0 then
        table.insert(parts, hl("GitSignsDelete", "-" .. status.removed))
    end
    return table.concat(parts, " ")
end

local function diagnostics()
    local counts = vim.diagnostic.count(0)
    local severity = vim.diagnostic.severity
    local parts = {}
    local items = {
        { severity.ERROR, "\u{f057} ", "YevStError" },
        { severity.WARN, "\u{f071} ", "YevStWarn" },
        { severity.INFO, "\u{f05a} ", "YevStInfo" },
        { severity.HINT, "󰌵 ", "YevStHint" },
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
        return hl("YevStAgent", "󰚩 claude")
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
    return hl("YevStLsp", "\u{f085} " .. table.concat(names, " "))
end

local function position()
    local current = vim.api.nvim_get_mode().mode
    local item = modes[current] or modes[current:sub(1, 1)] or { "", "signal" }
    local name = item[2]:gsub("^%l", string.upper)
    return hl("YevStPillCap", L)
        .. hl("YevStPill", " %l:%c ")
        .. hl("YevStModeCap" .. name, L)
        .. hl("YevStMode" .. name, " %P ")
        .. hl("YevStModeCap" .. name, R)
end

local function join(parts, separator)
    local result = {}
    for _, part in ipairs(parts) do
        if part ~= "" then
            table.insert(result, part)
        end
    end
    return table.concat(result, separator)
end

function M.render()
    local left = join({ mode(), file(), branch() }, hl("YevStBar", "  "))
    local right = join({ diagnostics(), agent(), lsp(), position() }, hl("YevStMuted", "  "))
    return hl("YevStBar", " ") .. left .. hl("YevStBar", "%=") .. right .. hl("YevStBar", " ")
end

define_mode_groups()
vim.o.statusline = "%{%v:lua.require'config.statusline'.render()%}"

local group = vim.api.nvim_create_augroup("yev-statusline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = define_mode_groups })
vim.api.nvim_create_autocmd({ "DiagnosticChanged", "LspAttach", "LspDetach", "ModeChanged" }, {
    group = group,
    callback = function()
        vim.cmd("redrawstatus")
    end,
})

return M
