-- Fuzzy Finder (files, lsp, etc)
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    'nvim-telescope/telescope-symbols.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
  },
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    local actions = require('telescope.actions')
    local action_utils = require('telescope.actions.utils')

    local function open_or_qflist(prompt_bufnr)
      local selected = 0
      action_utils.map_selections(prompt_bufnr, function()
        selected = selected + 1
      end)
      if selected == 0 then
        actions.select_default(prompt_bufnr)
      else
        actions.send_selected_to_qflist(prompt_bufnr)
        actions.open_qflist(prompt_bufnr)
        vim.api.nvim_command('cc')
      end
    end
    telescope.setup {
      defaults = {
        borders = false,
        path_display = { "smart" },
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-f>'] = actions.preview_scrolling_up,
            ['<C-b>'] = actions.preview_scrolling_down,
            ['<S-TAB>'] = actions.toggle_selection,
            ['<TAB>'] = actions.toggle_selection,
            ['<ESC>'] = actions.close,
            ['<CR>'] = open_or_qflist,
            ['<C-t>'] = function(prompt_bufnr)
              local selected = 0
              action_utils.map_selections(prompt_bufnr, function()
                selected = selected + 1
              end)
              if selected == 0 then
                actions.file_tab(prompt_bufnr)
              else
                actions.send_selected_to_qflist(prompt_bufnr)
                vim.api.nvim_command('tabnew')
                actions.open_qflist(prompt_bufnr)
                vim.api.nvim_command('cc')
              end
            end
          },
        },
      },
    }

    -- Enable telescope fzf native, if installed
    pcall(telescope.load_extension, 'fzf')

    -- See `:help telescope.builtin`
    vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>f', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Search [G]it [F]iles' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  end
}
