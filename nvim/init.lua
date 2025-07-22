--[[
  - https://learnxinyminutes.com/docs/lua/
  - https://neovim.io/doc/user/lua-guide.html
--]]

vim.opt.runtimepath:prepend('~/dotfiles/nvim')

require 'custom.config.opt'
require 'custom.config.keymaps'
require 'custom.config.autocmd'
require 'custom.config.commands'
-- require 'config.location_handler'


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
vim.opt.runtimepath:prepend(lazypath)

-- https://github.com/folke/lazy.nvim
require('lazy').setup({ import = 'custom.plugins' }, {
  performance = {
    rtp = {
      paths = { '~/dotfiles/nvim' }
    }
  },
  change_detection = {
    notify = false,
  },
})

vim.cmd([[colorscheme tokyonight]])

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
