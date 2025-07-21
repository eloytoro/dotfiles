" ----------------------------------------------------------------------------
" HL | Find out syntax group
" ----------------------------------------------------------------------------
function! s:hl()
  return map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction
command! HL echo join(<SID>hl(), '/')

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
