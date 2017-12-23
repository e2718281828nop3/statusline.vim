scriptencoding utf-8

if !exists('g:loaded_statusline')
    finish
endif
let g:loaded_statusline = 1

let s:save_cpo = &cpo
set cpo&vim

function! GitRepoName()
"    return system("basename `git rev-parse --show-toplevel 2> /dev/null` 2> /dev/null | tr -d '\n'")
    return ''
endfunction

function! GitBranchName()
    return system("git rev-parse --abbrev-ref HEAD 2> /dev/null | tr -d '\n'")
endfunction

function! GitRepo()
    return strlen(GitRepoName()) > 0 ? GitRepoName() : ''
endfunction

function! GitBranch()
    return strlen(GitRepoName()) > 0 ? GitBranchName().' ' : ''
endfunction

function! SetSTL_Init()
    setlocal statusline=
    setlocal statusline+=%#StlBase#
endfunction

function! SetSTL_ModeColor(...)
    let mode = get(a:, 1, mode())
    if mode == 'n'
        setlocal statusline+=%#StlBase#
    elseif mode == 'i'
        setlocal statusline+=%#STL_Insert#
    elseif mode == 'v'
        setlocal statusline+=%#STL_Visual#
    endif
endfunction

function! SetSTL_Mode(mode)
    let b:strmap = {
                \ 'n': '  normal ',
                \ 'i': '  insert ',
                \ 'v': '  visual ',
                \ 'V': '  visual ',
                \'^V': '  visual ',
                \}
    setlocal statusline+=%{get(b:strmap,mode(),'')}
endfunction

function! SetSTL_Git()
    setlocal statusline+=%#Git#
    setlocal statusline+=%{GitRepo()}
    if GitBranchName() == 'master'
        setlocal statusline+=%#GitMasterBranch#
    else
        setlocal statusline+=%#GitBranch#
    endif
    setlocal statusline+=%{GitBranch()}
    setlocal statusline+=%#StlBase#
endfunction

function! ResetColor()
    setlocal statusline+=%#StlBase#
endfunction

function! SetSTL_File()
    setlocal statusline+=%#Important#
    setlocal statusline+=%r%h%w
    setlocal statusline+=%#File#
    setlocal statusline+=\ 
    setlocal statusline+=%<%f%m
    setlocal statusline+=\ 
endfunction

function! SetSTL_Buffer()
    setlocal statusline+=b:%n\ 
endfunction

function! ALE_Status(key, ...)
    let word = get(a:, 1, '')
    let n = ale#statusline#Count(bufnr(''))[a:key]
    return n == 0 ? '' : ' ' . word . n . ' '
endfunction

function! SetSTL_ALE()
    setlocal statusline+=%#ALEError#
    setlocal statusline+=%{ALE_Status('error','E')}
    setlocal statusline+=%#ALEStyleError#
    setlocal statusline+=%{ALE_Status('style_error','Es')}
    setlocal statusline+=%#ALEWarning#
    setlocal statusline+=%{ALE_Status('warning','W')}
    setlocal statusline+=%#ALEStyleWarning#
    setlocal statusline+=%{ALE_Status('style_warning','Ws')}
    setlocal statusline+=%#StlBase#
endfunction

function! SetSTL_FileInfo()
  if &enc == &fenc
    setlocal statusline+=%{&fenc}
  else
    setlocal statusline+=%#Important#
    setlocal statusline+=\ enc\=%{&enc}\ fenc\=%{&fenc}\ 
    setlocal statusline+=%#StlBase#
  endif
  setlocal statusline+=\ %{&ff}\ 
endfunction

function! SetSTL(...)
    let mode = get(a:, 1, mode())

    "align left
    call SetSTL_Init()
    call SetSTL_ModeColor(mode)
    call SetSTL_Mode(mode)
    call ResetColor()
    call SetSTL_Git()
    call SetSTL_File()
    call SetSTL_Buffer()
    call SetSTL_ALE()

    "align right
    setlocal statusline+=%=
    call SetSTL_FileInfo()
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo

