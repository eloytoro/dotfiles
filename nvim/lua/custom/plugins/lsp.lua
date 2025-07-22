return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'pmizio/typescript-tools.nvim',
      'stevearc/conform.nvim',
    },
    config = function()
      local lsp = require 'lspconfig'
      local util = require 'lspconfig.util'

      require('custom.autoformat').setup()

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

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

      local function inlay_hints(client, bufnr)
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

      lsp.rust_analyzer.setup({
        -- works with rust nightly-2022-09-19
        cmd = { "rustup", "run", "nightly", "rust-analyzer" },
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
            },

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
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>br',
            '<cmd>belowright 10sp | term cargo build --release<cr>', {})
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>db', '<cmd>belowright 10sp | term rustup doc --book<cr>',
            {})
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>dd', '<cmd>belowright 10sp | term cargo doc --open<cr>',
            {})
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>ds', '<cmd>belowright 10sp | term rustup doc --std<cr>',
            {})
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>rd', '<cmd>belowright 10sp | term cargo run<cr>', {})
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>rr',
            '<cmd>belowright 10sp | term cargo run --release<cr>', {})

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
      -- vim.lsp.config('ts_ls', {
      --   on_attach = on_attach,
      -- })
      -- vim.lsp.enable('ts_ls')
      require("typescript-tools").setup {
        on_attach = on_attach
      }


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

      local base_on_attach = vim.lsp.config.eslint.on_attach
      vim.lsp.config("eslint", {
        settings = {
          nodePath = ".yarn/sdks",
          packageManager = "yarn",
          codeActionOnSave = {
            enable = true,
            mode = "all"
          },
        },
        on_attach = function(client, bufnr)
          if not base_on_attach then return end

          base_on_attach(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "LspEslintFixAll",
          })
        end
      })
      vim.lsp.enable('eslint')

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

      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using (most
              -- likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              -- Tell the language server how to find Lua modules same way as Neovim
              -- (see `:h lua-module-load`)
              path = {
                'lua/?.lua',
                'lua/?/init.lua',
              },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
                -- Depending on the usage, you might want to add additional paths
                -- here.
                -- '${3rd}/luv/library'
                -- '${3rd}/busted/library'
              }
              -- Or pull in all of 'runtimepath'.
              -- NOTE: this is a lot slower and will cause issues when working on
              -- your own configuration.
              -- See https://github.com/neovim/nvim-lspconfig/issues/3189
              -- library = {
              --   vim.api.nvim_get_runtime_file('', true),
              -- }
            }
          })
        end,
        settings = {
          Lua = {}
        }
      })

      vim.lsp.enable('lua_ls')
    end
  },
  {
    -- shows progress of lsp
    "j-hui/fidget.nvim",
    opts = {
      -- options
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  }
}
