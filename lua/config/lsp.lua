-- LSP configuration shared across all setups
local M = {}

function M.setup(servers)
  -- Get LSP capabilities for completion
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local capabilities = cmp_nvim_lsp.default_capabilities()

  -- Set LSP log level to ERROR to reduce noise from large file warnings
  vim.lsp.log.level = vim.log.levels.ERROR

  -- Configure intelephense (PHP)
  vim.lsp.config.intelephense = {
    cmd = { "intelephense", "--stdio" },
    filetypes = { "php" },
    root_markers = { "composer.json", ".git", "index.php", ".editorconfig" },
    single_file_support = true,
    capabilities = capabilities,
    settings = {
      intelephense = {
        files = {
          maxSize = 5000000,
          associations = { "**/*.php", "**/*.phtml" },
          exclude = {
            "**/vendor/**/test/**",
            "**/vendor/**/tests/**",
            "**/Test/**",
            "**/Tests/**",
            "**/.git/**",
            "**/node_modules/**",
          },
        },
        environment = {
          includePaths = { "/workspace" },
          -- phpVersion is auto-detected from composer.json or can be overridden per project
          -- by creating a .intelephense/settings.json file in the project root
        },
        completion = {
          triggerParameterHints = true,
          insertUseDeclaration = true,
          fullyQualifyGlobalConstantsAndFunctions = false,
        },
        diagnostics = {
          enable = true,
        },
      },
    },
  }

  -- Configure gopls (Go)
  vim.lsp.config.gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    capabilities = capabilities,
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

  -- Configure dockerls
  vim.lsp.config.dockerls = {
    cmd = { "docker-langserver", "--stdio" },
    filetypes = { "dockerfile" },
    root_markers = { ".git" },
    capabilities = capabilities,
  }

  -- Configure docker_compose_language_service
  vim.lsp.config.docker_compose_language_service = {
    cmd = { "docker-compose-langserver", "--stdio" },
    filetypes = { "yaml.docker-compose" },
    root_markers = { "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml" },
    capabilities = capabilities,
  }

  -- Configure yamlls
  vim.lsp.config.yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yaml.docker-compose" },
    root_markers = { ".git" },
    capabilities = capabilities,
  }

  -- Enable LSP servers
  vim.lsp.enable(servers)

  -- LSP attach autocmd
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)

      -- Keymaps
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = 'Go to definition' })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, desc = 'Go to references' })
      vim.keymap.set('n', '<leader>F', vim.lsp.buf.format, { buffer = ev.buf, desc = 'Format buffer' })

      -- Auto-format and organize imports on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = ev.buf,
        callback = function()
          local bufname = vim.api.nvim_buf_get_name(ev.buf)
          if bufname:match("^oil://") then
            return
          end
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          -- Only try organize imports for servers that support it (e.g., gopls)
          -- Skip for intelephense (PHP) as it doesn't support this code action
          if client and client.name ~= "intelephense" then
            local params = vim.lsp.util.make_range_params(nil, client.offset_encoding or "utf-16")
            params.context = { only = { "source.organizeImports" } }

            local result = vim.lsp.buf_request_sync(ev.buf, "textDocument/codeAction", params, 1000)
            for _, res in pairs(result or {}) do
              for _, action in pairs(res.result or {}) do
                if action.edit or type(action.command) == "table" then
                  if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                  end
                  if type(action.command) == "table" then
                    vim.lsp.buf.execute_command(action.command)
                  end
                else
                  vim.lsp.buf.execute_command(action)
                end
              end
            end
          end

          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  })

  -- Customize hover handler
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {
      border = "rounded",
      max_width = 80,
    }
  )
end

return M
