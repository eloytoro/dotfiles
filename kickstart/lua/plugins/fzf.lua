local helpers = require('helpers')

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
      local root = vim.fn.trim(rev_parse.stdout)

      local function find_files()
        local width = vim.fn.winwidth(0) - 1
        local fzf_options = {
          '--no-sort', '--keep-right', '--no-hscroll', '--border=none',
          '--preview', 'bat --color=always --style="header,grid" --terminal-width='..width..' {} 2> /dev/null',
          '--preview-window', 'up,50%,border-bottom,~3,+3',
        }
        if vim.fn.executable('fd') and rev_parse.code == 0 then
          vim.fn.call('fzf#vim#files', {'', {
            source = 'fdup ' .. root .. ' ' .. target,
            options = fzf_options,
            border = 'none',
            style = 'plain',

            window = {
              width = 1,
              height = 0.8,
              border = 'none',
              yoffset = 1,
            },
          }})
        else
          vim.fn.call('fzf#vim#files', {'', {
            options = opts
          }})
        end

      end

      vim.keymap.set('n', '<C-p>', find_files, { buffer = env.buf })
      -- vim.keymap.set('n', '<C-p>', telescope_files, { buffer = env.buf })

      vim.api.nvim_create_user_command('AgEx', function (opts)
        local width = vim.fn.winwidth(0) - 1
        local fzf_options = {
          '-d:', '--no-sort', '--keep-right', '--border=none',
          '--preview', 'bat --color=always --highlight-line={2}  --terminal-width='..width..' {1}',
          '--preview-window', 'up,50%,border-bottom,wrap,~3,+{2}+3/2',
        }
        vim.fn.call('fzf#vim#ag', {opts.args, {
          options = fzf_options,
          border = 'none',
          style = 'plain',
          window = {
            width = 1,
            height = 0.8,
            border = 'none',
            yoffset = 1,
          },
        }})
      end, {bang = false, nargs=1})
    end

    local fzf_group = vim.api.nvim_create_augroup('FZFSetup', { clear = true })
    vim.api.nvim_create_autocmd({'BufReadPost', 'VimEnter'}, {
      callback = on_enter_file,
      group = fzf_group,
      pattern = '*',
    })
    vim.keymap.set('n', '<leader>/', ':AgEx ')
    vim.g.fzf_buffers_jump = true

    vim.cmd.source('~/dotfiles/kickstart/vim/fzf.vim')
  end
}
