-- Treesitter configuration
local M = {}

function M.setup(languages)
  require("nvim-treesitter.configs").setup({
    ensure_installed = languages,
    highlight = { enable = true }
  })

  require('nvim-treesitter.install').update({ with_sync = true })
end

return M
