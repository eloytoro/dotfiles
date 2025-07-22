local setup = function()
  -- Autoformatting Setup
  local conform = require "conform"
  conform.setup {
    formatters = {},
    formatters_by_ft = {
      lua = { "stylua" },
    },
  }

  conform.formatters.injected = {
    options = {
      ignore_errors = false,
      lang_to_formatters = {
        sql = { "sleek" },
      },
    },
  }

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("custom-conform", { clear = true }),
    callback = function(args)
      -- local ft = vim.bo.filetype
      require("conform").format {
        bufnr = args.buf,
        lsp_fallback = true,
        quiet = true,
        filter = function(client)
          return client.name ~= "ts_ls" and client.name ~= "typescript-tools"
        end,
      }
    end,
  })
end

setup()

return { setup = setup }
