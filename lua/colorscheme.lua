-- colorscheme tokyonight
-- colorscheme solarized-osaka
-- colorscheme nightfox
vim.cmd([[
try
  " colorscheme tokyonight
  " colorscheme nightfox
  colorscheme solarized-osaka
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]])
