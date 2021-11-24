local actions = require('telescope.actions')
local telescope = require('telescope');
telescope.setup {
  defaults = {
    mappings = {
      i = {
        -- ["<esc>"] = actions.close,
        ["<C-h>"] = "which_key",
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-f>"] = actions.preview_scrolling_up,
        ["<C-b>"] = actions.preview_scrolling_down,
        ["<tab>"] = actions.add_selection,
      }
    },
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    color_devicons = true,
    path_display = "smart",
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
telescope.load_extension('fzf')