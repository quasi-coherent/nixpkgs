vim.o.cursorline = true
vim.o.showmode = false
vim.g.mapleader = " "

-- More natural pane splitting
vim.o.splitbelow = true
vim.o.splitright = true

-- Some language servers have issues with backup files
vim.o.backup = false
vim.o.writebackup = false

-- Better display for messages
vim.o.cmdheight = 2

-- You will have a bad time with diagnostic messages when it's the default of 4000
vim.o.updatetime = 300

vim.o.shell = 'zsh'

-- nvim-treesitter
require'nvim-treesitter.configs'.setup {
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  }
}

-- vim-ctrlspace
vim.g.CtrlSpaceDefaultMappingKey = "<C-space> "

-- vim-better-whitespace
vim.g.better_whitespace_enabled = 1
vim.g.strip_whitespace_on_save = 1