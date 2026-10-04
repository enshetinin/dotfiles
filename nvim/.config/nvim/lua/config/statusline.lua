-- Quiet, asymmetric statusline: orientation on the left, context on the right.
-- Mode is spelled out (never color only). Signal marks the active line only.

local M = {}

local modes = {
    n = "normal",
    no = "pending",
    v = "visual",
    V = "v-line",
    ["\22"] = "v-block",
    s = "select",
    S = "s-line",
    i = "insert",
    ic = "insert",
    R = "replace",
    c = "command",
    t = "terminal",
    nt = "normal",
}

local function mode()
    local current = vim.api.nvim_get_mode().mode
    return modes[current] or modes[current:sub(1, 1)] or current
end

local function file()
    local name = vim.api.nvim_buf_get_name(0)

    if name == "" then
        return "%#YevStatusMuted#[sin nombre]"
    end

    if vim.bo.buftype == "terminal" then
        return "%#YevStatusFile#" .. vim.fn.fnamemodify(name, ":t")
    end

    local relative = vim.fn.fnamemodify(name, ":~:.")
    local dir = vim.fn.fnamemodify(relative, ":h")
    local tail = vim.fn.fnamemodify(relative, ":t")
    local prefix = dir == "." and "" or dir .. "/"

    return "%#YevStatusMuted#" .. prefix .. "%#YevStatusFile#" .. tail
end

local function flags()
    local result = {}

    if vim.bo.modified then
        table.insert(result, "modificado")
    end

    if vim.bo.readonly or not vim.bo.modifiable then
        table.insert(result, "solo lectura")
    end

    if #result == 0 then
        return ""
    end

    return "%#YevStatusMuted#  " .. table.concat(result, " · ")
end

local function diagnostics()
    local counts = vim.diagnostic.count(0)
    local severity = vim.diagnostic.severity
    local parts = {}

    local items = {
        { severity.ERROR, "E", "YevStatusError" },
        { severity.WARN, "W", "YevStatusWarn" },
        { severity.INFO, "I", "YevStatusInfo" },
        { severity.HINT, "H", "YevStatusHint" },
    }

    for _, item in ipairs(items) do
        local count = counts[item[1]]

        if count and count > 0 then
            table.insert(parts, "%#" .. item[3] .. "#" .. item[2] .. count)
        end
    end

    return table.concat(parts, " ")
end

local function agent()
    -- package.loaded: don't force-load the plugin just to render this
    local claudecode = package.loaded.claudecode

    if claudecode and claudecode.is_claude_connected() then
        return "%#YevStatusMuted#claude"
    end

    return ""
end

local function lsp()
    local names = {}

    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, client.name)
    end

    return "%#YevStatusMuted#" .. table.concat(names, " ")
end

local function join(parts)
    local result = {}

    for _, part in ipairs(parts) do
        if part ~= "" then
            table.insert(result, part)
        end
    end

    return table.concat(result, "%#YevStatusMuted#   ")
end

function M.render()
    local branch = vim.b.gitsigns_head and ("%#YevStatusMuted#" .. vim.b.gitsigns_head) or ""

    local left = "%#YevStatusMarker#▌"
        .. " %#YevStatusMode#"
        .. mode()
        .. "    "
        .. file()
        .. flags()

    local right = join({
        diagnostics(),
        agent(),
        lsp(),
        branch,
        "%#YevStatusMuted#%l:%c  %P",
    })

    return left .. "%=" .. right .. " "
end

vim.o.statusline = "%{%v:lua.require'config.statusline'.render()%}"

vim.api.nvim_create_autocmd({ "DiagnosticChanged", "LspAttach", "LspDetach", "ModeChanged" }, {
    group = vim.api.nvim_create_augroup("yev-statusline", { clear = true }),
    callback = function()
        vim.cmd("redrawstatus")
    end,
})

return M
