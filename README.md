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

## Running with Clipboard Support

To enable clipboard support (copy/paste to/from host), you need to:

1. Share the X11 socket with the container
2. Set the DISPLAY environment variable

```bash
# For PHP
docker run -it --rm \
  -v $(pwd):/workspace \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  nvim-php

# For Go
docker run -it --rm \
  -v $(pwd):/workspace \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  nvim-go

# For Base
docker run -it --rm \
  -v $(pwd):/workspace \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  nvim-base
```

**Note:** On the host, you may need to allow X11 connections:
```bash
xhost +local:docker
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
