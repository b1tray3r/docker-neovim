-- Plugin configuration shared across all setups
local M = {}

function M.setup()
  -- Add plugins
  vim.pack.add({
    { src = "https://github.com/folke/tokyonight.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/ggandor/leap.nvim" },
  })

  -- Setup completion
  local cmp = require("cmp")
  cmp.setup({
    sources = {
      { name = 'nvim_lsp' },
    },
    mapping = cmp.mapping.preset.insert({
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
  })
  vim.cmd("set completeopt=menu,menuone,noselect")

  -- Setup Oil file manager
  require("oil").setup()
  vim.keymap.set('n', '<leader>e', ":Oil<CR>", { desc = 'Open Oil file manager' })

  -- Setup Leap motions
  local leap = require('leap')
  leap.add_default_mappings()

  -- Setup colorscheme
  require("tokyonight").setup({
    style = 'night',
    transparent = true,
  })
  vim.cmd("colorscheme tokyonight")
  vim.cmd(":hi statusline guibg=NONE")
end

return M
