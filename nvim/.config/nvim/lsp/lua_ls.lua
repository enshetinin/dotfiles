return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        ".luarc.json",
        ".luarc.jsonc",
        ".git"
    },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT"
            },
            completion = {
                callSnippet = "Replace"
            },
            workspace = {
                checkThirdParty = false,
                -- Knows the `vim` API when editing this config
                library = {
                    vim.env.VIMRUNTIME
                }
            },
            telemetry = {
                enable = false
            }
        }
    }
}
