
-- autocmds.lua
local mygroup = vim.api.nvim_create_augroup("MyGroup", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

if not vim.g.vscode then
  -- ターミナル版のみ：保存時の末尾空白削除
  autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      local save_cursor = vim.fn.getcurpos()
      vim.cmd([[%s/\s\+$//e]])
      vim.fn.setpos(".", save_cursor)
    end,
  })
end

-- 新規：Pythonファイルの保存前に LSP による自動フォーマットを実行
local lsp_autoformat_group = vim.api.nvim_create_augroup("LspAutoFormatting", { clear = true })
autocmd("BufWritePre", {
  group = lsp_autoformat_group,
  pattern = "*.py",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- 共通：カーソル位置の復元（必要ならどちらでも有効）
autocmd("BufReadPost", {
  group = mygroup,
  pattern = "*",
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})


--
--
--
--
-- -- local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
-- local mygroup = vim.api.nvim_create_augroup("MyGroup",  { clear = true }) -- Create/get autocommand group
-- local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
--
-- -- Remove whitespace on save
-- -- autocmd("BufWritePre", {
-- -- 	pattern = "*",
-- -- 	command = ":%s/\\s\\+$//e",
-- -- })
-- autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function()
--     local save_cursor = vim.fn.getcurpos()
--     vim.cmd([[%s/\s\+$//e]])
--     vim.fn.setpos(".", save_cursor)
--   end,
-- })
--
-- -- Don't auto commenting new lines
-- -- autocmd("BufEnter", {
-- -- 	pattern = "*",
-- -- 	command = "set fo-=c fo-=r fo-=o",
-- -- })
--
-- -- Restore cursor location when file is opened
-- autocmd({ "BufReadPost" }, {
--   group = mygroup,
-- 	pattern = { "*" },
-- 	callback = function()
-- 		vim.api.nvim_exec('silent! normal! g`"zv', false)
-- 	end,
-- })
