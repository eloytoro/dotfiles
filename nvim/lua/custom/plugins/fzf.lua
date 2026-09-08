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

    local function nearest_existing_path(path)
      local uv = vim.uv or vim.loop
      while path and path ~= '' do
        if uv.fs_stat(path) then
          return path
        end

        local parent = vim.fs.dirname(path)
        if not parent or parent == path then
          break
        end
        path = parent
      end
    end

    local function filefan_target(bufnr)
      local path = vim.api.nvim_buf_get_name(bufnr)
      if path:match('^fugitive://') and vim.fn.exists('*FugitiveReal') == 1 then
        path = vim.fn.FugitiveReal(path)
      elseif path:match('^%a[%w+.-]*://') then
        path = nil
      end

      return nearest_existing_path(path) or vim.fn.getcwd()
    end

    local function on_enter_file(env)
      local function find_files()
        local width = vim.fn.winwidth(0) - 1
        local fzf_options = {
          '--scheme=path', '--tiebreak=index', '--keep-right', '--no-hscroll', '--border=none',
          '--preview', 'bat --color=always --style="header,grid" --terminal-width=' .. width .. ' {} 2> /dev/null',
          '--preview-window', 'up,50%,border-bottom,~3,+3',
        }
        if vim.fn.executable('filefan') then
          local target = filefan_target(env.buf)
          vim.fn.call('fzf#vim#files', { '', {
            source = 'filefan ' .. vim.fn.shellescape(target),
            options = fzf_options,
            border = 'none',
            style = 'plain',

            window = {
              width = 1,
              height = 0.8,
              border = 'none',
              yoffset = 1,
            },
          } })
        else
          vim.fn.call('fzf#vim#files', { '', {
            options = opts
          } })
        end
      end

      vim.keymap.set('n', '<C-p>', find_files, { buffer = env.buf })
      -- vim.keymap.set('n', '<C-p>', telescope_files, { buffer = env.buf })

      vim.api.nvim_create_user_command('AgEx', function(opts)
        local width = vim.fn.winwidth(0) - 1
        local fzf_options = {
          '-d:', '--no-sort', '--keep-right', '--border=none',
          '--preview', 'bat --color=always --highlight-line={2}  --terminal-width=' .. width .. ' {1}',
          '--preview-window', 'up,50%,border-bottom,wrap,~3,+{2}+3/2',
        }
        vim.fn.call('fzf#vim#ag', { opts.args, {
          options = fzf_options,
          border = 'none',
          style = 'plain',
          window = {
            width = 1,
            height = 0.8,
            border = 'none',
            yoffset = 1,
          },
        } })
      end, { bang = false, nargs = 1 })
    end

    local fzf_group = vim.api.nvim_create_augroup('FZFSetup', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufReadPost', 'VimEnter' }, {
      callback = on_enter_file,
      group = fzf_group,
      pattern = '*',
    })
    vim.keymap.set('n', '<leader>/', ':AgEx ')
    vim.g.fzf_buffers_jump = true
  end
}
