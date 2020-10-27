" ----------------------------------------------------------------------------
"  FZF
" ----------------------------------------------------------------------------
if has('nvim')
    " let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

function! CTRLP()
  let target = expand("%:h")
  if (target == '')
    let target = '.'
  endif
  let root = systemlist('git -C '.target.' rev-parse --show-toplevel')[0]
  if v:shell_error
    let root = $PWD
  endif
  if expand('%') =~ 'NERD_tree'
    exec "normal! \<c-w>w"
  endif
  if executable("fd")
    call fzf#vim#files('', {
          \ 'source': 'fdup '.root.' '.target,
          \ 'options': '--no-sort'
          \ })
  else
    Files
  endif
endfunction
command! CTRLP call CTRLP()
nnoremap <silent> <C-p> :CTRLP<CR>
nnoremap <leader>/ :Ag 
function! AgOn(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@

  if a:0  " Invoked from Visual mode, use gv command.
    silent exe "normal! gvy"
  elseif a:type == 'line'
    silent exe "normal! '[V']y"
  else
    silent exe "normal! `[v`]y"
  endif

  exec "Ag ".@@

  let &selection = sel_save
  let @@ = reg_save
endfunction
nmap <silent> y/ :set opfunc=AgOn<CR>g@
vmap <silent> /  :<C-U>call AgOn(visualmode(), 1)<CR>

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

set rtp+=~/.fzf

function! s:merge_handler(line)
    exec "Git merge --no-ff -q".a:line
endfunction

command! FZFMerge call fzf#run({
            \ 'source': 'git branch -r --no-merged',
            \ 'sink': function('s:merge_handler'),
            \ 'down': 8})

function! s:dir_handler(dir)
    echo a:dir
endfunction

function! s:get_log_ref(line)
    return matchstr(a:line, '[0-9a-f]\{7}')
endfunction

function! s:branch_handler(line)
    exec "!git checkout ".a:line
endfunction

function! s:ref_handler(line)
    exec "Gtabedit! show ".s:get_log_ref(a:line)
endfunction

function! s:fzf_show_commits(here, handler)
    let options  = [
                \ '--color=always',
                \ '--format="%C(auto)%h%d %s %C(magenta)%an, %cr"',
                \ '--skip 1'
                \ ]

    if a:here
      call add(options, '--follow -- '.expand("%:P"))
    endif

    call fzf#run({
                \ 'source': 'git log '.join(options, ' '),
                \ 'sink': a:handler,
                \ 'options': '--ansi --multi --no-sort --tiebreak=index '.
                \   '--inline-info -e --prompt "Commit> " --bind=ctrl-s:toggle-sort',
                \ 'down': 8})
endfunction

function! s:fzf_show_branches(handler)
  call fzf#run({
        \ 'source': 'git branch --sort=-committerdate -a --format="%(refname:lstrip=2)" | sed "s/^origin\///" | awk '."'!seen[$0]++\'",
        \ 'sink': a:handler,
        \ 'options': '--ansi --multi --no-sort --tiebreak=index --reverse '.
        \   '--inline-info -e --prompt "Ref> " --bind=ctrl-s:toggle-sort',
        \ 'left': '50'})
endfunction

command! -nargs=0 FZFCheckout call s:fzf_show_branches(function('s:branch_handler'))
command! -nargs=0 FZFGitLog call s:fzf_show_commits(1, function('s:ref_handler'))
nmap <silent> <leader>gc :FZFCheckout<CR>
nmap <silent> <leader>gl :FZFGitLog<CR>
nmap <silent> <leader>gm :FZFMerge<CR>
nmap <silent> ycl :.GBrowse!<CR>
nmap <silent> ycf :GBrowse!<CR>

function! s:get_changes_list()
  redir => result
  :silent changes
  redir END
  return reverse(split(result, "\n")[1:])[1:]
endfunction

function! s:fzf_handle_change(line)
  let elements = matchlist(a:line, '\v^(.)\s*(\d+)\s+(\d+)\s+(\d+)\s*(.*)$')
  if empty(elements)
    return {}
  endif
  let parsed = {
        \   'prefix': elements[1],
        \   'count' : elements[2],
        \   'lnum'  : elements[3],
        \   'column': elements[4],
        \   'text'  : elements[5],
        \ }
  call cursor(parsed.lnum, parsed.column)
endfunction

command! -nargs=0 FZFChanges call fzf#run({
      \ 'source': s:get_changes_list(),
      \ 'sink': function('s:fzf_handle_change'),
      \ 'down': 8,
      \ })

nmap <silent> <leader>g; :FZFChanges<CR>

let g:fzf_files_options = '-e --preview "bat --color=always -p {} 2> /dev/null"'
" let g:fzf_preview_window = 'right:80%'
let g:fzf_buffers_jump = 1

