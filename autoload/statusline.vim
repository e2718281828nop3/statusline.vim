scriptencoding utf-8

if !exists('g:loaded_statusline')
    finish
endif

let g:loaded_statusline = 1

let s:save_cpo = &cpo
set cpo&vim

function! statusline#git_repo_name()
    silent return system("basename `git rev-parse --show-toplevel 2> /dev/null` 2> /dev/null | tr -d '\n'")
endfunction

function! statusline#git_branch_name()
    silent return system("git rev-parse --abbrev-ref HEAD 2> /dev/null | tr -d '\n'")
endfunction

function! statusline#git_repo()
    return strlen(statusline#git_repo_name()) > 0 ? statusline#git_repo_name() : ''
endfunction

function! statusline#git_branch()
    return strlen(statusline#git_branch_name()) > 0 ? '  '.statusline#git_branch_name().' ' : ''
endfunction

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
    set stl+=%#STL_Mode#
    set stl+=%{get(g:statusline#strmap,mode(),'')}
    set stl+=%{statusline#hi_mode(mode())}
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

function! statusline#git()
    set statusline+=%#Git#
    set statusline+=%{statusline#git_repo()}
    if statusline#git_branch_name() == 'master'
        set statusline+=%#GitMasterBranch#
    else
        set statusline+=%#GitBranch#
    endif
    set statusline+=%{statusline#git_branch()}
endfunction

function! statusline#reset_color()
    set statusline+=%#StlBase#
endfunction

function! statusline#file()
    set statusline+=%#Important#
    set statusline+=%r%h%w
    set statusline+=%#File#
    set statusline+=\ 
    set statusline+=%<%f%m
    set statusline+=\ 
endfunction

function! statusline#buffer()
    set statusline+=b:%n\ 
endfunction

function! statusline#ALE_status(key, ...)
    let word = get(a:, 1, '')
    let n = ale#statusline#Count(bufnr(''))[a:key]
    return n == 0 ? '' : ' '.word.n.' '
endfunction

function! statusline#ALE()
    set statusline+=%#ALEError#
    set statusline+=%{statusline#ALE_status('error','E')}
    set statusline+=%#ALEStyleError#
    set statusline+=%{statusline#ALE_status('style_error','Es')}
    set statusline+=%#ALEWarning#
    set statusline+=%{statusline#ALE_status('warning','W')}
    set statusline+=%#ALEStyleWarning#
    set statusline+=%{statusline#ALE_status('style_warning','Ws')}
    set statusline+=%#StlBase#
endfunction

function! statusline#file_info()
  if &enc == &fenc
    set statusline+=%{&fenc}
  else
    set statusline+=%#Important#
    set statusline+=\ enc\=%{&enc}\ fenc\=%{&fenc}\ 
    set statusline+=%#StlBase#
  endif
  set statusline+=\ %{&ff}\ 
endfunction

function! statusline#set(...)
    "align left
    call statusline#init()
    call statusline#set_mode(mode())
    call statusline#reset_color()
    call statusline#git()
    call statusline#reset_color()
    call statusline#file()
    call statusline#buffer()
    call statusline#ALE()

    "align right
    set statusline+=%=
    call statusline#file_info()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

