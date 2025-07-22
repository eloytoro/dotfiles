local set = vim.keymap.set

return {
  'tpope/vim-repeat',
  'tpope/vim-surround',
  -- 'rcarriga/nvim-notify',
  'junegunn/gv.vim',
  'tpope/vim-rhubarb',
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = "ibl",
    event = 'VeryLazy'
  },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {}, event = 'VeryLazy' },
  'kyazdani42/nvim-web-devicons', -- file icons
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
    config = function()
      set('n', '<leader>gp', ':Git pull<CR>', { silent = true })
      set('n', '<leader>gP', ':Git push<CR>', { silent = true })
      set('n', '<leader>gs', ':Git<CR>gg)', { silent = true })
      set('n', '<leader>gd', ':Gdiff<CR>', { silent = true })
      set('n', '<leader>gb', ':Git blame<CR>', { silent = true })
      set('n', '<leader>gl', ':0Gclog!<CR>', { silent = true })
      set('n', '<leader>gw', ':Gwrite<CR>', { silent = true })
      set('n', '<leader>ge', ':Gedit<CR>', { silent = true })
      set('n', '<leader>gE', ':Gvsplit<CR>', { silent = true })
      set('n', '<leader>gv', ':GV -n 100<CR>', { silent = true })
      set('n', '<leader>gV', ':GV!<CR>', { silent = true })
      set('n', '<leader>gCt', ':execute "Git checkout --theirs ".expand(\'%:p\')<CR>', { silent = true })
      set('n', '<leader>gCo', ':execute "Git checkout --ours ".expand(\'%:p\')<CR>', { silent = true })
      set('n', ']r', ':Git rebase --continue<CR>', { silent = true })
      set('n', '[r', ':Git rebase --edit-todo<CR>', { silent = true })

      set('n', 'git', ':Git')
    end
  },
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
          -- return false
        end
        set('n', '[c', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        set('n', ']c', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  }
}
