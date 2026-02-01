-- ~/.config/nvim/lua/plugins_config/dap_python.lua
local dap = require("dap")
local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"

-- 動的に pythonPath を取得
local function get_python_path()
	local venv_path = os.getenv("VIRTUAL_ENV")
	if venv_path then
		return venv_path .. "/bin/python"
	end

	-- poetry を使ってる場合
	local handle = io.popen("poetry env info -p 2>/dev/null")
	if handle then
		local result = handle:read("*a")
		handle:close()
		if result and result ~= "" then
			return vim.fn.trim(result) .. "/bin/python"
		end
	end

	-- fallback to system Python
	return "/usr/bin/python3"
end

dap.adapters.python = {
	type = "executable",
	command = mason_path,
	args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		pythonPath = get_python_path,
	},
}

-- local dap_python = require("dap-python")
--
-- -- pythonパスを自動で取得
-- local handle = io.popen("which python")
-- local result = handle:read("*a")
-- handle:close()
-- local system_python = result:gsub("%s+", "")
--
-- local venv_path = os.getenv("VIRTUAL_ENV")
-- local python_path = venv_path and (venv_path .. "/bin/python") or system_python
--
-- -- mason でインストールされた debugpy のパスを設定
-- -- local mason_registry = require("mason-registry")
-- -- local debugpy_path = mason_registry.get_package("debugpy"):get_install_path() .. "/venv/bin/python"
-- -- dap_python.setup(debugpy_path)
--
-- dap_python.setup(python_path)
--
-- -- オプションで test 関連の設定も可能
-- dap_python.test_runner = "pytest"
