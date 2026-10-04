-- Diagnostics: shape + letter, never color alone
local severity = vim.diagnostic.severity

vim.diagnostic.config({
    underline = true,
    severity_sort = true,
    update_in_insert = false,
    signs = {
        text = {
            [severity.ERROR] = "■",
            [severity.WARN] = "▲",
            [severity.INFO] = "●",
            [severity.HINT] = "·",
        },
    },
    virtual_text = {
        spacing = 2,
        source = "if_many",
        prefix = "",
    },
    float = {
        border = "single",
        source = true,
    },
})

-- Configuration for connected LSP servers
local lsp_group = vim.api.nvim_create_augroup("user-lsp", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_group,

    callback = function(event)
        local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

        local function map(keys, action, description, mode)
            vim.keymap.set(mode or "n", keys, action, {
                buffer = event.buf,
                silent = true,
                desc = "LSP: " .. description,
            })
        end

        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("K", vim.lsp.buf.hover, "Show documentation")

        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code actions", { "n", "v" })

        map("<leader>e", function()
            vim.diagnostic.open_float()
        end, "Show diagnostic")

        if client:supports_method("textDocument/inlayHint") then
            map("<leader>ch", function()
                local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
                vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
            end, "Toggle inlay hints")
        end

        -- Native nvim autocomplete
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, event.buf, {
                autotrigger = true,
            })

            map("<C-Space>", vim.lsp.completion.get, "Trigger completion", "i")
        end
    end,
})

-- Base configs come from nvim-lspconfig; files in ./lsp/ extend them.
-- Each server only starts when its binary exists, globally or in the
-- project's node_modules/.bin, so missing tools never raise errors.
local servers = {
    -- frontend
    ts_ls = "typescript-language-server",
    html = "vscode-html-language-server",
    cssls = "vscode-css-language-server",
    jsonls = "vscode-json-language-server",
    eslint = "vscode-eslint-language-server",
    tailwindcss = "tailwindcss-language-server",
    emmet_language_server = "emmet-language-server",
    biome = "biome",
    -- systems
    clangd = "clangd",
    rust_analyzer = vim.fs.joinpath(vim.env.HOME, ".cargo", "bin", "rust-analyzer"),
    lua_ls = "lua-language-server",
}

local function installed(binary, root)
    return vim.fn.executable(binary) == 1
        or (root and vim.fn.executable(vim.fs.joinpath(root, "node_modules", ".bin", binary)) == 1)
end

for name, binary in pairs(servers) do
    local config = vim.lsp.config[name] or {}
    local root_dir = config.root_dir
    local root_markers = config.root_markers or { ".git" }

    vim.lsp.config(name, {
        root_dir = function(buffer, on_dir)
            local function start(root)
                if installed(binary, root) then
                    on_dir(root)
                end
            end

            if type(root_dir) == "function" then
                root_dir(buffer, start)
            else
                start(vim.fs.root(buffer, root_markers))
            end
        end,
    })
end

vim.lsp.enable(vim.tbl_keys(servers))
