return {
  'junegunn/fzf.vim',
  dependencies = {
    {
      'junegunn/fzf',
      build = ':call fzf#install()',
    },
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local builtin = require "telescope.builtin"
    local finders = require "telescope.finders"
    local conf = require("telescope.config").values

    local function on_enter_file(env)
      local target = vim.fn.expand("%:h")
      if target == '' then
        target = '.'
      end
      local rev_parse = vim.system({'git', '-C', target, 'rev-parse', '--show-toplevel'}):wait()
      local root = rev_parse.stdout:match "^%s*(.-)%s*$"

      local telescope_files = function()
        builtin.find_files({
          find_command = {'fdup', root, target},
        })
      end

      local function find_files()
        if vim.fn.executable('fd') and rev_parse.code == 0 then
          vim.fn.call('fzf#vim#files', {'', {
            source = 'fdup ' .. root .. ' ' .. target,
            options = '--no-sort --keep-right --hscroll-off=1000'
          }})
        else
          vim.fn.call('fzf#vim#files', {''})
        end
      end

      vim.keymap.set('n', '<C-p>', find_files, { buffer = env.buf })
      -- vim.keymap.set('n', '<C-p>', telescope_files, { buffer = env.buf })
    end

    local fzf_group = vim.api.nvim_create_augroup('FZFSetup', { clear = true })
    vim.api.nvim_create_autocmd({'BufReadPost', 'VimEnter'}, {
      callback = on_enter_file,
      group = fzf_group,
      pattern = '*',
    })
    vim.keymap.set('n', '<leader>/', ':Ag ')
    vim.g.fzf_files_options = '-e --preview "bat --color=always -p {} 2> /dev/null"'
    vim.g.fzf_buffers_jump = true
    vim.cmd.source('~/dotfiles/nvim/vim/fzf.vim')
  end
}
