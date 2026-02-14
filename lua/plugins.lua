if vim.g.vscode then
	return
end

local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- packerのconfigでは文字列を返すと評価
local function conf(name)
	return string.format('require("plugins_config/%s")', name)
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
-- return packer.startup(function(use)
return require("packer").startup(function(use)
	-- プラグイン管理
	use({ "wbthomason/packer.nvim" })

	---------------------------------------------------------------------------------
	-- Common utilities
	---------------------------------------------------------------------------------
	use({ "nvim-lua/plenary.nvim" }) -- Common utilities

	---------------------------------------------------------------------------------
	-- LSP (Language Server Protocol)
	---------------------------------------------------------------------------------
	-- .config/nvim/lua/plugins_config/lsp_config.lua
	-- mason
	use({ "williamboman/mason.nvim" })
	-- lspconfig
	use({
		"neovim/nvim-lspconfig",
		-- requires = {
		-- 	-- mason-lspconfigと合わせて使う場合
		-- 	"williamboman/mason-lspconfig.nvim",
		-- 	-- LSPと連携する補完エンジン
		-- 	"hrsh7th/nvim-cmp",
		-- 	"hrsh7th/cmp-nvim-lsp",
		-- },
		-- config = function()
		-- 	require("plugins_config.lsp_config")
		-- end,
	})
	-- mason-lspconfig
	use({
		"williamboman/mason-lspconfig.nvim",
		after = { "mason.nvim", "nvim-lspconfig" },
		requires = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			-- require("mason-lspconfig").setup()
			require("plugins_config.lsp_config")
		end,
	})
	-- null-ls (フォーマット/リンタ) ※ none-ls は null-ls の後継フォーク
	use({
		"nvimtools/none-ls.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})
	use({
		"glepnir/lspsaga.nvim",
		config = function()
			require("plugins_config.lspsaga")
		end,
	}) -- LSP UI拡張
	-- use({"ibhagwan/fzf-lua"})
	--
	use({
		"jay-babu/mason-nvim-dap.nvim",
		requires = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "python" },
				handlers = {},
			})
		end,
	})

	---------------------------------------------------------------------------------
	-- Completion plugins
	---------------------------------------------------------------------------------
	-- .config/nvim/lua/plugins_config/cmp.lua
	use({
		"nvim-flutter/flutter-tools.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
		},
		config = function()
			require("plugins_config.flutter_tools")
		end,
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lua",
			"saadparwaiz1/cmp_luasnip",
		},
		config = conf("cmp"),
	}) -- メインの補完プラグイン
	use({ "hrsh7th/cmp-buffer" }) -- バッファ内の単語補完
	use({ "hrsh7th/cmp-path" }) -- パス補完
	use({ "hrsh7th/cmp-cmdline" }) -- コマンドラインモード補完
	use({ "hrsh7th/cmp-nvim-lsp" }) -- LSP補完
	use({ "onsails/lspkind-nvim" }) -- 補完アイコン表示
	use({ "hrsh7th/cmp-nvim-lua" }) -- Lua補完
	use({ "saadparwaiz1/cmp_luasnip" }) -- snippet補完

	--  use({ "hrsh7th/nvim-cmp", config = conf("plugins_config/cmp") })  -- メインの補完プラグイン
	--  use({ "hrsh7th/cmp-nvim-lsp", requires = "hrsh7th/nvim-cmp" })    -- LSP補完
	--  use({ "hrsh7th/cmp-buffer", requires = "hrsh7th/nvim-cmp" })      -- バッファ内の単語補完
	--  use({ "hrsh7th/cmp-path", requires = "hrsh7th/nvim-cmp" })        -- パス補完
	--  use({ "hrsh7th/cmp-cmdline", requires = "hrsh7th/nvim-cmp" })     -- コマンドラインモード補完
	-- use({ "hrsh7th/cmp-nvim-lua" })                                   -- Lua補完
	--  use({ "onsails/lspkind-nvim", requires = "hrsh7th/nvim-cmp" })    -- 補完アイコン表示
	-- use({ "saadparwaiz1/cmp_luasnip" }) -- snippet補完

	---------------------------------------------------------------------------------
	-- Debugger
	---------------------------------------------------------------------------------
	use({
		"mfussenegger/nvim-dap",
		config = conf("dap"),
		-- requires = {
		-- 	{
		-- 		"rcarriga/nvim-dap-ui",
		-- 		config = function()
		-- 			require("dapui").setup() -- ← ここで setup だけ呼び出す（dap.lua 側では呼ばない）
		-- 		end,
		-- 	},
		-- },
	})
	use({ "nvim-neotest/nvim-nio" }) -- ← これを追加
	use({
		"rcarriga/nvim-dap-ui",
		requires = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
	})

	use({
		"mfussenegger/nvim-dap-python",
		config = conf("dap_python"),
	})

	---------------------------------------------------------------------------------
	-- Colorschemes
	---------------------------------------------------------------------------------
	-- .config/nvim/lua/colorscheme.lua
	use({ "EdenEast/nightfox.nvim" }) -- Color scheme
	use({ "folke/tokyonight.nvim" })
	use({ "craftzdog/solarized-osaka.nvim" })
	use({ "catppuccin/nvim", as = "catppuccin" })

	---------------------------------------------------------------------------------
	-- Icons
	---------------------------------------------------------------------------------
	use({ "nvim-tree/nvim-web-devicons" })
	-- use({ "kyazdani42/nvim-web-devicons" }) -- File icons

	---------------------------------------------------------------------------------
	-- Statusline / Buffeerline
	---------------------------------------------------------------------------------
	use({
		"nvim-lualine/lualine.nvim", -- Statusline
		requires = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins_config.lualine")
		end,
	})
	use({
		"akinsho/bufferline.nvim",
		tag = "*",
		requires = "nvim-tree/nvim-web-devicons",
	})

	use({
		"mvllow/modes.nvim",
		tag = "v0.2.1",
		config = function()
			require("modes").setup()
		end,
	})

	---------------------------------------------------------------------------------
	-- File explorer
	---------------------------------------------------------------------------------
	use({ "preservim/nerdtree" })

	---------------------------------------------------------------------------------
	-- Comment
	---------------------------------------------------------------------------------
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("plugins_config.comment")
		end,
	})

	---------------------------------------------------------------------------------
	-- Snippet engine
	---------------------------------------------------------------------------------
	use({ "L3MON4D3/LuaSnip" })

	---------------------------------------------------------------------------------
	-- Terminal
	---------------------------------------------------------------------------------
	use({
		"akinsho/toggleterm.nvim",
		config = function()
			require("plugins_config.toggleterm")
		end,
		tag = "*",
	})

	---------------------------------------------------------------------------------
	-- Code runner
	---------------------------------------------------------------------------------
	use({
		"is0n/jaq-nvim",
		config = function()
			require("plugins_config.jaq")
		end,
	})

	---------------------------------------------------------------------------------
	-- Formatter
	---------------------------------------------------------------------------------
	use({ "MunifTanjim/prettier.nvim" })

	---------------------------------------------------------------------------------
	-- Telescope (Finder)
	---------------------------------------------------------------------------------
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})
	use({
		"nvim-telescope/telescope-file-browser.nvim",
		requires = { "nvim-telescope/telescope.nvim" },
	})

	---------------------------------------------------------------------------------
	-- Treesitter
	---------------------------------------------------------------------------------
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	---------------------------------------------------------------------------------
	-- fzf
	---------------------------------------------------------------------------------
	use({ "junegunn/fzf.vim" }) -- 外部ツールの「fzf」バイナリが必要

	---------------------------------------------------------------------------------
	-- Visual
	---------------------------------------------------------------------------------
	use("lukas-reineke/indent-blankline.nvim")

	---------------------------------------------------------------------------------
	-- Autopairs / Autotag
	---------------------------------------------------------------------------------
	use({
		"windwp/nvim-autopairs", -- Autopairs, integrates with both cmp and treesitter
		config = function()
			require("plugins_config.autopairs")
		end,
	})
	use({
		"windwp/nvim-ts-autotag",
		requires = { "nvim-treesitter/nvim-treesitter" },
	})

	---------------------------------------------------------------------------------
	-- Zen mode
	---------------------------------------------------------------------------------
	use({
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup({})
		end,
	})

	---------------------------------------------------------------------------------
	-- GitHub Copilot
	---------------------------------------------------------------------------------
	use({ "github/copilot.vim" })

	---------------------------------------------------------------------------------
	-- Notify
	---------------------------------------------------------------------------------
	-- use({ "rcarriga/nvim-notify" })
	use({ "rcarriga/nvim-notify" })
	use({
		"folke/noice.nvim",
		-- event = "VimEnter",
		config = conf("noice"),
		-- config = string.format('require("plugins_config/%s")', "noice"),
		requires = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	})

	---------------------------------------------------------------------------------
	-- Codex
	---------------------------------------------------------------------------------
	use({
		"pittcat/codex.nvim",
		config = function()
			require("codex").setup({
				terminal = {
					direction = "vertical", -- "horizontal" も可
					position = "right",
					size = 0.40, -- 画面幅の40%
					reuse = true,
					auto_insert = true,
				},
				-- 送信時の挙動はデフォルトでOK。必要なら後で詰める。
			})

			-- 衝突しにくいキー（おすすめ）
			vim.keymap.set("n", "<leader>co", "<cmd>CodexOpen<cr>", { desc = "Codex: open" })
			vim.keymap.set("n", "<leader>ct", "<cmd>CodexToggle<cr>", { desc = "Codex: toggle" })

			-- 選択範囲/参照をCodexへ送る（このプラグインの強み）
			vim.keymap.set("n", "<leader>cp", "<cmd>CodexSendPath<cr>", { desc = "Codex: send file path" })
			vim.keymap.set("v", "<leader>cs", "<cmd>CodexSendSelection<cr>", { desc = "Codex: send selection" })
			vim.keymap.set("v", "<leader>cr", "<cmd>CodexSendReference<cr>", { desc = "Codex: send reference" })
			vim.keymap.set("v", "<leader>cc", "<cmd>CodexSendContent<cr>", { desc = "Codex: send content" })
		end,
	})

	---------------------------------------------------------------------------------
	-- Claude Code IDE Integration
	---------------------------------------------------------------------------------
	use({ "folke/snacks.nvim", config = conf("snacks") })
	use({
		"coder/claudecode.nvim",
		requires = { "folke/snacks.nvim" },
		config = function()
			require("claudecode").setup({
				-- デフォルトで十分動くが、必要に応じてカスタマイズ
				terminal_cmd = "/opt/homebrew/bin/claude",
				terminal = {
					split_side = "right",
					split_width_percentage = 0.40,
				},
			})

			-- キーマップ
			local opts = { noremap = true, silent = true }
			vim.keymap.set(
				"n",
				"<leader>ac",
				"<cmd>ClaudeCode<cr>",
				vim.tbl_extend("force", opts, { desc = "Claude: Toggle" })
			)
			vim.keymap.set(
				"n",
				"<leader>af",
				"<cmd>ClaudeCodeFocus<cr>",
				vim.tbl_extend("force", opts, { desc = "Claude: Focus" })
			)
			vim.keymap.set(
				"n",
				"<leader>ar",
				"<cmd>ClaudeCode --resume<cr>",
				vim.tbl_extend("force", opts, { desc = "Claude: Resume" })
			)
			vim.keymap.set(
				"n",
				"<leader>ab",
				"<cmd>ClaudeCodeAdd %<cr>",
				vim.tbl_extend("force", opts, { desc = "Claude: Add buffer" })
			)
			vim.keymap.set(
				"v",
				"<leader>as",
				"<cmd>ClaudeCodeSend<cr>",
				vim.tbl_extend("force", opts, { desc = "Claude: Send selection" })
			)
			vim.keymap.set(
				"n",
				"<leader>am",
				"<cmd>ClaudeCodeSelectModel<cr>",
				vim.tbl_extend("force", opts, { desc = "Claude: Select model" })
			)
			-- diff操作
			vim.keymap.set(
				"n",
				"<leader>aa",
				"<cmd>ClaudeCodeDiffAccept<cr>",
				vim.tbl_extend("force", opts, { desc = "Claude: Accept diff" })
			)
			vim.keymap.set(
				"n",
				"<leader>ad",
				"<cmd>ClaudeCodeDiffDeny<cr>",
				vim.tbl_extend("force", opts, { desc = "Claude: Deny diff" })
			)
		end,
	})

	---------------------------------------------------------------------------------
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	---------------------------------------------------------------------------------
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
