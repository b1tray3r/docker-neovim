# Neovim Development Containers

Single multi-stage Dockerfile with multiple build targets for language-specific environments.

## Build Targets

A `justfile` is provided for convenience. Run `just` (or `just build`) to build all images at once.

### Base Image (Docker/Docker Compose/YAML)
```bash
just build-base
just run-base
```

### Go Image
```bash
just build-go
just run-go
```

### PHP Image
```bash
just build-php
just run-php
```

## Running with Clipboard Support

To enable clipboard support (copy/paste to/from host), you need to:

1. Share the X11 socket with the container
2. Set the DISPLAY environment variable

The X11 recipes handle this automatically (including calling `xhost +local:docker`):

```bash
just run-php-x11
just run-go-x11
just run-base-x11
```

## Project-Specific PHP Version

Intelephense auto-detects the PHP version from `composer.json`. If you need to override it for a specific project, create a `.intelephense/settings.json` file in your project root:

```bash
# In your project root (e.g., /workspace)
mkdir -p .intelephense
cat > .intelephense/settings.json << 'EOF'
{
  "intelephense.environment.phpVersion": "8.2.0"
}
EOF
```

Alternatively, you can specify it in `composer.json`:

```json
{
  "require": {
    "php": "^8.2"
  }
}
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
