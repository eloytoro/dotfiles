local helpers = require 'helpers'
local util = require 'lspconfig.util'

return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',

    -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    'folke/neodev.nvim',

    -- misc
    'jose-elias-alvarez/typescript.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local signs = {
      { name = "DiagnosticSignError", text = "" },
      { name = "DiagnosticSignWarn", text = "" },
      { name = "DiagnosticSignHint", text = "" },
      { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    vim.diagnostic.config {
      virtual_text = {
        source = "always",
        prefix = "» ",
        spacing = 6,
      },
      float = {
        header = false,
        source = "always",
      },
      signs = true,
      underline = true,
      update_in_insert = false,
    }

    vim.cmd [[
      hi StatusLineLinNbr guibg=#23272e guifg=#51afef
      hi StatusLineLSPOk guibg=#23272e guifg=#98be65
      hi StatusLineLSPErrors guibg=#23272e guifg=#ff6c6b
      hi StatusLineLSPWarnings guibg=#23272e guifg=#ECBE7B
      hi StatusLineLSPInfo guibg=#23272e guifg=#51afef
      hi StatusLineLSPHints guibg=#23272e guifg=#c678dd
    ]]

    local neodev = require 'neodev'
    local lsp = require 'lspconfig'
    local mason_lspconfig = require 'mason-lspconfig'

    neodev.setup()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    mason_lspconfig.setup {}

    vim.api.nvim_create_user_command('LspServerCapabilities', function()
      vim.print(vim.lsp.get_clients()[1].server_capabilities)
    end, {})

    vim.api.nvim_create_user_command('LspClientCapabilities', function()
      vim.print(vim.lsp.get_clients()[1].server_capabilities)
    end, {})

    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      }
    }

    local function format_on_save(client, bufnr)
      vim.api.nvim_exec([[
        augroup lsp_formatting_sync
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = false })
        augroup END
      ]], false)
    end

    local function inlay_hints (client, bufnr)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
        end
    end

    local function code_lens(client, bufnr)
      if vim.lsp.codelens then
        if client.supports_method("textDocument/codeLens") then
          vim.lsp.codelens.refresh()
          --- autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
          })
        end
        local opts = { buffer = bufnr }
        vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
      end
    end

    local function on_attach(client, bufnr)
      -- Set autocommands conditional on server_capabilities
      if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_exec([[
          augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
        ]], false)
      end

      -- lsp_status.on_attach(client)

      local themes = require("telescope.themes")
      local builtin = require("telescope.builtin")
      local opts = { buffer = bufnr }

      -- make omnifunc go via LSP’s completion directly
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- keybindings
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      -- vim.keymap.set('n', '<leader>clr', function()
      --   vim.lsp.stop_client(vim.lsp.get_active_clients())
      -- end, opts)
      vim.keymap.set('n', '<space>.', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<space><c-.>', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gd', function()
        builtin.lsp_definitions({
          jump_type = 'never'
        })
      end, opts)
      vim.keymap.set('n', 'gr', function()
        builtin.lsp_references(themes.get_dropdown({
          trim_text = true,
          fname_width = 80,
          layout_config = {
            width = 0.9
          }
        }))
      end, opts)
      vim.keymap.set('n', '<leader>ch', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>ls', function()
        builtin.lsp_workspace_symbols(themes.get_dropdown())
      end, opts)
      vim.keymap.set('n', '<leader>ct', builtin.lsp_type_definitions, opts)
      vim.keymap.set('n', '<leader>d', builtin.diagnostics, opts)
      vim.keymap.set('x', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('i', '<C-a>', function()
        builtin.lsp_code_actions(themes.get_cursor())
      end, opts)
      vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
    end

    local defaultOpts = {
      capabilities,
      on_attach,
    }

    -- mason_lspconfig.setup_handlers {
    --   function(server_name)
    --     require('lspconfig')[server_name].setup(defaultOpts)
    --   end,
    -- }
    --
    -- nvim-cmp setup
    local cmp = require 'cmp'
    cmp.setup {
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
          elseif not helpers.is_empty_before() then
            cmp.complete()
          else
            fallback()
          end
        end,
        ['<S-Tab>'] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
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
      },
    }

    lsp.lua_ls.setup({
      capabilities,
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace"
          }
        }
      },
      on_attach,
    })

    lsp.rust_analyzer.setup({
      -- works with rust nightly-2022-09-19
      cmd = {"rustup", "run", "nightly", "rust-analyzer"},
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          assist = {
            importGroup = true,
            importGranularity = "crate",
            importPrefix = "crate",
          },

          callInfo = {
            full = true,
          };

          cargo = {
            allFeatures = true,
            autoreload = true,
            loadOutDirsFromCheck = true,
          },

          check = {
            command = "clippy"
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
        },
      },
      on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>bb', '<cmd>belowright 10sp | term cargo build<cr>', {})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>bc', '<cmd>belowright 10sp | term cargo check<cr>', {})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>br', '<cmd>belowright 10sp | term cargo build --release<cr>', {})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>db', '<cmd>belowright 10sp | term rustup doc --book<cr>', {})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>dd', '<cmd>belowright 10sp | term cargo doc --open<cr>', {})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>ds', '<cmd>belowright 10sp | term rustup doc --std<cr>', {})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>rd', '<cmd>belowright 10sp | term cargo run<cr>', {})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>rr', '<cmd>belowright 10sp | term cargo run --release<cr>', {})

        vim.g.which_key_local_map = {
          b = {
            name = '+build',
            b = 'build',
            c = 'check',
            r = 'build (release)',
          },
          d = {
            name = '+documentation',
            b = 'open the book',
            d = 'document everything',
            s = 'standard library documentation',
          },
          r = {
            name = '+run',
            d = 'debug run',
            r = 'release run',
          },
        }

        format_on_save(client, bufnr)
        return on_attach(client, bufnr)
      end
    })

    lsp.astro.setup(defaultOpts)
    lsp.ts_ls.setup({
      root_dir = util.root_pattern('.git'),
      on_attach = on_attach,
      capabilities = capabilities,
    })
    local vue_language_server_path = '~/.volta/tools/image/packages/@vue/language-server/bin/vue-language-server'
    local vue_plugin = {
      name = '@vue/typescript-plugin',
      location = vue_language_server_path,
      languages = { 'vue' },
      configNamespace = 'typescript',
    }
    vim.lsp.config('vtsls', {
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              vue_plugin,
            },
          },
        },
      },
      filetypes = { 'vue' },
    })
    vim.lsp.enable('vtsls')
    vim.lsp.enable('vue_ls')
    lsp.pylsp.setup(defaultOpts)

    lsp.eslint.setup {
      capabilities,
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
        on_attach(client, bufnr)
      end
    }

    lsp.gopls.setup {
      capabilities,
      on_attach = function(client, bufnr)
        format_on_save(client, bufnr)
        inlay_hints(client, bufnr)
        on_attach(client, bufnr)
        code_lens(client, bufnr)
      end,
      settings = {
        gopls = {
          -- env = {
          --   GOPACKAGESDRIVER = './tools/gopackagesdriver.sh'
          -- },
          -- directoryFilters = {
          --   "-bazel-bin",
          --   "-bazel-out",
          --   "-bazel-testlogs",
          --   "-bazel-mypkg",
          -- },
          experimentalPostfixCompletions = true,
          analyses = {
            unusedparams = true,
            shadow = true,
          },
          staticcheck = true,
          hints = {
            -- assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          ["ui.codelenses"] = {
            test = true,
            generate = true,
          },
        },
      }
    }
  end
}
