-- Force terminal detection for snacks.image in WezTerm.
vim.env.SNACKS_WEZTERM = "true"

require("snacks").setup({
  image = {
    enabled = true,
    convert = {
      notify = true,
    },
  },
  notifier = {
    enabled = true,
  },
})
