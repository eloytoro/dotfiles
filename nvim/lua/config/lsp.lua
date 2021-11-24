local user_home = os.getenv("HOME") or "/tmp"

local lsp_status = require('lsp-status')
lsp_status.register_progress()
lsp_status.config {
  current_function = true,
  status_symbol = '%#StatusLineLinNbr#LSP',
  indicator_errors = '%#StatusLineLSPErrors#',
  indicator_warnings = '%#StatusLineLSPWarnings#',
  indicator_info = '%#StatusLineLSPInfo#',
  indicator_hints = '%#StatusLineLSPHints#',
  indicator_ok = '%#StatusLineLSPOk#',
}

vim.cmd [[
  hi StatusLineLinNbr guibg=#23272e guifg=#51afef
  hi StatusLineLSPOk guibg=#23272e guifg=#98be65
  hi StatusLineLSPErrors guibg=#23272e guifg=#ff6c6b
  hi StatusLineLSPWarnings guibg=#23272e guifg=#ECBE7B
  hi StatusLineLSPInfo guibg=#23272e guifg=#51afef
  hi StatusLineLSPHints guibg=#23272e guifg=#c678dd
]]

local lsp = require'lspconfig'
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}
vim.tbl_extend('keep', capabilities, lsp_status.capabilities)


local lsp_attach = function(args)
  return function(client, bufnr)
    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
      vim.api.nvim_exec([[
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]], false)
    end

    if args == nil or args.format == nil or args.format then
      vim.api.nvim_exec([[
        augroup lsp_formatting_sync
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
        augroup END
      ]], false)
    end

    lsp_status.on_attach(client)

    -- make omnifunc go via LSP’s completion directly
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- keybindings
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>clr', '<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<cr>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>.', '<cmd>Telescope lsp_code_actions theme=get_dropdown previewer=false<cr>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>Telescope lsp_references theme=get_dropdown <cr>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ch', '<cmd>lua vim.lsp.buf.signature_help()<cr>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<cr>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cs', '<cmd>Telescope lsp_dynamic_workspace_symbols theme=get_dropdown <cr>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ct', '<cmd>lua vim.lsp.buf.type_definition()<cr>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>d', '<cmd>TroubleToggle<cr>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'x', '<leader>ca', '<cmd>Telescope lsp_range_code_actions theme=get_dropdown<cr>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-a>', '<cmd>Telescope lsp_code_actions theme=get_dropdown<cr>', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-h>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', {})
  end
end

local luasnip = require 'luasnip'

local is_empty_before = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or string.match(string.sub(vim.fn.getline('.'), 0, col), '^%s*$')
end

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-s>'] = cmp.mapping.select_prev_item(),
    ['<C-t>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      elseif not is_empty_before() then
        cmp.complete()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
      elseif not is_empty_before() then
        cmp.complete()
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'crates' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
require('cmp_nvim_lsp').setup {}


-- lua
lsp.sumneko_lua.setup {
  flags = lsp_flags,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },

      diagnostics = {
        enable = true,
        globals = { "vim" },
      },

      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  },

  on_attach = lsp_attach { format = false },
}

-- rust
lsp.rust_analyzer.setup{
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGroup = true,
        importMergeBehaviour = "full",
        importPrefix = "by_crate",
      },

      callInfo = {
        full = true,
      };

      cargo = {
        allFeatures = true,
        autoreload = true,
        loadOutDirsFromCheck = true,
      },

      checkOnSave = {
        enable = true,
        allFeatures = true,
      },

      completion = {
        addCallArgumentSnippets = true,
        addCallParenthesis = true,
        postfix = {
          enable = true,
        },
        autoimport = {
          enable = true,
        },
      },

      diagnostics = {
        enable = true,
        enableExperimental = true,
      },

      hoverActions = {
        enable = true,
        debug = true,
        gotoTypeDef = true,
        implementations = true,
        run = true,
        linksInHover = true,
      },

      lens = {
        enable = true,
        debug = true,
        implementations = true,
        run = true,
        methodReferences = true,
        references = true,
      },

      notifications = {
        cargoTomlNotFound = true,
      },

      procMacro = {
        enable = true,
      },
    }
  },
  on_attach = lsp_attach { format = false },
}

-- typescript
lsp.tsserver.setup {
  on_attach = function(client, bufnr)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    lsp_attach({ format = false })(client, bufnr)
  end,
  root_dir = function(fname)
    return lsp.util.root_pattern("tsconfig.json")(fname);
  end,
}

-- eslint
local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

lsp.efm.setup {
  init_options = {documentFormatting = true},
  filetypes = {"javascript", "typescript"},
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.goto_definition = false
  end,
  root_dir = function(fname)
    return lsp.util.root_pattern("tsconfig.json")(fname) or
    lsp.util.root_pattern(".eslintrc.js", ".git")(fname);
  end,
  settings = {
    rootMarkers = {".eslintrc.js", ".git/"},
    languages = {
      javascript = {eslint},
      typescript = {eslint},
      typescriptreact = {eslint}
    }
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact"
  }
}

-- python
lsp.pylsp.setup{
  on_attach = lsp_attach { format = false }
}

require('config/location-handler')
