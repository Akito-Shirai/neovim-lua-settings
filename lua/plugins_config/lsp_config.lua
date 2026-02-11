-- 1. 必要モジュールを読み込み
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local nvim_lsp = require("lspconfig")
local ok_null_ls, null_ls = pcall(require, "none-ls")
if not ok_null_ls then
	null_ls = require("null-ls")
end
local on_attach = require("plugins_config.on_attach").on_attach
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 2. mason の初期設定
mason.setup()

-- 3. mason-lspconfig の設定
mason_lspconfig.setup({
	ensure_installed = {
		"pyright",
		"lua_ls",
		"ts_ls",
		"bashls",
		"yamlls",
		"jsonls",
		"sqls",
	},
	automatic_installation = true, -- インストール漏れを自動で補完
	handlers = {
		-- [A] デフォルトハンドラ（共通設定）
		function(server_name)
			nvim_lsp[server_name].setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end,

		-- [B] 個別設定：lua_ls（Lua）
		["lua_ls"] = function()
			nvim_lsp.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" }, -- vim グローバルの警告を消す
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
					},
				},
			})
		end,

		-- [C] 個別設定：tsserver（TypeScript / JavaScript）
		["ts_ls"] = function()
			nvim_lsp.ts_ls.setup({
				-- nvim_lsp.tsserver.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				-- tsserver 固有のオプションがあればここに追加
			})
		end,
	},
})

-- 4. none-ls (フォーマッタ/リンタ) の設定
local sources = {}
local function add_source(source)
	if source then
		table.insert(sources, source)
	end
end

-- Python
add_source(null_ls.builtins.formatting.black.with({
	command = "/Users/akito/.local/share/nvim/mason/bin/black",
	extra_args = { "--fast" },
}))
add_source(null_ls.builtins.formatting.isort)
local flake8 = null_ls.builtins.diagnostics.flake8
if flake8 and vim.fn.executable("flake8") == 1 then
	add_source(flake8)
end

-- Lua
add_source(null_ls.builtins.formatting.stylua)
local luacheck = null_ls.builtins.diagnostics.luacheck
if luacheck and vim.fn.executable("luacheck") == 1 then
	add_source(luacheck.with({
		extra_args = { "--globals", "vim" },
	}))
end

-- Shell
add_source(null_ls.builtins.formatting.shfmt)

-- JavaScript/TypeScript
add_source(null_ls.builtins.formatting.prettier)

-- YAML
add_source(null_ls.builtins.diagnostics.yamllint)

null_ls.setup({
	capabilities = capabilities,
	debug = true,
	on_attach = on_attach,
	diagnostics_format = "[#{m}] #{s} (#{c})",
	sources = sources,
})

-- 5. Neovim の診断表示設定
vim.diagnostic.config({
	virtual_text = { prefix = "⚫︎" },
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		focusable = false,
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})
