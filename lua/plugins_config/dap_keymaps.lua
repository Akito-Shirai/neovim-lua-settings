-- ~/.config/nvim/lua/plugins_config/keymaps.lua
local dap = require("dap")

vim.keymap.set("n", "<F5>", function()
	dap.continue()
end, { desc = "DAP: Start/Continue" })

vim.keymap.set("n", "<F10>", function()
	dap.step_over()
end, { desc = "DAP: Step Over" })

vim.keymap.set("n", "<F11>", function()
	dap.step_into()
end, { desc = "DAP: Step Into" })

vim.keymap.set("n", "<F12>", function()
	dap.step_out()
end, { desc = "DAP: Step Out" })

vim.keymap.set("n", "<Leader>b", function()
	dap.toggle_breakpoint()
end, { desc = "DAP: Toggle Breakpoint" })

vim.keymap.set("n", "<Leader>B", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP: Conditional Breakpoint" })

-- ~/.config/nvim/lua/plugins_config/keymaps.lua
-- vim.keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>")
-- vim.keymap.set("n", "<F10>", ":lua require'dap'.step_over()<CR>")
-- vim.keymap.set("n", "<F11>", ":lua require'dap'.step_into()<CR>")
-- vim.keymap.set("n", "<F12>", ":lua require'dap'.step_out()<CR>")
-- vim.keymap.set("n", "<Leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
-- vim.keymap.set("n", "<Leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
