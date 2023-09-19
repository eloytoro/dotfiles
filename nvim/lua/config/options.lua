vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldcolumn = "0"
vim.opt.backup = false
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.showcmd = true
vim.opt.joinspaces = false
vim.opt.ruler = true
vim.opt.showmatch = true
vim.opt.scrolloff = 2
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakat = ""
vim.opt.wildmenu = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.conceallevel = 0
vim.opt.autoread = true
vim.opt.nosol = true
vim.opt.hidden = true
vim.opt.ignorecase = "smartcase"
vim.opt.writebackup = false
vim.opt.showmode = false
vim.opt.list = false
vim.opt.expandtab = "smarttab"
vim.opt.virtualedit ="block"

vim.opt.laststatus=2
vim.opt.pastetoggle=<F7>
vim.opt.splitbelow
if has('nvim')
  vim.opt.inccommand=split
endif
if has('patch-7.4.338')
    vim.opt.showbreak=↳\ 
    vim.opt.breakindent
    vim.opt.breakindentopt=sbr
endif
" set encoding=utf-8
vim.opt.visualbell
vim.opt.colorcolumn=100
vim.opt.formatoptions+=rojn
vim.opt.diffopt=filler,vertical
vim.opt.ttymouse=xterm2
" set mouse=a
vim.opt.nostartofline
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    " set ttimeout
    " set ttimeoutlen=0
else
    vim.opt.nocompatible
    vim.opt.noswapfile
endif
vim.opt.updatetime=300
