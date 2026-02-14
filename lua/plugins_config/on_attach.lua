local M = {}

M.on_attach = function(client, bufnr)
	local bufmap = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, {
			noremap = true,
			silent = true,
			buffer = bufnr,
			desc = desc,
		})
	end

	---------------------------------------------------------------------------
	-- LSP 基本機能キーマップ（Lspsagaを前提としていない標準API）
	---------------------------------------------------------------------------
	bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
	bufmap("n", "gr", vim.lsp.buf.references, "Find references")
	bufmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
	bufmap("n", "K", vim.lsp.buf.hover, "Hover documentation")
	bufmap("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
	bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
	bufmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

	---------------------------------------------------------------------------
	-- 自動フォーマット（null-ls 用に限定する）
	---------------------------------------------------------------------------
	if client.server_capabilities.documentFormattingProvider then
		local group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
		vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = group,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({
					bufnr = bufnr,
					filter = function(format_client)
						return format_client.name == "null-ls" -- null-ls のみで実行
					end,
				})
			end,
		})
	end
end

return M

-- local augroup_format = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
--
-- local function on_attach(client, bufnr)
--   local keymap = function (mode, lhs, rhs, desc)
--     vim.keymap.set(
--       mode,
--       lhs,
--       rhs,
--       {
--         buffer = bufnr,
--         silent = true,
--         noremap = true,
--         desc = desc
--       }
--     )
--   end
--
--   -- =================================
--   -- 自動フォーマット
--   -- =================================
--   if client.supports_method("textDocument/formatting") then
--     vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       group = augroup_format,
--       buffer = bufnr,
--       callback = function()
--         vim.lsp.buf.format({ bufnr = bufnr })
--       end,
--     })
--   end
--
--   -- =================================
--   -- 標準LSP操作 (保険として設定)
--   -- =================================
--   keymap("n", "gd", vim.lsp.buf.definition, "[LSP] Go to Definition")
--   keymap("n", "gr", vim.lsp.buf.references, "[LSP] References")
--   keymap("n", "gD", vim.lsp.buf.declaration, "[LSP] Go to Declaration")
--   keymap("n", "gi", vim.lsp.buf.implementation, "[LSP] Go to Implementation")
--   keymap("n", "K", vim.lsp.buf.hover, "[LSP] Hover Doc")
--   keymap("n", "<leader>rn", vim.lsp.buf.rename, "[LSP] Rename")
--   keymap("n", "<leader>ca", vim.lsp.buf.code_action, "[LSP] Code Action")
--   keymap("n", "<leader>d", vim.diagnostic.open_float, "[LSP] Line Diagnostics")
--   keymap("n", "[d", vim.diagnostic.goto_prev, "[LSP] Prev Diagnostic")
--   keymap("n", "]d", vim.diagnostic.goto_next, "[LSP] Next Diagnostic")
--
--   -- =================================
--   -- Lspsagaを優先
--   -- =================================
--   local has_saga, _ = pcall(require, "lspsaga")
--   if has_saga then
--     -- 上記マッピングは lspsaga.lua 側で定義してもOK
--     -- ここでは競合を避けて fallback だけ定義
--     -- もしくはここで lspsaga 用マップしてもOK
--   end
-- end
--
-- return on_attach
