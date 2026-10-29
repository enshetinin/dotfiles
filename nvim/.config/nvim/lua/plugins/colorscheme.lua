-- JetBrains look (colors/jetbrains.lua): "Dark" in dark mode, "IntelliJ Light" in light.
-- Mirrors ghostty's jetbrains-dark / jetbrains-light themes.
-- <leader>ub toggles light/dark, <leader>ut toggles transparency.

vim.g.transparent = vim.g.transparent ~= false -- transparent by default, lets ghostty's opacity show
vim.cmd.colorscheme("jetbrains")

return {}
