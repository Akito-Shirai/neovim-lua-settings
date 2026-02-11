-- provider settings
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = vim.fn.stdpath("config") .. "/.venv/bin/python"

-- LuaRocks (LuaJIT 5.1) paths for LuaSnip jsregexp
do
	local home = vim.env.HOME
	local luarocks_share = home .. "/.luarocks/share/lua/5.1/?.lua"
	local luarocks_share_init = home .. "/.luarocks/share/lua/5.1/?/init.lua"
	local luarocks_lib = home .. "/.luarocks/lib/lua/5.1/?.so"
	if not package.path:find(luarocks_share, 1, true) then
		package.path = package.path .. ";" .. luarocks_share .. ";" .. luarocks_share_init
	end
	if not package.cpath:find(luarocks_lib, 1, true) then
		package.cpath = package.cpath .. ";" .. luarocks_lib
	end
end

if vim.g.vscode then
	-- vscode 用の最小限の設定
	require("options")
	require("autocmds")
	-- 必要に応じて、vscode でも使いたい最低限のキーマッピングのみ追加
	vim.keymap.set("i", "jj", "<ESC>", { noremap = true, silent = true })
	-- クリップボード連携（vscode 側で動作する場合も合わせる）
	vim.opt.clipboard = "unnamedplus"
else
	-- ターミナル（通常）版の設定
	require("path")
	require("keymaps")
	require("options")
	require("base")
	require("autocmds")
	require("colorscheme")
	require("plugins")
end

-- require("options")
-- require("base")
-- require("autocmds")
-- require("keymaps")
-- require("colorscheme")
-- require("plugins")
