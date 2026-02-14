vim.g.python3_host_prog = vim.fn.expand("~/.local/share/nvim/venv/bin/python")
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Compatibility for plugins (e.g. packer.nvim) still calling deprecated helpers.
if type(vim.islist) == "function" then
	vim.tbl_islist = vim.islist
end

-- Neovim 0.12+ deprecation noise from third-party plugins still using
-- `client.supports_method(...)` dot-call style.
do
	local _deprecate = vim.deprecate
	vim.deprecate = function(name, alt, version, plugin, backtrace)
		if type(name) == "string" and name:match("^client%.[%w_]+$") then
			return
		end
		return _deprecate(name, alt, version, plugin, backtrace)
	end
end

do
	local function is_client_method_deprecation(msg)
		return type(msg) == "string" and msg:match("^client%.[%w_]+ is deprecated%.") ~= nil
	end

	local _echo_once = vim._truncated_echo_once
	vim._truncated_echo_once = function(msg, ...)
		if is_client_method_deprecation(msg) then
			return true
		end
		return _echo_once(msg, ...)
	end

	local _notify = vim.notify
	vim.notify = function(msg, level, opts)
		if is_client_method_deprecation(msg) then
			return
		end
		return _notify(msg, level, opts)
	end

	local _notify_once = vim.notify_once
	vim.notify_once = function(msg, level, opts)
		if is_client_method_deprecation(msg) then
			return true
		end
		return _notify_once(msg, level, opts)
	end

	local _nvim_echo = vim.api.nvim_echo
	vim.api.nvim_echo = function(chunks, history, opts)
		if type(chunks) == "table" then
			for _, item in ipairs(chunks) do
				if type(item) == "table" and is_client_method_deprecation(item[1]) then
					return
				end
			end
		end
		return _nvim_echo(chunks, history, opts)
	end
end

do
	local lua_share = vim.fn.expand("~/.luarocks/share/lua/5.1")
	local lua_lib = vim.fn.expand("~/.luarocks/lib/lua/5.1")
	package.path = package.path .. ";" .. lua_share .. "/?.lua;" .. lua_share .. "/?/init.lua"
	package.cpath = package.cpath .. ";" .. lua_lib .. "/?.so"
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
	require("keymaps")
	require("options")
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
