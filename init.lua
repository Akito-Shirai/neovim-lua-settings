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
	-- require("path")
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
