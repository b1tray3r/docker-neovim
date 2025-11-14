-- LSP configuration shared across all setups
local M = {}

function M.setup(servers)
  -- Get LSP capabilities for completion
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local capabilities = cmp_nvim_lsp.default_capabilities()

  -- Set LSP log level to ERROR to reduce noise from large file warnings
  vim.lsp.log.level = vim.log.levels.ERROR

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
