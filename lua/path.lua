-- Ensure Homebrew binaries are visible to Neovim (tree-sitter, rg, fd, etc.)
if not string.find(vim.env.PATH, "/opt/homebrew/bin", 1, true) then
	vim.env.PATH = "/opt/homebrew/bin:" .. vim.env.PATH
end

-- mason の bin を PATH に追加
if not string.find(vim.env.PATH, "/Users/akito/.local/share/nvim/mason/bin", 1, true) then
	vim.env.PATH = vim.env.PATH .. ":/Users/akito/.local/share/nvim/mason/bin"
end
