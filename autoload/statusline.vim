scriptencoding utf-8

if !exists('g:loaded_statusline')
    finish
endif

let g:loaded_statusline = 1

let s:save_cpo = &cpo
set cpo&vim

function! statusline#git_repo_name()
"    return system("basename `git rev-parse --show-toplevel 2> /dev/null` 2> /dev/null | tr -d '\n'")
    return ''
endfunction

function! statusline#git_branch_name()
    return system("git rev-parse --abbrev-ref HEAD 2> /dev/null | tr -d '\n'")
endfunction

function! statusline#git_repo()
    return strlen(statusline#git_repo_name()) > 0 ? statusline#git_repo_name() : ''
endfunction

function! statusline#git_branch()
    return strlen(statusline#git_repo_name()) > 0 ? statusline#git_branch_name().' ' : ''
endfunction

function! statusline#init()
    set statusline=
    set statusline+=%#StlBase#
endfunction

function! statusline#mode_color(...)
    let mode = mode()

    if mode == 'n'
        set statusline+=%#StlBase#
    elseif mode == 'i'
        set statusline+=%#STL_Insert#
    elseif mode == 'v'
        set statusline+=%#STL_Visual#
    endif
endfunction

function! statusline#mode()
    let g:statusline#strmap = {
                \ 'n': '  normal ',
                \ 'i': '  insert ',
                \ 'v': '  visual ',
                \ 'V': '  visual ',
                \'^V': '  visual ',
                \}
    set statusline+=%{get(g:statusline#strmap,mode(),'')}
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
    set statusline+=%#StlBase#
endfunction

function! statusline#reset_color()
    set statusline+=%#StlBase#
endfunction

function! statusline#file()
    setlocal statusline+=%#Important#
    setlocal statusline+=%r%h%w
    setlocal statusline+=%#File#
    setlocal statusline+=\ 
    setlocal statusline+=%<%f%m
    setlocal statusline+=\ 
endfunction

function! statusline#buffer()
    setlocal statusline+=b:%n\ 
endfunction

function! statusline#ALE_status(key, ...)
    let word = get(a:, 1, '')
    let n = ale#statusline#Count(bufnr(''))[a:key]
    return n == 0 ? '' : ' ' . word . n . ' '
endfunction

function! statusline#ALE()
    setlocal statusline+=%#ALEError#
    setlocal statusline+=%{statusline#ALE_status('error','E')}
    setlocal statusline+=%#ALEStyleError#
    setlocal statusline+=%{statusline#ALE_status('style_error','Es')}
    setlocal statusline+=%#ALEWarning#
    setlocal statusline+=%{statusline#ALE_status('warning','W')}
    setlocal statusline+=%#ALEStyleWarning#
    setlocal statusline+=%{statusline#ALE_status('style_warning','Ws')}
    setlocal statusline+=%#StlBase#
endfunction

function! statusline#file_info()
  if &enc == &fenc
    setlocal statusline+=%{&fenc}
  else
    setlocal statusline+=%#Important#
    setlocal statusline+=\ enc\=%{&enc}\ fenc\=%{&fenc}\ 
    setlocal statusline+=%#StlBase#
  endif
  setlocal statusline+=\ %{&ff}\ 
endfunction

function! statusline#set(...)
    let mode = get(a:, 1, mode())

    "align left
    call statusline#init()
    call statusline#mode_color()
    call statusline#mode()
    call statusline#reset_color()
    call statusline#git()
    call statusline#file()
    call statusline#buffer()
    call statusline#ALE()

    "align right
    setlocal statusline+=%=
    call statusline#file_info()
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo

