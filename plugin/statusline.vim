scriptencoding utf-8

if exists('g:loaded_statusline')
  finish
endif
let g:loaded_statusline= 1

let s:save_cpo = &cpo
set cpo&vim

augroup set_statusline
    autocmd!
    autocmd VimEnter * call statusline#set()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

