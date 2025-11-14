# Neovim Configuration Structure

This Neovim configuration has been refactored to use a modular structure that eliminates redundancy across different language-specific setups (base, Go, PHP).

## Directory Structure

```
nvim/
├── init.lua           # Base configuration
├── init.go.lua        # Go-specific configuration
├── init.php.lua       # PHP-specific configuration
└── lua/
    └── config/
        ├── base.lua       # Shared editor settings and keymaps
        ├── plugins.lua    # Plugin setup and configuration
        ├── pickers.lua    # File and grep pickers (mini.pick)
        ├── lsp.lua        # LSP configuration and handlers
        └── treesitter.lua # Treesitter configuration
```

## Shared Modules

### `lua/config/base.lua`
Contains all common editor settings and keymaps:
- Editor options (line numbers, scrolling, indentation, etc.)
- General keymaps (save, copy, paste, etc.)
- Window navigation keymaps (`<C-h/j/k/l>`)

### `lua/config/plugins.lua`
Sets up all plugins used across configurations:
- `tokyonight.nvim` - Colorscheme
- `oil.nvim` - File manager
- `mini.pick` - Fuzzy finder
- `nvim-treesitter` - Syntax highlighting
- `nvim-lspconfig` - LSP integration
- `nvim-cmp` + `cmp-nvim-lsp` - Autocompletion
- `leap.nvim` - Motion plugin

### `lua/config/pickers.lua`
Configures fuzzy finding and search functionality:
- **`<leader>f`** - Pick all files
- **`<leader>g`** - Pick Git files (`git ls-files`)
- **`<leader>/`** - Live grep using ripgrep
- **`<leader>h`** - Pick help topics

### `lua/config/lsp.lua`
Shared LSP configuration:
- LSP attach autocmd with keymaps:
  - `gd` - Go to definition
  - `gr` - Go to references
  - `<leader>F` - Format buffer
- Auto-format and organize imports on save
- Hover handler with rounded borders

### `lua/config/treesitter.lua`
Treesitter setup with language-specific parser installation.

## Language-Specific Configurations

### Base (`init.lua`)
Minimal setup with Docker and YAML support:
- LSP: `dockerls`, `docker_compose_language_service`, `yamlls`
- Treesitter: `dockerfile`, `yaml`

### Go (`init.go.lua`)
Go development setup:
- Custom `gopls` configuration with advanced settings
- LSP: `gopls`, `dockerls`, `docker_compose_language_service`, `yamlls`
- Treesitter: `go`, `dockerfile`, `yaml`

### PHP (`init.php.lua`)
PHP development setup:
- LSP: `intelephense`, `dockerls`, `docker_compose_language_service`, `yamlls`
- Treesitter: `php`, `dockerfile`, `yaml`

## Key Bindings

### General
- `<leader>w` - Write (save) file
- `<leader>d` - Open diagnostic quickfix list
- `<leader>o` - Reload config
- `<leader>y` - Copy to system clipboard
- `<leader>p` - Paste from system clipboard (delete selection)
- `<Esc>` - Clear search highlight
- `<Esc><Esc>` (terminal) - Exit terminal mode

### Navigation
- `<C-h/j/k/l>` - Move between windows
- Leap plugin uses default mappings (`s`, `S`, etc.) - **`<leader>s` is reserved for Leap**

### File Management
- `<leader>e` - Open Oil file manager
- `<leader>f` - Pick files
- `<leader>g` - Pick Git files
- `<leader>/` - Live grep (search in files)
- `<leader>h` - Pick help

### LSP
- `gd` - Go to definition
- `gr` - Go to references
- `<leader>F` - Format buffer

## Tools Required

The following tools must be installed in the Docker images:
- **git** - Required for Git file picker
- **ripgrep** (`rg`) - Required for live grep functionality
- **lazygit** - Git TUI (installed in all images)
- Language servers (gopls, intelephense, etc.)

## Adding New Language Support

To add a new language configuration:

1. Create `init.<language>.lua`
2. Import shared modules:
   ```lua
   vim.g.mapleader = " "
   vim.g.maplocalleader = ' '
   vim.g.have_nerd_font = true
   
   require('config.base').setup()
   require('config.plugins').setup()
   require('config.pickers').setup()
   require('config.treesitter').setup({ "<language>", "dockerfile", "yaml" })
   require('config.lsp').setup({ "<language_server>", "dockerls", "docker_compose_language_service", "yamlls" })
   ```
3. Add any language-specific LSP configuration before calling `require('config.lsp').setup()`
4. Update Dockerfile to build and copy the new configuration

## Benefits of This Structure

1. **DRY Principle**: Common configuration is defined once and reused
2. **Maintainability**: Changes to shared behavior only need to be made in one place
3. **Consistency**: All language setups have the same base behavior
4. **Extensibility**: Easy to add new language-specific configurations
5. **Clarity**: Each file has a clear, focused purpose