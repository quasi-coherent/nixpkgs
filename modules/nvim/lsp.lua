-- Mappings
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Rust
require'lspconfig'.rust_analyzer.setup {
    settings = {
        rust_analyzer = { checkOnSave = { command = "clippy"}}
    }
}

require'rust-tools'.setup({})

-- Go
require'lspconfig'.gopls.setup{}

-- Python
require'lspconfig'.pyright.setup{}

-- Scala
require'lspconfig'.metals.setup{}

-- Terraform
require'lspconfig'.terraformls.setup{}

-- Autopairs
require('nvim-autopairs').setup({})