-- Comment.nvimの設定ファイル
local status, comment = pcall(require, "Comment")

if not status then
	return
end

comment.setup({
	-- Add a space b/w comment and the line
	padding = true,
	-- Whether the cursor should stay at its position
	sticky = true,
	-- Lines to be ignored while (un)comment
	ignore = nil,
	-- LHS of toggle mappings in NORMAL mode
	toggler = {
		-- Line-comment toggle keymap
		line = "gcc",
		-- Block-comment toggle keymap
		block = "gbc",
	},
	-- LHS of operator-pending mappings in NORMAL and VISUAL mode
	opleader = {
		-- Line-comment keymap
		line = "gc",
		-- Block-comment keymap
		block = "gb",
	},
	-- LHS of extra mappings
	extra = {
		-- Add comment on the line above
		above = "gcO",
		-- Add comment on the line below
		below = "gco",
		-- Add comment at the end of line
		eol = "gcA",
	},
	-- Enable keybindings
	-- NOTE: If given `false` then the plugin won't create any mappings
	mappings = {
		-- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
		basic = true,
		-- Extra mapping; `gco`, `gcO`, `gcA`
		extra = true,
	},
	-- Function to call before (un)comment
	pre_hook = nil,
	-- Function to call after (un)comment
	post_hook = nil,
})

-- ✅ Ctrl + k でコメントのトグル
-- ノーマルモード: 現在行を (un)comment
-- vim.keymap.set(
-- 	"n",
-- 	"<C-k>",
-- 	"<Plug>(comment_toggle_linewise_current)",
-- 	{ silent = true, desc = "Toggle comment (line)" }
-- )

-- ビジュアルモード: 選択範囲を (un)comment
-- vim.keymap.set(
-- 	"x",
-- 	"<C-k>",
-- 	"<Plug>(comment_toggle_linewise_visual)",
-- 	{ silent = true, desc = "Toggle comment (visual)" }
-- )

-- カスタムマッピングを設定 -> Ctrl + kでコメント化できない
vim.api.nvim_set_keymap("n", "<C-k>", "gcc", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-k>", "gcc", { noremap = true, silent = true })
