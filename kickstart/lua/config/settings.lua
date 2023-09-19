-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set highlight on search
-- vim.o.hlsearch = false

-- Make relative line numbers default
vim.wo.rnu = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true
vim.o.showbreak = '↳ '
vim.o.breakindentopt='sbr'

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.list = true
vim.o.listchars = 'tab:¦ ,trail:·,extends:»,precedes:«,nbsp:×'

vim.opt.nu = true
vim.opt.rnu = true
vim.opt.showcmd = true
vim.opt.joinspaces = false
vim.opt.ruler = true
vim.opt.showmatch = true
vim.opt.scrolloff = 2
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.wildmenu = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.conceallevel = 0
vim.opt.autoread = true
vim.opt.startofline = false
vim.opt.hidden = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.showmode = false
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.virtualedit = 'block'
vim.opt.laststatus = 2
vim.opt.splitbelow = true
vim.opt.inccommand = 'split'
vim.opt.visualbell = true
-- vim.opt.colorcolumn = 100
vim.opt.formatoptions:append('rojn')
vim.opt.diffopt = 'filler,vertical'
