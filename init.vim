filetype off
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !mkdir -p ~/.config/nvim/autoload
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plug')

" Essential
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-dispatch'
Plug 'floobits/floobits-neovim'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/vim-easy-align'
Plug 'svermeulen/vim-easyclip'
Plug 'bling/vim-airline'
Plug 'justinmk/vim-sneak'
Plug 'Lokaltog/vim-easymotion'
Plug 'Yggdroot/indentLine'
Plug 'Raimondi/delimitMate'
Plug 'SirVer/ultisnips'
Plug 'eloytoro/vim-istanbul', { 'on': 'IstanbulShow' }
Plug 'PeterRincker/vim-argumentative'
" Plug 'kien/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'euclio/vim-markdown-composer', { 'do': 'cargo build --release' }
" Optional
"Plug 'scrooloose/nerdcommenter'
"Plug 'kshenoy/vim-signature'
Plug 'benekastah/neomake'
"Plug 'ervandew/supertab'
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'Shougo/deoplete.nvim'
"Plug 'Shougo/echodoc.vim'
" Language specific
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'ternjs/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }
Plug 'heavenshell/vim-jsdoc', { 'for': 'javascript' }
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'raichoo/haskell-vim', { 'for': 'haskell' }
Plug 'digitaltoad/vim-jade', { 'for': 'jade' }
Plug 'mxw/vim-jsx'
" Colorschemes
Plug 'eloytoro/jellybeans.vim'
Plug 'eloytoro/xoria256'
Plug 'junegunn/seoul256.vim'
Plug 'tomasr/molokai'

call plug#end()

" ----------------------------------------------------------------------------
" Colorschemes
" ----------------------------------------------------------------------------
syntax enable
if $NVIM_TUI_ENABLE_TRUE_COLOR
    let g:indentLine_color_gui = '#252525'
    silent! colorscheme molokai
    hi StatusLine   guifg=#000000 guibg=#FFFFFF
    hi StatusLineNC guifg=#000000 guibg=#333333
    if opacity =~ '0.'
        au VimEnter * hi Normal guibg=none          |
                    \ hi NonText guibg=none         |
                    \ hi LineNr guibg=none          |
                    \ hi CursorLineNr guibg=none    |
                    \ hi ColorColumn guibg=none     |
                    \ hi CursorLine guibg=none      |
                    \ hi GitGutterAdd guibg=none    |
                    \ hi GitGutterChange guibg=none |
                    \ hi GitGutterDelete guibg=none
    endif
    if has("gui_running")
        set guioptions=agim
        set guicursor+=a:blinkon0
        if has("mac")
            set guifont=Inconsolata:h14
        else
            set guifont=Inconsolata\ 11
        endif
    endif
else
    let g:seoul256_background = 233
    silent! colorscheme seoul256
    hi MatchParen ctermfg=yellow
    let g:indentLine_color_term = 234
    "let g:indentLine_color_term = 248
    hi ColorColumn ctermbg=234 guibg=#252525
endif

" ----------------------------------------------------------------------------
" Basic
" ----------------------------------------------------------------------------
set backspace=2
set nu
set rnu
set showcmd
set ruler
set showmatch
set scrolloff=2
set wrap
set linebreak
set breakat-=*
set incsearch
set wildmenu
let g:html_indent_inctags = "html,body,head,tbody"
let mapleader = ' '
let maplocalleader = ' '
set shiftwidth=4
set tabstop=4
set autoread
set nosol
set noshowmode
set nolist
set expandtab smarttab
set virtualedit=block
set backupdir=~/.config/nvim/backup
set directory=~/.config/nvim/backup
set laststatus=2
set pastetoggle=<F7>
set splitbelow
if has('patch-7.4.338')
    set showbreak=↳\ 
    set breakindent
    set breakindentopt=sbr
endif
set encoding=utf-8
set visualbell
set colorcolumn=80
set formatoptions+=rojn
set diffopt=filler,vertical
set nohlsearch
set mouse=""
function! S_modified()
    if &modified
        return ' [+] '
    endif
    return ''
endfunction
set statusline=%f\ %y\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}%{S_modified()}%=%-14.(%l/%L,%c%V%)
hi StatusLine ctermfg=232 ctermbg=45
hi StatusLineNC ctermfg=232 ctermbg=237

let g:markdown_composer_autostart = 0

" ----------------------------------------------------------------------------
" Fix Indent
" ----------------------------------------------------------------------------
au BufReadPost *.ts set filetype=javascript
au BufReadPost *.rkt,*.rktl set filetype=scheme
au filetype racket set lisp
au filetype racket set autoindent
filetype plugin indent on
autocmd BufNewFile,BufRead *.blade.php set ft=html | set ft=phtml | set ft=blade " Fix blade auto-indent
autocmd BufReadPost quickfix nmap <buffer> <CR> :.cc<CR>

" ----------------------------------------------------------------------------
"  Tabs
" ----------------------------------------------------------------------------
set list listchars=tab:¦\ ,trail:·,extends:»,precedes:«,nbsp:×

" ----------------------------------------------------------------------------
" Maps
" ----------------------------------------------------------------------------
map <F2> :source ~/.config/nvim/init.vim<CR>
" For inserting new lines
nmap - o<Esc>
nmap _ O<Esc>
nmap ! :10sp \| term 
" Lazy macro creation
nnoremap Q @q
nmap <leader>q :cope<CR>
" <tab> for tab switcing
nnoremap <Tab> gt
nnoremap <S-Tab> gT
" cd changes directory to the current file's
nmap cd :cd %:p:h<CR>
" Retain cursor position on page scrolling
noremap <C-F> <C-D>
noremap <C-B> <C-U>
" change L and H to ^ and $
onoremap H ^
onoremap L $
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $
nnoremap <silent> ]b :bn<CR>
nnoremap <silent> [b :bp<CR>
nnoremap <silent> ]q :cn<CR>
nnoremap <silent> [q :cp<CR>
nnoremap <silent> <C-t> :tabnew<cr>
inoremap <C-s> <C-O>:update<cr>
nnoremap <C-s> :update<cr>
inoremap <C-q> <esc>:q<cr>
nnoremap <C-q> :q<cr>

" ----------------------------------------------------------------------------
"   Moving lines | for quick line swapping purposes
" ----------------------------------------------------------------------------
nnoremap <silent> <C-k> :move-2<cr>
nnoremap <silent> <C-j> :move+<cr>
nnoremap <silent> <C-h> <<
nnoremap <silent> <C-l> >>
xnoremap <silent> <C-k> :move-2<cr>gv
xnoremap <silent> <C-j> :move'>+<cr>gv
vnoremap <silent> <C-l> >gv
vnoremap <silent> <C-h> <gv
vnoremap < <gv
vnoremap > >gv

" ----------------------------------------------------------------------------
" Window Controls | much like hjkl but using the g prefix
" ----------------------------------------------------------------------------
nmap gh <C-w>h
nmap gj <C-w>j
nmap gk <C-w>k
nmap gl <C-w>l
nmap <down> :res -2<CR>
nmap <up> :res +2<CR>
nmap <right> 2<C-W>>
nmap <left> 2<C-W><
nmap <C-w>- :sp<CR>
nmap <C-w>\ :vsp<CR>

" ----------------------------------------------------------------------------
"  Neovim
" ----------------------------------------------------------------------------
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    nmap <leader>t :tabnew\|te<CR>
    set ttimeout
    set ttimeoutlen=0
else
    set nocompatible
endif

" ----------------------------------------------------------------------------
"  Surround
" ----------------------------------------------------------------------------
nmap s{ ysil{
nmap s} ySil{

" ----------------------------------------------------------------------------
"  Sneak
" ----------------------------------------------------------------------------
nmap gf  <Plug>Sneak_s
omap gf  <Plug>Sneak_s
nmap gb <Plug>Sneak_S
omap gb <Plug>Sneak_S
hi SneakPluginTarget ctermbg=yellow ctermfg=black

" ----------------------------------------------------------------------------
"  Easymotion
" ----------------------------------------------------------------------------
nmap / <Plug>(easymotion-sn)
nmap n <Plug>(easymotion-next)
nmap N <Plug>(easymotion-prev)
nmap <CR> <Plug>(easymotion-bd-jk)
omap <CR> <Plug>(easymotion-bd-jk)
nmap gw <Plug>(easymotion-bd-w)
omap gw <Plug>(easymotion-bd-w)
nmap gW <Plug>(easymotion-bd-W)
omap gW <Plug>(easymotion-bd-W)
hi EasyMotionMoveHL ctermbg=yellow ctermfg=black
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_off_screen_search = 1
let g:EasyMotion_smartcase = 1

" ----------------------------------------------------------------------------
" Git
" ----------------------------------------------------------------------------
nmap <leader>gi :Git 
nmap <leader>gs :Gstatus<CR>gg<c-n>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gb :Gblame<CR>
nmap <leader>gl :Glog<CR>
nmap <leader>gw :Gwrite<CR>
nmap <leader>ge :Gedit<CR>
nmap <leader>gE :Gvsplit<CR>
nmap <leader>gv :Gitv<CR>
nmap <leader>gV :Gitv!<CR>
nmap <leader>gg :Ggrep 
nmap [m :Git merge --abort<CR>
nmap [r :Git rebase --abort<CR>
nmap ]r :Git rebase --continue<CR>
fu GitvRebaseHere()
    let l = getline(line('.'))
    let sha = matchstr(l, "\\[\\zs[0-9a-f]\\{7}\\ze\\]$")
    execute "Git rebase -i ".sha."^"
endf
au FileType gitv nmap <leader>gr :call GitvRebaseHere()<CR>
let g:Gitv_OpenHorizontal = 1
let g:Gitv_OpenPreviewOnLaunch = 1

" ----------------------------------------------------------------------------
"  GitGutter
" ----------------------------------------------------------------------------
nmap <leader>gh :GitGutterLineHighlightsToggle<CR>
nmap <leader>gp <Plug>GitGutterPreviewHunk
nmap <leader>ga <Plug>GitGutterStageHunk
nmap <leader>gr <Plug>GitGutterRevertHunk

" ----------------------------------------------------------------------------
" EasyAlign
" ----------------------------------------------------------------------------
vmap <Enter> <Plug>(EasyAlign)

" ----------------------------------------------------------------------------
" Explorer
" ----------------------------------------------------------------------------
map <Leader>n :NERDTreeToggle<CR>
au FileType * if &ft=="nerdtree" | silent! nunmap <buffer> mm | endif

" ----------------------------------------------------------------------------
" Airline
" ----------------------------------------------------------------------------
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_detect_whitespace = 0

" ----------------------------------------------------------------------------
" Easyclip
" ----------------------------------------------------------------------------
let g:EasyClipUseSubstituteDefaults = 1
let g:EasyClipPreserveCursorPositionAfterYank = 1
let g:EasyClipAutoFormat = 1
let g:EasyClipShareYanks = 1
let g:EasyClipUserPasteToggleDefaults = 0
let g:EasyClipUsePasteToggleDefaults = 0
nmap [y <Plug>EasyClipSwapPasteBackwards
nmap ]y <Plug>EasyClipSwapPasteForward
imap <c-v> <Plug>EasyClipInsertModePaste
nmap M mL

" ----------------------------------------------------------------------------
" Signature
" ----------------------------------------------------------------------------
let g:SignatureMap = { 'Leader' :  "$" }
let g:SignatureMarkOrder = "»\m"

" ----------------------------------------------------------------------------
" IndentLine
" ----------------------------------------------------------------------------
let g:indentLine_char = '¦'
let g:indentLine_faster = 1

" ----------------------------------------------------------------------------
"  CtrlP
" ----------------------------------------------------------------------------
set wildignore+=*/tmp/*,*.so,*.sw?,*.zip,*/vendor/*,*/bower_components/*,*/node_modules/*,*/dist/*
"let g:ctrlp_match_window_bottom = 0
let g:ctrlp_mru_files = 1
let g:ctrlp_extensions = ['merge', 'checkout']
let g:ctrlp_funky_syntax_highlight = 1
let g:ctrlp_working_path_mode = 'ra'

" ----------------------------------------------------------------------------
"  FZF
" ----------------------------------------------------------------------------
if has('nvim')
    let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> ?     :Ag 

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

set rtp+=~/.fzf

function! s:merge_handler(line)
    exec "Git merge --no-ff --no-commit ".a:line
endfunction

command! FZFMerge call fzf#run({
            \ 'source': 'git branch -r --no-merged',
            \ 'sink': function('s:merge_handler'),
            \ 'down': 8})

nmap <silent> <leader>gm :FZFMerge<CR>

function! s:get_log_ref(line)
    let refs = split(matchstr(a:line, '\c(\zs[0-9A-Z\/,\ -]\+\ze)'), '\s*,\s*')
    if len(refs) >= 1
        return substitute(filter(refs, 'match(v:val, "\\(HEAD\\)")')[0], 'origin\/', '', '')
    else
        return matchstr(a:line, '[0-9a-f]\{7}')
    endif
endfunction

function! s:checkout_handler(line)
    exec "!git checkout ".s:get_log_ref(a:line)
endfunction

function! s:diff_handler(line)
    exec "Gdiff ".s:get_log_ref(a:line)
endfunction

function! s:fzf_show_commits(file, single, handler)
    let options  = [
                \ '--color=always',
                \ '--all',
                \ '--format="%C(auto)%h%d %s %C(black)%C(bold)%an, %cr"']
    if a:single
        if (empty(a:file))
            let file = expand("%:P")
        else
            let file = a:file
        endif
        call add(options, '--follow -- '.file)
    else
        call add(options, '--graph')
    endif

    call fzf#run({
                \ 'source': 'git log '.join(options, ' '),
                \ 'sink': a:handler,
                \ 'options': '--ansi --multi --no-sort --tiebreak=index --reverse '.
                \   '--inline-info --prompt "Checkout> " --bind=ctrl-s:toggle-sort',
                \ 'left': '50%'})
endfunction

command! -bang -nargs=? FZFCheckout call s:fzf_show_commits(<q-args>, <bang>0, function('s:checkout_handler'))
command! -nargs=? FZFDiff call s:fzf_show_commits(<q-args>, 1, function('s:diff_handler'))

nmap <silent> <leader>gc :FZFCheckout<CR>
nmap <silent> <leader>gC :FZFCheckout!<CR>
nmap <silent> <leader>gD :FZFDiff<CR>

" ----------------------------------------------------------------------------
"   DelimitMate
" ----------------------------------------------------------------------------
let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1
au FileType javascript let b:delimitMate_insert_eol_marker = 1
au FileType javascript let b:delimitMate_eol_marker = ";"

" ----------------------------------------------------------------------------
"  vim-commentary
" ----------------------------------------------------------------------------
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine

" ----------------------------------------------------------------------------
"  JSDoc
" ----------------------------------------------------------------------------
nmap doc <Plug>(jsdoc)
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_return = 0

" ----------------------------------------------------------------------------
"  Neomake
" ----------------------------------------------------------------------------
let g:neomake_javascript_enabled_makers = ['eslint']

au! BufWritePost * Neomake
let g:neomake_open_list = 2

" ----------------------------------------------------------------------------
"  UltiSnips
" ----------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger = "<nop>"
let g:UltiSnipsSnippetsDir = "~/.config/nvim/UltiSnips"
let g:ulti_expand_or_jump_res = 0

" ----------------------------------------------------------------------------
"  Tmux / Dispatch
" ----------------------------------------------------------------------------
autocmd FileType javascript let b:dispatch = 'mocha %'
nmap <silent> @ :Tmux resize-pane -Z<CR>

" ----------------------------------------------------------------------------
"  Deoplete
" ----------------------------------------------------------------------------
let g:deoplete#enable_at_startup = 1
set completeopt=menuone,noinsert,noselect

function ExpandSnippetOrCarriageReturn()
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return snippet
    else
        " if pumvisible()
        "     return deoplete#mappings#close_popup()
        " endif
        return delimitMate#ExpandReturn()
    endif
endfunction
inoremap <silent> <CR> <C-R>=ExpandSnippetOrCarriageReturn()<CR>

let g:jsx_ext_required = 0

" <TAB>: completion.
imap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

" <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> deolete#mappings#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"

inoremap <expr><C-g> deoplete#mappings#undo_completion()
" <C-l>: redraw candidates
inoremap <C-l>       a<BS>

let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns._ = '[a-zA-Z_]\k*\(?'

" inoremap <silent><expr> <C-t> deoplete#mappings#manual_complete('file')

let g:deoplete#enable_refresh_always = 1
let g:deoplete#enable_camel_case = 1


" ----------------------------------------------------------------------------
" co? : Toggle options (inspired by unimpaired.vim)
" ----------------------------------------------------------------------------
function! s:map_change_option(...)
    let [key, opt] = a:000[0:1]
    let op = get(a:, 3, 'set '.opt.'!')
    execute printf("nnoremap co%s :%s<bar>echo '%s: '. &%s<cr>",
                \ key, op, opt, opt)
endfunction

call s:map_change_option('p', 'paste')
call s:map_change_option('n', 'number')
call s:map_change_option('w', 'wrap')
call s:map_change_option('h', 'hlsearch')
call s:map_change_option('m', 'mouse', 'let &mouse = &mouse == "" ? "a" : ""')
call s:map_change_option('t', 'textwidth',
            \ 'let &textwidth = input("textwidth (". &textwidth ."): ")<bar>redraw')
call s:map_change_option('b', 'background',
            \ 'let &background = &background == "dark" ? "light" : "dark"<bar>redraw')
nnoremap cogg :GitGutterLineHighlightsToggle<CR>

" ----------------------------------------------------------------------------
" <Leader>? | Google it
" ----------------------------------------------------------------------------
function! s:goog(pat)
    let q = '"'.substitute(a:pat, '["\n]', ' ', 'g').'"'
    let q = substitute(q, '[[:punct:] ]',
                \ '\=printf("%%%02X", char2nr(submatch(0)))', 'g')
    call system('google-chrome https://www.google.co.kr/search?q='.q)
endfunction

nnoremap <leader>? :call <SID>goog(getline("."))<cr>
xnoremap <leader>? "gy:call <SID>goog(@g)<cr>gv

" ----------------------------------------------------------------------------
" :Root | Change directory to the root of the Git repository
" ----------------------------------------------------------------------------
function! s:root()
    let root = systemlist('git rev-parse --show-toplevel')[0]
    if !v:shell_error
        execute 'lcd' root
        echo 'Changed directory to: '.root
    endif
endfunction
" au VimEnter * call s:root()
