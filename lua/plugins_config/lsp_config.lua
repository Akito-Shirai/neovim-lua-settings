-- 1. mason を先にセットアップ（mason-lspconfig より前に必要）
require("mason").setup()

-- 2. 必要モジュールを読み込み
local mason_lspconfig = require("mason-lspconfig")
local nvim_lsp = require("lspconfig")
local null_ls = require("null-ls")
local on_attach = require("plugins_config.on_attach").on_attach
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function get_lsp_server(names)
	for _, name in ipairs(names) do
		local ok = pcall(require, "lspconfig.server_configurations." .. name)
		if ok then
			return name
		end
	end
	return nil
end

local ts_server = get_lsp_server({ "ts_ls", "tsserver" })
local ts_lsp = ts_server and rawget(nvim_lsp, ts_server) or nil
local yamlls_lsp = rawget(nvim_lsp, "yamlls")

-- Normalize filetypes to avoid unknown filetype warnings in checkhealth.
if ts_lsp and ts_lsp.document_config and ts_lsp.document_config.default_config then
	ts_lsp.document_config.default_config.filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	}
end
if yamlls_lsp and yamlls_lsp.document_config and yamlls_lsp.document_config.default_config then
	yamlls_lsp.document_config.default_config.filetypes = { "yaml" }
end
do
	local ok_ts, ts_cfg
	if ts_server then
		ok_ts, ts_cfg = pcall(require, "lspconfig.server_configurations." .. ts_server)
	else
		ok_ts = false
	end
	if ok_ts and ts_cfg and ts_cfg.default_config then
		ts_cfg.default_config.filetypes = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		}
	end
	local ok_yaml, yaml_cfg = pcall(require, "lspconfig.server_configurations.yamlls")
	if ok_yaml and yaml_cfg and yaml_cfg.default_config then
		yaml_cfg.default_config.filetypes = { "yaml" }
	end
end

-- 2. mason-lspconfig の設定
local ensure_installed = {
	"pyright",
	"lua_ls",
	"bashls",
	"yamlls",
	"jsonls",
	"sqls",
}
if ts_server then
	table.insert(ensure_installed, ts_server)
end

local handlers = {
	-- [A] デフォルトハンドラ（共通設定）
	function(server_name)
		local server = rawget(nvim_lsp, server_name)
		if not server then
			return
		end
		server.setup({
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

	["yamlls"] = function()
		local server = rawget(nvim_lsp, "yamlls")
		if not server then
			return
		end
		server.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "yaml" },
		})
	end,
}

if ts_server then
	handlers[ts_server] = function()
		local server = rawget(nvim_lsp, ts_server)
		if not server then
			return
		end
		server.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
			-- tsserver 固有のオプションがあればここに追加
		})
	end
end

mason_lspconfig.setup({
	ensure_installed = ensure_installed,
	automatic_installation = true, -- インストール漏れを自動で補完
	handlers = handlers,
})

-- 4. null-ls (フォーマッタ/リンタ) の設定
null_ls.setup({
	capabilities = capabilities,
	debug = false,
	on_attach = on_attach,
	diagnostics_format = "[#{m}] #{s} (#{c})",
	sources = {
		-- Python
		null_ls.builtins.formatting.black.with({
			command = "/Users/akito/.local/share/nvim/mason/bin/black",
			extra_args = { "--fast" },
		}),
		null_ls.builtins.formatting.isort,
		-- flake8/luacheck は none-ls.nvim から削除済み（pyright, lua_ls が代替）
		-- 復活させるには none-ls-extras.nvim を導入すること

		-- Lua
		null_ls.builtins.formatting.stylua,

		-- Shell
		null_ls.builtins.formatting.shfmt,

		-- JavaScript/TypeScript
		null_ls.builtins.formatting.prettier,

		-- YAML
		null_ls.builtins.diagnostics.yamllint,
	},
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
