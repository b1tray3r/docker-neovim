-- Treesitter configuration
local M = {}

function M.setup(languages)
  require('nvim-treesitter').setup({
    ensure_installed = languages,
    highlight = { enable = true },
  })
end

return M
