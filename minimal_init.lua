
-- ~/.config/nvim/minimal_init.lua

vim.opt.runtimepath:prepend("~/.local/share/nvim/site/pack/packer/start/nvim-cmp")
vim.opt.runtimepath:prepend("~/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp")
vim.opt.runtimepath:prepend("~/.local/share/nvim/site/pack/packer/start/cmp-buffer")
vim.opt.runtimepath:prepend("~/.local/share/nvim/site/pack/packer/start/LuaSnip")
vim.opt.runtimepath:prepend("~/.local/share/nvim/site/pack/packer/start/cmp_luasnip")
vim.opt.runtimepath:prepend("~/.local/share/nvim/site/pack/packer/start/nvim-lspconfig")

-- 基本LSP設定
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.pyright.setup({
  capabilities = capabilities,
})

-- nvim-cmp設定
local cmp = require("cmp")
cmp.setup({
  completion = {
    autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'luasnip' },
  }),
})
