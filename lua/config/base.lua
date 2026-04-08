-- Base configuration shared across all setups
local M = {}

function M.setup()
  -- Leader keys
  vim.g.mapleader = " "
  vim.g.maplocalleader = ' '
  vim.g.have_nerd_font = true

  -- Editor options
  vim.o.breakindent = true
  vim.o.clipboard = 'unnamedplus'
  vim.o.cursorline = true
  vim.o.expandtab = true
  vim.o.hlsearch = true
  vim.o.ignorecase = true
  vim.o.inccommand = 'split'
  vim.o.list = true
  vim.o.mouse = 'a'
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.scrolloff = 10
  vim.o.shiftwidth = 2
  vim.o.showmode = false
  vim.o.signcolumn = 'yes'
  vim.o.smartcase = true
  vim.o.softtabstop = 2
  vim.o.splitbelow = true
  vim.o.swapfile = false
  vim.o.tabstop = 2
  vim.o.termguicolors = true
  vim.o.timeoutlen = 300
  vim.o.undofile = true
  vim.o.updatetime = 250
  vim.o.winborder = "rounded"
  vim.o.wrap = false

  -- General keymaps
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Open [d]iagnostic quickfix list' })
  vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
  vim.keymap.set('n', '<leader>w', ':write<CR>')
  vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
  vim.keymap.set({ 'n', 'v', 'x' }, '<leader>p', '"+d<CR>')

  -- Window navigation
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- Fix Home and End keys in terminal
  vim.keymap.set('', '<Home>', '^', { noremap = true })
  vim.keymap.set('i', '<Home>', '<C-o>^', { noremap = true })
  vim.keymap.set('', '<End>', '$', { noremap = true })
  vim.keymap.set('i', '<End>', '<C-o>$', { noremap = true })
end

return M
