-- Claude Code inside nvim: the CLI connects to nvim as its IDE, sees the
-- current selection, and proposes edits as native diffs you accept or deny.
return {
    "coder/claudecode.nvim",
    cmd = {
        "ClaudeCode",
        "ClaudeCodeFocus",
        "ClaudeCodeAdd",
        "ClaudeCodeSend",
        "ClaudeCodeTreeAdd",
        "ClaudeCodeDiffAccept",
        "ClaudeCodeDiffDeny",
        "ClaudeCodeSelectModel",
    },
    keys = {
        { "<leader>ac", "<cmd>ClaudeCode<CR>", desc = "Toggle Claude Code" },
        { "<leader>af", "<cmd>ClaudeCodeFocus<CR>", desc = "Focus Claude Code" },
        { "<leader>ar", "<cmd>ClaudeCode --resume<CR>", desc = "Resume session" },
        { "<leader>aC", "<cmd>ClaudeCode --continue<CR>", desc = "Continue last session" },
        { "<leader>am", "<cmd>ClaudeCodeSelectModel<CR>", desc = "Select model" },
        { "<leader>ab", "<cmd>ClaudeCodeAdd %<CR>", desc = "Add buffer to context" },
        { "<leader>as", "<cmd>ClaudeCodeSend<CR>", mode = "v", desc = "Send selection" },
        { "<leader>as", "<cmd>ClaudeCodeTreeAdd<CR>", ft = { "oil" }, desc = "Add file to context" },
        { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<CR>", desc = "Accept diff" },
        { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<CR>", desc = "Deny diff" },
    },
    opts = {
        terminal = {
            provider = "native",
            split_side = "right",
            split_width_percentage = 0.38,
        },
        diff_opts = {
            layout = "vertical",
            open_in_new_tab = false,
            keep_terminal_focus = false,
        },
    },
}
