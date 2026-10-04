-- Agent-agnostic helpers: work with Claude Code, Codex, opencode or any
-- chat that understands `@path#L10-20` references.

local M = {}

local function relative_path(buffer)
    local name = vim.api.nvim_buf_get_name(buffer or 0)

    if name == "" then
        return nil
    end

    return vim.fn.fnamemodify(name, ":.")
end

local function copy(text)
    vim.fn.setreg("+", text)
    vim.notify("Copiado: " .. text, vim.log.levels.INFO)
end

-- `@src/app.tsx` or `@src/app.tsx#L10-24` when there is a visual selection
function M.copy_reference()
    local path = relative_path()

    if not path then
        vim.notify("El buffer no tiene archivo", vim.log.levels.WARN)
        return
    end

    local mode = vim.fn.mode()

    if mode == "v" or mode == "V" or mode == "\22" then
        local first = vim.fn.line("v")
        local last = vim.fn.line(".")

        if first > last then
            first, last = last, first
        end

        vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)

        local range = first == last and ("#L" .. first) or ("#L" .. first .. "-" .. last)
        copy("@" .. path .. range)
        return
    end

    copy("@" .. path)
end

-- Current line diagnostics as plain text, ready to paste into an agent
function M.copy_diagnostics()
    local path = relative_path() or "[sin nombre]"
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics = vim.diagnostic.get(0, { lnum = line })

    if #diagnostics == 0 then
        diagnostics = vim.diagnostic.get(0)
    end

    if #diagnostics == 0 then
        vim.notify("Sin diagnósticos en este buffer", vim.log.levels.INFO)
        return
    end

    local lines = {}

    for _, diagnostic in ipairs(diagnostics) do
        table.insert(lines, string.format(
            "%s:%d:%d %s [%s] %s",
            path,
            diagnostic.lnum + 1,
            diagnostic.col + 1,
            vim.diagnostic.severity[diagnostic.severity],
            diagnostic.source or "?",
            diagnostic.message
        ))
    end

    vim.fn.setreg("+", table.concat(lines, "\n"))
    vim.notify("Copiados " .. #lines .. " diagnósticos", vim.log.levels.INFO)
end

return M
