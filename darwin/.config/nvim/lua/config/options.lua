-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = "\\"
vim.cmd.abbrev("ttoday", [[<C-r>=strftime('%F')<CR>]])
vim.cmd.abbrev("tnow", [[<C-r>=strftime('%X')<CR>]])
vim.cmd.abbrev("ttask", "- [ ]")
vim.cmd.abbrev("twl", [[## Week of <C-r>=strftime('%F')<CR><CR><CR>### Did<CR><CR><CR>### Learned]])

vim.opt.list = true
vim.cmd([[set listchars=tab:→\ ,trail:·,nbsp:·]])
vim.cmd.command([[Preview :!open -a "warp" %<TAB>]])

vim.opt.relativenumber = false
