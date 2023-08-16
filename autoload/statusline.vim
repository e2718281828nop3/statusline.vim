scriptencoding utf-8

if !exists('g:loaded_statusline')
    finish
endif

let g:loaded_statusline = 1

let s:save_cpo = &cpo
set cpo&vim

function! statusline#init()
    set  statusline& statusline+=%#StlBase#
endfunction

let g:statusline#strmap = {
            \ 'n': '  normal ',
            \ 'i': '  insert ',
            \ 'v': '  visual ',
            \ 'V': '  V_Line ',
            \"": '  VBlock ',
            \}

function! statusline#set_mode(...)
    hi STL_Mode ctermfg=238 ctermbg=230
    set stl+=%#STL_Mode#%{get(g:statusline#strmap,mode(),'')}%{statusline#hi_mode(mode())}
"    set stl+=%#STL_Mode#
"    set stl+=%{get(g:statusline#strmap,mode(),'')}
"    set stl+=%{statusline#hi_mode(mode())}
endfunction

function! statusline#hi_mode(mode)
    if a:mode ==# 'n'
        hi STL_Mode ctermfg=238 ctermbg=230
    elseif a:mode ==# 'i'
        hi STL_Mode ctermfg=white ctermbg=33
    elseif a:mode ==# 'v'
        hi STL_Mode ctermfg=white ctermbg=125
    elseif a:mode ==# 'V'
        hi STL_Mode ctermfg=white ctermbg=246
    elseif a:mode ==# ''
        hi STL_Mode ctermfg=white ctermbg=215
    endif
    return ''
endfunction

function! statusline#set_git_info()
    set statusline+=%#Git#

    let g:repository_name = system("basename `git rev-parse --show-toplevel 2> /dev/null` 2> /dev/null | tr -d '\n'")
    set statusline+=%{g:repository_name}
    if strlen(g:repository_name) > 0
      set statusline+=:
    endif

    let g:git_branch_name = system("git rev-parse --abbrev-ref HEAD 2> /dev/null | tr -d '\n'")
    if g:git_branch_name == 'master'
        set statusline+=%#GitMasterBranch#
    else
        set statusline+=%#GitBranch#
    endif
    set statusline+=%{g:git_branch_name}
endfunction

function! statusline#reset_color()
    set statusline+=%#StlBase#
endfunction

function! statusline#set_filename()
    set statusline+=%#Important#%r%h%w%#File#\ %<%f%m\ 
"    set statusline+=%#Important#
"    set statusline+=%r%h%w
"    set statusline+=%#File#
"    set statusline+=\ 
"    set statusline+=%<%f%m
"    set statusline+=\ 
endfunction

function! statusline#set_buffer()
    set statusline+=b:%n\ 
endfunction

function! statusline#ALE_status(key, ...)
    let word = get(a:, 1, '')
    let n = ale#statusline#Count(bufnr(''))[a:key]
    return n == 0 ? '' : ' '.word.n.' '
endfunction

function! statusline#set_ALE()
    set statusline+=%#ALEError#%{statusline#ALE_status('error','E')}
    set statusline+=%#ALEStyleError#%{statusline#ALE_status('style_error','Es')}
    set statusline+=%#ALEWarning#%{statusline#ALE_status('warning','W')}
    set statusline+=%#ALEStyleWarning#%{statusline#ALE_status('style_warning','Ws')}
    set statusline+=%#StlBase#
endfunction

function! statusline#set_file_info()
  if &enc == &fenc
    set statusline+=%{&fenc}
  else
    set statusline+=%#Important#\ enc\=%{&enc}\ fenc\=%{&fenc}\ %#StlBase#
  endif
  set statusline+=\ %{&ff}\ 
endfunction

function! statusline#set(...)
    "align left
    call statusline#init()
    call statusline#set_mode(mode())
    call statusline#reset_color()
    call statusline#set_git_info()
    call statusline#reset_color()
    call statusline#set_filename()
    call statusline#set_buffer()
    call statusline#set_ALE()

    "align right
    set statusline+=%=
    call statusline#set_file_info()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

