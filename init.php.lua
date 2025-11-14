-- PHP-specific Neovim configuration
vim.g.mapleader = " "
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Load shared configuration modules
require('config.base').setup()
require('config.plugins').setup()
require('config.pickers').setup()
require('config.treesitter').setup({ "php", "dockerfile", "yaml" })

-- Enable LSP servers (intelephense for PHP)
require('config.lsp').setup({ "intelephense", "dockerls", "docker_compose_language_service", "yamlls" })
