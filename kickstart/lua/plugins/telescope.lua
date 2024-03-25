-- Fuzzy Finder (files, lsp, etc)
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
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
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
      defaults = {
        borders = false,
        path_display = { "smart" },
        cache_picker = {
          num_pickers = 5,
        },
        layout_strategy = "vertical",
        -- pickers = {
        --   find_files = {
        --   }
        -- },
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-S-j>'] = function (bufnr)
              actions.toggle_selection(bufnr)
              actions.move_selection_next(bufnr)
            end,
            ['<C-S-k>'] = function (bufnr)
              actions.toggle_selection(bufnr)
              actions.move_selection_previous(bufnr)
            end,
            ['<C-f>'] = actions.preview_scrolling_up,
            ['<C-b>'] = actions.preview_scrolling_down,
            ['<S-TAB>'] = actions.select_all,
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
    vim.keymap.set('n', '<leader>,', builtin.resume)

    vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Search [G]it [F]iles' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  end
}
