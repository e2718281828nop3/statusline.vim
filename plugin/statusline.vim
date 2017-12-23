scriptencoding utf-8

if exists('g:loaded_statusline')
  finish
endif
let g:loaded_statusline= 1

let s:save_cpo = &cpo
set cpo&vim

augroup set_statusline
    autocmd!
    autocmd VimEnter * call SetSTL()
    autocmd InsertEnter * call SetSTL('i')
    autocmd InsertLeave * call SetSTL('n')
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

