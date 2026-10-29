-- Debugger for C, C++ and Rust through lldb-dap (ships with Xcode / swiftly).
-- Build first (<leader>tb), then F5. The panel opens and closes by itself.

-- Executable to debug: Rust guesses target/debug/<crate>, C guesses the file
-- name without extension (what :Build produces). Both can be edited.
local function program()
    local file = vim.api.nvim_buf_get_name(0)
    local default

    if vim.bo.filetype == "rust" then
        local root = vim.fs.root(file, "Cargo.toml") or vim.uv.cwd()
        default = vim.fs.joinpath(root, "target", "debug", vim.fs.basename(root))
    else
        default = vim.fn.fnamemodify(file, ":r")
    end

    return vim.fn.input("Ejecutable: ", default, "file")
end

local function lldb_dap()
    if vim.fn.executable("lldb-dap") == 1 then
        return "lldb-dap"
    end
    local path = vim.trim(vim.fn.system({ "xcrun", "-f", "lldb-dap" }))
    return vim.v.shell_error == 0 and path or "lldb-dap"
end

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = { "igorlfs/nvim-dap-view" },
        keys = {
            { "<F5>", function() require("dap").continue() end, desc = "Debug: continue" },
            { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
            { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
            { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
            { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: step out" },
            { "<leader>dc", function() require("dap").continue() end, desc = "Start / continue" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
            {
                "<leader>dB",
                function() require("dap").set_breakpoint(vim.fn.input("Condición: ")) end,
                desc = "Conditional breakpoint",
            },
            { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
            { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
            { "<leader>dr", function() require("dap").repl.open() end, desc = "Open REPL" },
            { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
            { "<leader>dv", "<cmd>DapViewToggle<CR>", desc = "Toggle debug panel" },
            { "<leader>dw", "<cmd>DapViewWatch<CR>", desc = "Watch expression", mode = { "n", "x" } },
        },
        config = function()
            local dap = require("dap")

            dap.adapters.lldb = {
                type = "executable",
                command = lldb_dap(),
                name = "lldb",
            }

            local launch = {
                {
                    name = "Launch",
                    type = "lldb",
                    request = "launch",
                    program = program,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = {},
                },
                {
                    name = "Attach to process",
                    type = "lldb",
                    request = "attach",
                    pid = require("dap.utils").pick_process,
                },
            }
            dap.configurations.c = launch
            dap.configurations.cpp = launch
            dap.configurations.rust = launch

            vim.fn.sign_define("DapBreakpoint", { text = "◆", texthl = "DiagnosticError" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "◇", texthl = "DiagnosticWarn" })
            vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "CursorLine" })
        end,
    },

    -- Variables, watches, call stack and breakpoints in one panel
    {
        "igorlfs/nvim-dap-view",
        lazy = true,
        opts = {
            auto_toggle = true,
            winbar = { default_section = "scopes" },
        },
    },
}
