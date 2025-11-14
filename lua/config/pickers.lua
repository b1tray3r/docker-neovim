-- Picker configuration using mini.pick
local M = {}

function M.setup()
  local pick = require("mini.pick")
  pick.setup()

  -- Custom Git files picker
  local function pick_git_files()
    local command = { 'git', 'ls-files', '--cached', '--others', '--exclude-standard' }
    pick.builtin.cli({ command = command }, { source = { name = 'Git files' } })
  end

  -- Custom live grep picker using ripgrep
  local function pick_grep()
    local command = { 'rg', '--column', '--line-number', '--no-heading', '--color=never', '--smart-case', '' }
    pick.builtin.cli({ command = command }, { source = { name = 'Grep' } })
  end

  -- Setup keymaps
  vim.keymap.set('n', '<leader>f', ":Pick files<CR>", { desc = 'Pick files' })
  vim.keymap.set('n', '<leader>g', pick_git_files, { desc = 'Pick git files' })
  vim.keymap.set('n', '<leader>/', pick_grep, { desc = 'Live grep' })
  vim.keymap.set('n', '<leader>h', ":Pick help<CR>", { desc = 'Pick help' })
end

return M
