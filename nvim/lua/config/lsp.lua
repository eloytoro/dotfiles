local user_home = os.getenv("HOME") or "/tmp"
local dev_path = string.format("%s/dev", user_home)
local helpers = require('config/helpers')
local local_config = helpers.read_local_editor_config()

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

    local themes = require("telescope.themes")
    local builtin = require("telescope.builtin")
    local opts = { buffer = bufnr }

    -- make omnifunc go via LSP’s completion directly
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- keybindings
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>clr', function()
      vim.lsp.stop_client(vim.lsp.get_active_clients())
    end, opts)
    vim.keymap.set('n', '<space>.', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space><c-.>', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', function()
      builtin.lsp_references({ layout_strategy = "vertical", layout_config = { width = 0.9 } })
    end, opts)
    vim.keymap.set('n', '<leader>ch', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>cs', function()
      builtin.dynamic_workspace_symbols(themes.get_dropdown())
    end, opts)
    vim.keymap.set('n', '<leader>ct', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>d', '<cmd>TroubleToggle<cr>', opts)
    vim.keymap.set('x', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('i', '<C-a>', function()
      builtin.lsp_code_actions(themes.get_cursor())
    end, opts)
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
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
      select = false,
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
  cmd = {
    string.format("%s/lua-language-server/macOS/lua-language-server", dev_path),
    "-E",
    string.format("%s/lua-language-server/macOS/main.lua", dev_path)
  },
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
require('rust-tools').setup({
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
          enable = false,
          show_parameter_hints = false,
          parameter_hints_prefix = "",
          other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        on_attach = lsp_attach { format = true },
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
                -- cargo = {
                --   allFeatures = true
                -- }
            }
        }
    },
})

-- typescript
lsp.tsserver.setup {
  on_attach = function(client, bufnr)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>")
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "go", ":TSLspImportAll<CR>")
    -- require "lsp_signature".on_attach({
    --   hint_prefix = "💡"
    -- }, bufnr)
    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.setup {
      update_imports_on_move = true,
      require_confirmation_on_move = false,
    }
    ts_utils.setup_client(client)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>=", ":TSLspOrganize<CR>", { silent = true })

    lsp_attach({ format = false })(client, bufnr)
  end,
  root_dir = function(fname)
    return lsp.util.root_pattern("tsconfig.json")(fname);
  end,
}

--[[
local null_ls = require("null-ls")
local null_ls_source_prettier_cfg = {
  prefer_local = ".yarn/sdks/prettier/bin"
}
null_ls.config({
  sources = {
    null_ls.builtins.formatting.prettier.with(null_ls_source_prettier_cfg) -- prettier, eslint, eslint_d, or prettierd
  },
})

lsp["null-ls"].setup({
  on_attach = lsp_attach{ format = true }
})
]]--

-- python
lsp.pylsp.setup{
  on_attach = lsp_attach { format = false }
}

lsp.eslint.setup {
  -- settings = local_config.eslint,
  settings = {
    nodePath = ".yarn/sdks",
    packageManager = "yarn",
    codeActionOnSave = {
      enable = true,
      mode = "all"
    },
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_exec([[
      augroup lsp_eslint_fix_all
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> EslintFixAll
      augroup END
    ]], false)
    lsp_attach({ format = false })(client, bufnr)
  end
}

require('config/location-handler')
