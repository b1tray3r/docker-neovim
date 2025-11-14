-- Go-specific Neovim configuration
vim.g.mapleader = " "
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Load shared configuration modules
require('config.base').setup()
require('config.plugins').setup()
require('config.pickers').setup()
require('config.treesitter').setup({ "go", "dockerfile", "yaml" })

-- Go-specific LSP configuration
local cmp_nvim_lsp = require("cmp_nvim_lsp")

vim.lsp.config.gopls = {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  capabilities = cmp_nvim_lsp.default_capabilities(),
  settings = {
    gopls = {
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
        nilness = true,
        unusedwrite = true,
        useany = true,
      },
      staticcheck = true,
    },
  },
}

-- Enable LSP servers
require('config.lsp').setup({ "gopls", "dockerls", "docker_compose_language_service", "yamlls" })
