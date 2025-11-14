# Neovim Development Containers

Single multi-stage Dockerfile with multiple build targets for language-specific environments.

## Build Targets

### Base Image (Docker/Docker Compose/YAML)
```bash
docker build --target base -t nvim-base .
docker run -it --rm -v $(pwd):/workspace nvim-base
```

### Go Image
```bash
docker build --target go -t nvim-go .
docker run -it --rm -v $(pwd):/workspace nvim-go
```

### PHP Image
```bash
docker build --target php -t nvim-php .
docker run -it --rm -v $(pwd):/workspace nvim-php
```

## Included Components

### Base Target
- Neovim nightly
- dockerfile-language-server-nodejs
- @microsoft/compose-language-service
- yaml-language-server
- Treesitter: dockerfile, yaml

### Go Target (includes base)
- Go 1.25.4
- gopls
- golangci-lint
- Treesitter: go, dockerfile, yaml

### PHP Target (includes base)
- intelephense
- Treesitter: php, dockerfile, yaml

## Configuration Files

- Base: `init.lua`
- Go: `init.go.lua`
- PHP: `init.php.lua`

## Features

- German locale (de_DE.UTF-8)
- Multi-stage builds for minimal image size
- Build tools excluded from final images
- Pre-compiled plugins and treesitter parsers

## Key Mappings

- `<Space>` - Leader key
- `<leader>f` - Fuzzy find files
- `<leader>e` - File browser (Oil)
- `<leader>F` - Format buffer
- `<leader>w` - Save file
- `<C-h/j/k/l>` - Navigate windows
- `gd` - Go to definition
- `gr` - Go to references
