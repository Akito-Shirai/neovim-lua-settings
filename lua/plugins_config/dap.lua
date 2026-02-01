-- ~/.config/nvim/lua/plugins_config/dap.lua
local dap = require("dap")
local dapui = require("dapui")

-- Breakpoint記号
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "", numhl = "" })

-- Python用設定
require("plugins_config.dap_python")

-- UIセットアップ
dapui.setup()

-- デバッグ開始/終了に応じてUI自動開閉
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- -- dap.lua
-- local ok_dap, dap = pcall(require, "dap")
-- if not ok_dap then
-- 	vim.notify("Failed to load dap", vim.log.levels.ERROR)
-- 	return
-- end
--
-- local ok_dapui, dapui = pcall(require, "dapui")
-- if not ok_dapui then
-- 	vim.notify("Failed to load dapui", vim.log.levels.ERROR)
-- 	return
-- end
--
-- -- ここで setup は呼ばない（plugins.lua 側で呼ぶ）
-- -- dapui.setup()
--
-- dap.listeners.after.event_initialized["dapui_config"] = function()
-- 	dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
-- 	dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
-- 	dapui.close()
-- end
--
-- vim.keymap.set("n", "<F5>", function()
-- 	dap.continue()
-- end)
-- vim.keymap.set("n", "<F10>", function()
-- 	dap.step_over()
-- end)
-- vim.keymap.set("n", "<F11>", function()
-- 	dap.step_into()
-- end)
-- vim.keymap.set("n", "<F12>", function()
-- 	dap.step_out()
-- end)
-- vim.keymap.set("n", "<Leader>b", function()
-- 	dap.toggle_breakpoint()
-- end)

-- -- dap-ui の設定
-- dapui.setup()
--
-- -- 自動で dap-ui を開閉する設定
-- dap.listeners.after.event_initialized["dapui_config"] = function()
-- 	dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
-- 	dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
-- 	dapui.close()
-- end
--
-- -- keymap
-- vim.keymap.set("n", "<F5>", function()
-- 	require("dap").continue()
-- end)
-- vim.keymap.set("n", "<F10>", function()
-- 	require("dap").step_over()
-- end)
-- vim.keymap.set("n", "<F11>", function()
-- 	require("dap").step_into()
-- end)
-- vim.keymap.set("n", "<F12>", function()
-- 	require("dap").step_out()
-- end)
-- vim.keymap.set("n", "<Leader>b", function()
-- 	require("dap").toggle_breakpoint()
-- end)
