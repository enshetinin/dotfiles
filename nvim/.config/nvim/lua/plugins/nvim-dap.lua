return {
    "mfussenegger/nvim-dap",
    keys = {
        { "<F5>", function() require("dap").continue() end, desc = "Debug: continue" },
        { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
        { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
        { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
        { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: step out" },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
        { "<leader>dr", function() require("dap").repl.open() end, desc = "Open REPL" },
        { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    },
    config = function()
        vim.fn.sign_define("DapBreakpoint", { text = "◆", texthl = "DiagnosticError" })
        vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "CursorLine" })
    end,
}
