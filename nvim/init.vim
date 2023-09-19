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
set rtp+=~/dotfiles/nvim


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
Plug 'MunifTanjim/nui.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'windwp/nvim-ts-autotag'
Plug 'windwp/nvim-autopairs'
Plug 'kevinhwang91/nvim-bqf'
Plug 'ThePrimeagen/harpoon'
" Plug 'romgrk/nvim-treesitter-context'
" Plug 'mbbill/undotree'
" Plug 'preservim/nerdtree'
Plug 'kyazdani42/nvim-tree.lua'
" Plug 'nvim-neo-tree/neo-tree.nvim'
" Plug 's1n7ax/nvim-window-picker'
Plug 'haya14busa/incsearch.vim'
Plug 'svermeulen/vim-cutlass'
Plug 'svermeulen/vim-yoink'
Plug 'svermeulen/vim-subversive'
Plug 'vim-test/vim-test'
" Plug 'easymotion/vim-easymotion'
Plug 'phaazon/hop.nvim'
" Plug 'Raimondi/delimitMate'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/gv.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
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
Plug 'nvim-telescope/telescope-ui-select.nvim'
" Plug 'lstwn/broot.vim'
" Plug 'j-hui/fidget.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'rcarriga/nvim-notify'
Plug 'neovim/nvim-lspconfig'
" Plug 'ms-jpq/coq_nvim'
" Plug 'ray-x/lsp_signature.nvim'
Plug 'jose-elias-alvarez/typescript.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'folke/neodev.nvim'
Plug 'voldikss/vim-floaterm'
Plug 'folke/zen-mode.nvim'
Plug 'folke/twilight.nvim'
Plug 'andythigpen/nvim-coverage'
" Plug 'saadparwaiz1/cmp_luasnip'
" Plug 'nvim-lua/lsp-status.nvim'
" Plug 'L3MON4D3/LuaSnip'
" Plug 'simrat39/rust-tools.nvim'
" Plug 'mhartington/formatter.nvim'
" Language specific
" Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
" Plug 'othree/yajs.vim'
" Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'othree/html5.vim', { 'for': 'html' }
" Plug 'digitaltoad/vim-jade', { 'for': 'jade' }
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
Plug 'folke/tokyonight.nvim'
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
Plug 'nvim-telescope/telescope-symbols.nvim'
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
  " silent! colorscheme allomancer
  " silent! colorscheme hybrid
  silent! colorscheme tokyonight-moon
  "hi ColorColumn guibg=#111111
else
  let g:seoul256_background = 233
  silent! colorscheme seoul256
  hi MatchParen ctermfg=yellow
  "let g:indentLine_color_term = 248
  hi ColorColumn ctermbg=234 guibg=#111111
endif

lua << EOF
require('hop').setup()
require("zen-mode").setup({
  window = {
    width = 80
  }
})
require("twilight").setup{
  context = 4
}
require("coverage").setup({
  signs = {
    covered = { priority = 100 }, -- use a higher value than diagnostics or gitsigns
    uncovered = { priority = 100 },
  },
})
require("tokyonight").setup({})
require("notify").setup({
  top_down = false
})
require('trouble').setup()
require('nvim-autopairs').setup{}
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- require("fidget").setup{}
require('gitsigns').setup({
  on_attach = function(bufnr)
    if vim.api.nvim_buf_get_name(bufnr):match('fugitive') then
      -- Don't attach to specific buffers whose name matches a pattern
      return false
    end
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', gs.next_hunk)
    map('n', '[c', gs.prev_hunk)

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
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
-- require('formatter').setup({
--   filetype = {
--     javascript = prettier,
--     typescript = prettier,
--     typescriptreact = prettier,
--     python = {
--       -- Configuration for psf/black
--       function()
--         return {
--           exe = "black", -- this should be available on your $PATH
--           args = { '-' },
--           stdin = true,
--         }
--       end
--     }
--   }
-- })

-- require('nvim-tree').setup({
--   update_focused_file = {
--     enable = true,
--   },
--   renderer = {
--     icons = {
--       glyphs = {
--         git = {
--           unstaged = "M",
--           staged = "+",
--           untracked = "U",
--         }
--       }
--     }
--   }
-- })

require('nvim-treesitter.configs').setup({
  ensure_installed = "all",
  highlight = {
    enable = true,              -- false will disable the whole extension
  },

  indent = {
    enable = true,
  },

  textobjects = {
    enable = true
  },

  -- from windwp/nvim-ts-autotag
  autotag = {
    enable = true,
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
-- require('treesitter-context').setup {}
require('colorizer').setup {}

require('config.telescope')
if not vim.g.vscode then
  require('config.lsp')
end
require('config.statusline')
require("harpoon").setup({})
require("telescope").load_extension('harpoon')
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
inoremap <C-x><C-s> <cmd>lua require'telescope.builtin'.symbols(require('telescope.themes').get_cursor())<CR>

" ----------------------------------------------------------------------------
" Floaterm
" ----------------------------------------------------------------------------
" nmap ! :FloatermNew 
" tmap <silent> ]] <ESC>:FloatermNext<CR>
" tmap <silent> [[ <ESC>:FloatermPrev<CR>
" nmap <silent> <c-z> :FloatermToggle<CR>
" tmap <silent> <c-z> <ESC>:FloatermToggle<CR>

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
  " autocmd BufWritePost *.js,*.rs,*.ts,*.tsx,*.jsx FormatWrite
augroup END

" ----------------------------------------------------------------------------
"  Easymotion
" ----------------------------------------------------------------------------
nmap <silent> gw :HopWord<CR>
nmap <silent> gs :HopChar2<CR>
nmap <silent> g<CR> :HopLineStart<CR>
nmap <silent> g/ :HopPattern

" ----------------------------------------------------------------------------
" EasyAlign
" ----------------------------------------------------------------------------
vmap <Enter> <Plug>(EasyAlign)

" ----------------------------------------------------------------------------
" NvimTree
" ----------------------------------------------------------------------------
nnoremap <silent> <leader>n :NvimTreeFindFileToggle<CR>
nnoremap <silent> <leader>o :NvimTreeFindFile<CR>

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
  if executable("node")
    " yes im using node, shoot me
    return "'".system("node -e \"(p => process.stdout.write(p.relative(p.dirname('".@%."'), '".@r."')))(require('path'))\"")."'"
  endif
  return "¯\\_(ツ)_/¯"
endfunction

nnoremap <silent> yP "=<sid>PasteRelative()<C-M>p
nnoremap <silent> ycd :let @+ = expand("%")<CR>

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
