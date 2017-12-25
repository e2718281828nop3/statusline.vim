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
    return strlen(statusline#git_branch_name()) > 0 ? ' '.statusline#git_branch_name().' ' : ''
"    return strlen(statusline#git_repo_name()) > 0 ? statusline#git_branch_name().' ' : ''
endfunction

function! statusline#init()
    set statusline=
    set statusline+=%#StlBase#
endfunction

function! statusline#mode_color(...)
    let mode = get(a:, 1, mode())

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
    return n == 0 ? '' : ' ' . word . n . ' '
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
    let mode = get(a:, 1, mode())

    "align left
    call statusline#init()
    call statusline#mode_color(mode)
    call statusline#mode()
    call statusline#reset_color()
    call statusline#git()
    call statusline#file()
    call statusline#buffer()
    call statusline#ALE()

    "align right
    set statusline+=%=
    call statusline#file_info()
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo

