--[[
  - https://learnxinyminutes.com/docs/lua/
  - https://neovim.io/doc/user/lua-guide.html
--]]

vim.opt.rtp:prepend('~/dotfiles/kickstart')

require 'config.settings'
require 'config.keymaps'
require 'config.autocmd'
require 'config.location_handler'

vim.cmd.source('~/dotfiles/kickstart/vim/objects.vim')
vim.cmd.source('~/dotfiles/kickstart/vim/git.vim')
vim.cmd.source('~/dotfiles/kickstart/vim/shrug.vim')


-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- https://github.com/folke/lazy.nvim
require('lazy').setup({
  -- Core
  {
    'ggandor/leap.nvim',
    enabled = false,
    config = function()
      vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
      vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
      vim.keymap.set({'n', 'x', 'o'}, 'go', '<Plug>(leap)')
      local leap = require('leap')
      leap.opts.safe_labels = 'sfnutz/SFNLHMUGTZ?'
      require('leap.user').set_repeat_keys(';', ',', {
        -- False by default. If set to true, the keys will work like the
        -- native semicolon/comma, i.e., forward/backward is understood in
        -- relation to the last motion.
        relative_directions = true,
        -- By default, all modes are included.
        modes = {'n', 'x', 'o'},
      })
    end
  },
  {
    'kyazdani42/nvim-tree.lua',
    config = function()
      local nvimtree = require('nvim-tree')
      local api = require('nvim-tree.api')
      nvimtree.setup({
        sort_by = "case_sensitive",
        view = {
          adaptive_size = true,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      })
      vim.keymap.set('n', '<leader>n', function() api.tree.toggle({ find_file = true, focus = true }) end)
      vim.keymap.set('n', '<leader>o', function() api.tree.find_file({ open = true }) end)
    end
  },
  {
    "windwp/nvim-autopairs",
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require("nvim-autopairs").setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end,
  },
  -- 'kevinhwang91/nvim-bqf',
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'folke/neoconf.nvim',
  'haya14busa/is.vim',
  -- {
  --   'voldikss/vim-floaterm',
  --   config = function()
  --     vim.keymap.set('n', '<leader>f', function()
  --       local args = {'--wintype=split', '--opener=tabe', 'yazi'}
  --       local current_file = vim.api.nvim_buf_get_name(0)
  --       if (current_file ~= "") then
  --         table.insert(args, current_file)
  --       end
  --       vim.api.nvim_cmd({
  --         cmd = 'FloatermNew',
  --         args = args
  --       }, {})
  --     end)
  --     vim.keymap.set('n', '<leader>t', ':FloatermNew --wintype=split --opener=tabe yazi<CR>')
  --     vim.keymap.set('n', '<leader>r', function()
  --       local root = vim.fn.trim(vim.fn.system {
  --         'git', '-C', vim.fn.getcwd(), 'rev-parse', '--show-toplevel'
  --       })
  --       vim.cmd(':FloatermNew --wintype=split --opener=tabe yazi '..root)
  --     end)
  --   end
  -- },
  {
    "mikavilpas/yazi.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    event = "VeryLazy",
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>-",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>cw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory" ,
      },
      {
        -- NOTE: this requires a version of yazi that includes
        -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
        '<c-up>',
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    ---@type YaziConfig
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = '<f1>',
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    }
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      multiline_threshold = 1, -- Maximum number of lines to show for a single context
    },
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    }
  },
  {
    'norcalli/nvim-colorizer.lua', -- css colors
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    }
  },
  {
    'windwp/nvim-ts-autotag',
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    }
  },
  {
    'nvim-pack/nvim-spectre',
    dependencies = {
      'nvim-lua/plenary.nvim',
    }
  },
  -- Git related plugins
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gp', ':Git pull<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gP', ':Git push<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gs', ':Git<CR>gg)', { silent = true })
      vim.keymap.set('n', '<leader>gd', ':Gdiff<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gl', ':0Gclog!<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gw', ':Gwrite<CR>', { silent = true })
      vim.keymap.set('n', '<leader>ge', ':Gedit<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gE', ':Gvsplit<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gv', ':GV -n 100<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gV', ':GV!<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gCt', ':execute "Git checkout --theirs ".expand(\'%:p\')<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gCo', ':execute "Git checkout --ours ".expand(\'%:p\')<CR>', { silent = true })
      vim.keymap.set('n', ']r', ':Git rebase --continue<CR>', { silent = true })
      vim.keymap.set('n', '[r', ':Git rebase --edit-todo<CR>', { silent = true })

      vim.keymap.set('n', 'git', ':Git')
    end
  },
  'tpope/vim-rhubarb',
  'rcarriga/nvim-notify',
  'junegunn/gv.vim',
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        if vim.api.nvim_buf_get_name(bufnr):match('fugitive') then
          -- Don't attach to specific buffers whose name matches a pattern
          return false
        end
        vim.keymap.set('n', '[c', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', ']c', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },

  -- Colorschemes
  -- 'navarasu/onedark.nvim',
  -- 'morhetz/gruvbox',
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("tokyonight").setup({
        style = "night"
      })
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
      vim.api.nvim_set_hl(0, 'FlashLabel', { bg = "#000000", bold = true, fg = "#ff007c" })
    end,
  },
  -- 'tyrannicaltoucan/vim-deep-space',
  -- 'AlessandroYorba/Despacio',
  -- 'w0ng/vim-hybrid',
  -- 'Nequo/vim-allomancer',
  -- 'arcticicestudio/nord-vim',
  -- 'mhartington/oceanic-next',
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    config = function()
      local filename = {
        'filename',
        path = 1,
        symbols = {
          modified = "P"
        }
        -- fmt = function (path)
        --   return table.concat({vim.fs.basename(vim.fs.dirname(path)),
        --     vim.fs.basename(path)}, package.config:sub(1, 1))
        -- end
      }
      require('lualine').setup{
        options = {
          -- icons_enabled = false,
          theme = 'tokyonight',
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {filename},
          lualine_x = {'encoding', 'filetype'},
          lualine_y = {},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {filename},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        extensions = {'fugitive', 'nvim-tree'},
      }
    end
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = "ibl",
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- misc
  'junegunn/vim-emoji',
  'kyazdani42/nvim-web-devicons', -- file icons
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  { 'folke/which-key.nvim', opts = {} }, -- Useful plugin to show you pending keybinds.
  {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
  },

  { import = 'plugins' },
}, {})


-- The line beneath this is called `modeline`. See `:help modeline`
  -- vim: ts=2 sts=2 sw=2 et
