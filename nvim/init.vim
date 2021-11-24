filetype off
if has('nvim')
  let vim_folder = '~/.config/nvim'
else
  let vim_folder = '~/.vim'
endif
if empty(glob(vim_folder.'/autoload/plug.vim'))
  exec 'silent !mkdir -p '.vim_folder.'/autoload'
  exec 'silent !curl -fLo '.vim_folder.'/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall
endif

call plug#begin(vim_folder.'/plug')


" ----------------------------------------------------------------------------
"  Local vimrc
" ----------------------------------------------------------------------------

" Essential
Plug 'tpope/vim-git'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-abolish'
" Plug 'shumphrey/fugitive-gitlab.vim'
if has('nvim')
  " Plug 'airblade/vim-gitgutter'
endif
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'mbbill/undotree'
" Plug 'preservim/nerdtree'
Plug 'haya14busa/incsearch.vim'
Plug 'svermeulen/vim-cutlass'
Plug 'svermeulen/vim-yoink'
Plug 'svermeulen/vim-subversive'
" Plug 'easymotion/vim-easymotion'
Plug 'phaazon/hop.nvim'
Plug 'Raimondi/delimitMate'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/gv.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-after-object'
if exists('##TextYankPost')
  Plug 'machakann/vim-highlightedyank'
  let g:highlightedyank_highlight_duration = 100
endif
" Plug 'justinmk/vim-gtfo'
" Plug 'junegunn/goyo.vim'
" Plug 'junegunn/limelight.vim'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'folke/trouble.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'norcalli/nvim-colorizer.lua'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'rcarriga/nvim-notify'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'L3MON4D3/LuaSnip'
Plug 'mhartington/formatter.nvim'
" Language specific
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
" Plug 'othree/yajs.vim'
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'digitaltoad/vim-jade', { 'for': 'jade' }
" Plug 'leafgarland/typescript-vim'
" Plug 'peitalin/vim-jsx-typescript'
" Colorschemes
Plug 'jacoborus/tender'
"Plug 'frankier/neovim-colors-solarized-truecolor-only'
"Plug 'eloytoro/jellybeans.vim'
"Plug 'eloytoro/xoria256'
Plug 'junegunn/seoul256.vim'
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'AlessandroYorba/Despacio'
" Plug 'cocopon/iceberg.vim'
Plug 'w0ng/vim-hybrid'
Plug 'Nequo/vim-allomancer'
Plug 'arcticicestudio/nord-vim'
Plug 'mhartington/oceanic-next'
" Plug 'sainnhe/everforest'
" Plug 'sts10/vim-pink-moon'
" Plug 'rakr/vim-two-firewatch'
Plug 'junegunn/vim-emoji'
" Plug 'posva/vim-vue', { 'for': 'vue' }
" Plug 'yuezk/vim-js', { 'for': 'javascriptreact' }
" Plug 'maxmellon/vim-jsx-pretty', { 'for': 'javascriptreact' }
" Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescriptreact' }

call plug#end()

" ----------------------------------------------------------------------------
" Colorschemes
" ----------------------------------------------------------------------------
syntax enable
set tgc
if has("termguicolors")
  set termguicolors
  set background=dark
  " let g:everforest_background = 'hard'
  " silent! colorscheme hybrid
  silent! colorscheme allomancer
  "hi ColorColumn guibg=#111111
else
  let g:seoul256_background = 233
  silent! colorscheme seoul256
  hi MatchParen ctermfg=yellow
  "let g:indentLine_color_term = 248
  hi ColorColumn ctermbg=234 guibg=#111111
endif

let g:nvim_tree_icons = {
    \ 'git': {
    \   'unstaged': "M",
    \   'staged': "+",
    \   'untracked': "U",
    \   },
    \ }

set rtp+=

lua << EOF
require('hop').setup()
require('trouble').setup()
require('gitsigns').setup({
  on_attach = function(bufnr)
    if vim.api.nvim_buf_get_name(bufnr):match('fugitive') then
      -- Don't attach to specific buffers whose name matches a pattern
      return false
    end
  end
})
local prettier = {
  -- prettier
  function()
    return {
      exe = "prettier",
      args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
      stdin = true
    }
  end
}
require('formatter').setup({
  filetype = {
    javascript = prettier,
    typescript = prettier,
    typescriptreact = prettier,
    python = {
      -- Configuration for psf/black
      function()
        return {
          exe = "black", -- this should be available on your $PATH
          args = { '-' },
          stdin = true,
        }
      end
    }
  }
})
require('nvim-tree').setup({
  update_to_buf_dir = {
    auto_open = false,
    auto_close = true,
  },
  tab_open = false,
  update_focused_file = {
    enable = true,
  },
})
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,              -- false will disable the whole extension
  },

  indent = {
    enable = false,
  },

  textobjects = {
    enable = true
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
})
require('colorizer').setup {}

require('config.telescope')
require('config.lsp')
require('config.statusline')
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'
EOF

let g:jsx_ext_required = 0

function! s:statusline_expr()
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline().' ' : ''}"
  " let coc_status = "%{coc#status()}%{get(b:,'coc_current_function','')}"
  " let coc = l:coc_status != '' ? '[Coc('.coc_status.')]' : ''
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'

  return '[%n] %f %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
  " return '[%n] %f %<'.mod.ro.ft.fug.coc.sep.pos.'%*'.pct
endfunction
" let &statusline = s:statusline_expr()
"hi StatusLine ctermfg=232 ctermbg=45 guibg=#00bff4 guifg=#000000
"hi StatusLineNC ctermfg=232 ctermbg=237 guibg=#777777 guifg=#000000

" let g:markdown_composer_autostart = 0

source $HOME/dotfiles/nvim/vim/sensible.vim
source $HOME/dotfiles/nvim/vim/objects.vim
source $HOME/dotfiles/nvim/vim/fzf.vim
" source $HOME/dotfiles/nvim/vim/coc.vim

" ----------------------------------------------------------------------------
"  Tabs
" ----------------------------------------------------------------------------
set list listchars=tab:¦\ ,trail:·,extends:»,precedes:«,nbsp:×

" ----------------------------------------------------------------------------
"  Surround
" ----------------------------------------------------------------------------
nmap s{ ysil{
nmap s} ySil{

" ----------------------------------------------------------------------------
" Readline-style key bindings in command-line (excerpt from rsi.vim)
" ----------------------------------------------------------------------------
cnoremap        <C-A> <Home>
cnoremap        <C-B> <Left>
cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
cnoremap        <M-b> <S-Left>
cnoremap        <M-f> <S-Right>
" silent! exe "set <S-Left>=\<Esc>b"
" silent! exe "set <S-Right>=\<Esc>f"

" ----------------------------------------------------------------------------
" Git
" ----------------------------------------------------------------------------
nmap <leader>gp :Git pull<CR>
nmap <leader>gP :Git push<CR>
nmap <leader>gs :Git<CR>gg)
nmap <leader>gd :Gdiff<CR>
nmap <leader>gb :Git blame<CR>
nmap <leader>gl :0Gclog!<CR>
nmap <leader>gw :Gwrite<CR>
nmap <leader>ge :Gedit<CR>
nmap <leader>gE :Gvsplit<CR>
nmap <leader>gv :GV -n 100<CR>
nmap <leader>gV :GV!<CR>
nmap <leader>gg :Ggrep 
nmap <leader>gg :Ggrep 
nmap <leader>gCt :execute "Git checkout --theirs ".expand('%:p')<CR>
nmap <leader>gCo :execute "Git checkout --ours ".expand('%:p')<CR>
nmap git :Git
nmap [r :Git rebase --abort<CR>
nmap ]r :Git rebase --continue<CR>
let g:Gitv_OpenHorizontal = 1
let g:Gitv_OpenPreviewOnLaunch = 1

nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" ----------------------------------------------------------------------------
"  GitGutter
" ----------------------------------------------------------------------------
" nmap <leader>gh :GitGutterLineHighlightsToggle<CR>

" ----------------------------------------------------------------------------
"  incsearch
" ----------------------------------------------------------------------------
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.rs,*.ts,*.tsx,*.jsx FormatWrite
augroup END

" ----------------------------------------------------------------------------
"  Easymotion
" ----------------------------------------------------------------------------
nmap <silent> gw :HopWord<CR>
nmap <silent> gs :HopChar2<CR>
nmap <silent> g<CR> :HopLineStart<CR>
" nmap gos <Plug>(easymotion-s)
" nmap <CR> <Plug>(easymotion-bd-jk)
" nmap gon <Plug>(easymotion-vim-n)
" nmap goN <Plug>(easymotion-vim-N)
" nmap <CR> <Plug>(easymotion-overwin-w)

" ----------------------------------------------------------------------------
" EasyAlign
" ----------------------------------------------------------------------------
vmap <Enter> <Plug>(EasyAlign)

" ----------------------------------------------------------------------------
" NERDTree
" ----------------------------------------------------------------------------
function! NERDTreeFindOrToggle()
  let s:empty = @% == "" || filereadable(@%) == 0 || line('$') == 1 && col('$') == 1
  if s:empty || exists("b:fugitive_type") || exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
    :NERDTreeToggle
  else
    :NERDTreeFind
  endif
endfunction
" map <silent> <leader>n :call NERDTreeFindOrToggle()<CR>
" map <silent> <leader>o :NERDTreeFind<CR>

function! NERDTreeFindUpdate()
  let s:path = expand("%:p")
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1 && s:path =~ getcwd() && !exists("b:fugitive_type") && s:path !~ ".git$"
    :NERDTreeFind
    exec "normal! \<c-w>p"
  endif
endfunction

" augroup nerd
"   autocmd!
"   autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
"   autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"   " autocmd FileType nerdtree unmap <buffer> mm
"   autocmd BufReadPost * call NERDTreeFindUpdate()
"   " autocmd VimEnter * silent! autocmd! FileExplorer
"   autocmd BufEnter,BufNew *
"         \  if isdirectory(expand('<amatch>'))
"         \|   call plug#load('nerdtree')
"         \|   execute 'autocmd! nerd'
"         \| endif
" augroup END

map <silent> <leader>o :NvimTreeFindFile<CR>
map <silent> <leader>n :NvimTreeFindFileToggle<CR>


" ----------------------------------------------------------------------------
" Easyclip
" ----------------------------------------------------------------------------
let g:yoinkIncludeDeleteOperations = 1
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)
xmap p <plug>(SubversiveSubstitute)
xmap P <plug>(SubversiveSubstitute)
xmap s <plug>(SubversiveSubstituteRangeConfirm)
nmap [y <plug>(YoinkRotateBack)
nmap ]y <plug>(YoinkRotateForward)
nmap ]p <plug>(YoinkPostPasteSwapBack)
nmap [p <plug>(YoinkPostPasteSwapForward)
nmap <leader>s <plug>(SubversiveSubstituteRange)
nmap <leader>s <plug>(SubversiveSubstituteRangeConfirm)
" let g:subversivePromptWithCurrent = 1


nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)

nnoremap m d
xnoremap m d

nnoremap mm dd
nnoremap M D

" ----------------------------------------------------------------------------
"   DelimitMate
" ----------------------------------------------------------------------------
let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1

" ----------------------------------------------------------------------------
" HL | Find out syntax group
" ----------------------------------------------------------------------------
function! s:hl()
  return map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction
command! HL echo join(<SID>hl(), '/')

" ----------------------------------------------------------------------------
"  vim-commentary
" ----------------------------------------------------------------------------
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine

" ----------------------------------------------------------------------------
"  Tmux
" ----------------------------------------------------------------------------
nmap <silent> @ :Tmux resize-pane -Z<CR>

" ----------------------------------------------------------------------------
" DiffRev
" ----------------------------------------------------------------------------
let s:git_status_dictionary = {
            \ "A": "Added",
            \ "B": "Broken",
            \ "C": "Copied",
            \ "D": "Deleted",
            \ "M": "Modified",
            \ "R": "Renamed",
            \ "T": "Changed",
            \ "U": "Unmerged",
            \ "X": "Unknown"
            \ }
function! s:get_diff_files(rev, reverse)
  let range = a:reverse ? 'HEAD...'.a:rev : a:rev.'...HEAD'
  let list = map(split(system(
              \ 'git diff --name-status '.range), '\n'),
              \ '{"filename":matchstr(v:val, "\\S\\+$"),"text":s:git_status_dictionary[matchstr(v:val, "^\\w")]}'
              \ )
  call setqflist(list)
  copen
endfunction

command! -nargs=1 -bang DiffRev call s:get_diff_files(<q-args>, <bang>0)

" ----------------------------------------------------------------------------
" gv.vim / gl.vim
" ----------------------------------------------------------------------------
function! s:gv_expand()
  let line = getline('.')
  GV --name-status
  call search('\V'.line, 'c')
  normal! zz
endfunction

" autocmd! FileType GV nnoremap <buffer> <silent> + :call <sid>gv_expand()<cr>

function! s:gl(buf, l1, l2)
  if !exists(':Gllog')
    return
  endif
  tab split
  silent! execute a:l1 == 1 && a:l2 == line('$') ? '' : "'<,'>" 'Gllog'
  call setloclist(0, insert(getloclist(0), {'bufnr': a:buf}, 0))
  b #
  lopen
  xnoremap <buffer> o :call <sid>gld()<cr>
  nnoremap <buffer> o <cr><c-w><c-w>
  nnoremap <buffer> q :tabclose<cr>
  call matchadd('Conceal', '^fugitive:///.\{-}\.git//')
  call matchadd('Conceal', '^fugitive:///.\{-}\.git//\x\{7}\zs.\{-}||')
  setlocal concealcursor=nv conceallevel=3 nowrap
endfunction

function! s:gld() range
  let [to, from] = map([a:firstline, a:lastline], 'split(getline(v:val), "|")[0]')
  execute 'tabedit' to
  execute 'vsplit' from
  windo diffthis
endfunction

command! -range=% GL call s:gl(bufnr(''), <line1>, <line2>)

" ----------------------------------------------------------------------------
" Yank Position
" ----------------------------------------------------------------------------
function! s:YankPosition()
  let @+=@%.'#L'.line('.')
  let @r=@%
  echo 'copied "'.@+.'"'
endfunction
nnoremap <silent> yp :call <sid>YankPosition()<CR>

function! s:PasteRelative()
  if executable("perl")
    " yes im using perl, shoot me
    return "'".system("perl -MFile::Spec -MFile::Basename -e 'print File::Spec->abs2rel(shift, dirname(shift))' ".@r." ".@%)."'"
  elseif
    " yes im using node, shoot me
    return "'".system("node -e \"(p => process.stdout.write(p.relative(p.dirname('".@%."'), '".@r."')))(require('path'))\"")."'"
  endif
  return "¯\\_(ツ)_/¯"
endfunction

nnoremap <silent> yP "=<sid>PasteRelative()<C-M>p

" ----------------------------------------------------------------------------
"  ¯\_(ツ)_/¯
" ----------------------------------------------------------------------------
function! Shrug()
  let hl = s:hl()
  if &filetype == 'markdown' && index(hl, 'markdownCode') == -1
    return "¯\\\\\\_(ツ)\\_/¯"
  endif
  return "¯\\_(ツ)_/¯"
endfunction
inoremap <silent> <c-\> <C-R>=Shrug()<CR>

" Replace
nmap coi :%s/import\(\_.\{-}\)from\s\(.\{-}\);/const\1= require(\2);/gc<CR>
nmap cor :%s/const\(\_.\{-}\)=\srequire(\(.\{-}\));/import\1from \2;/gc<CR>

let g:test#typescript#runner = 'jest'
let g:test#typescript#jest#executable = 'yarn test:unit'

let g:test#javascript#runner = 'jest'
let g:test#javascript#jest#executable = 'yarn test:unit'
