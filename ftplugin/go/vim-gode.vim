"
" Vim Go Development Environment
"
" Copyright (c) 2014-2017, Frank Mueller / Oldenburg / Germany
"
if exists("b:vim_gode_loaded")
    finish
endif

let b:vim_gode_loaded = 1
let s:save_cpo = &cpo

set cpo&vim
set formatoptions-=t
set comments=s1:/*,mb:*,ex:*/,://
set commentstring=//\ %s
set noexpandtab
set tabstop=4
set shiftwidth=4
set noexpandtab
set autoread
let g:ctrlp_buftag_types = {'go' : '--language-force=go --golang-types=ft'}

set errorformat=%-G#\ %.%#
set errorformat+=%-G%.%#panic:\ %m
set errorformat+=%Ecan\'t\ load\ package:\ %m
set errorformat+=%A%f:%l:%c:\ %m
set errorformat+=%A%f:%l:\ %m
set errorformat+=%C%*\\s%m

autocmd! BufWritePost *.go !gofmt -w %

compiler go
"
" Functions
"
function! s:quickfix(height)
    if a:height > 0
        execute "copen " . a:height
    endif
endfunction

function! s:GoPath()
    let dirs = []
    if executable('go')
        let goroot = substitute(system('go env GOROOT'), '\n', '', 'g')
        if v:shell_error
            echomsg 'error: execution of "go env GOROOT" failed'
        endif
    else
        let goroot = $GOROOT
    endif
    if len(goroot) != 0 && isdirectory(goroot)
        let dirs += [goroot]
    endif
    let workspaces = split($GOPATH, ':')
    if workspaces != []
        let dirs += workspaces
    endif
    return dirs
endfunction

function! g:GoPackage()
    let path = fnamemodify(resolve(@%), ':p:h')
    let dirs = s:GoPath()
    for dir in dirs
        if len(dir) && match(path, dir) == 0
            let workspace = dir
        endif
    endfor
    if !exists('workspace')
        return -1
    endif
    let workspace = substitute(workspace, '/$', '', '')
    let pkg = substitute(path, workspace . '/src/', '', '')
    echo "Package: " . pkg
    return pkg
endfunction

function! g:GoCommand(command, errsize, oksize)
    let cwd = getcwd()
    let pd = fnamemodify(resolve(@%), ':p:h')
    cd `=pd`
    cexpr system("go " . a:command)
    if v:shell_error
        call s:quickfix(a:errsize)
    else
        call s:quickfix(a:oksize)
    endif
    cd `=cwd`
endfunction

function! g:GoTestFunc()
    let line = search("func Test[A-Z][a-zA-Z0-9]*", "b")
    normal w
    let fname = expand("<cword>")
    let command = "test -test.run " . fname
    call g:GoCommand(command, 15, 15)
endfunction

function! g:GoBenchmarkFunc()
    let line = search("func Benchmark[A-Z][a-zA-Z0-9]*", "b")
    normal w
    let fname = expand("<cword>")
    let command = "test -bench " . fname
    call g:GoCommand(command, 15, 5)
endfunction

function! g:GoTestCoverage()
    cexpr system("go test -coverprofile=coverage.out && go tool cover -func=coverage.out")
    call s:quickfix(15)
endfunction

function! g:GoFmt()
    cexpr system("go fmt " . shellescape(expand('%')))
    bufdo e!
    if v:shell_error
        call s:quickfix(15)
    endif
endfunction

function! g:GoLint()
    cexpr system("golint " . shellescape(expand('%')))
    if v:shell_error
        call s:quickfix(15)
    endif
endfunction

function! g:GoDoc()
    let currentiskeyword = &iskeyword
    setlocal iskeyword+=.
    let symbol = expand("<cword>")
    let &iskeyword = currentiskeyword
    let command = "doc -u " . symbol
    call g:GoCommand(command, 5, 15)
endfunction

function! g:GoGrep()
    execute "vimgrep /" . expand("<cWORD>") . "/j **/*.go"
    execute "cw"
endfunction
"
" Tags.
"
function! s:SetTagbar()
    let g:tagbar_type_go = {
        \ 'ctagstype' : 'go',
        \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'r:constructor',
        \ 'm:methods',
        \ 'f:functions'
        \ ],
        \ 'sro' : '.',
        \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
        \ },
        \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
        \ },
        \ 'ctagsbin'  : 'gotags',
        \ 'ctagsargs' : '-sort -silent'
        \ }
endfunction

call s:SetTagbar()
"
" Commands.
"
command! GoBenchmark     :call g:GoCommand("test -bench .", 15, 10)
command! GoBenchmarkFunc :call g:GoBenchmarkFunc()
command! GoBuild         :call g:GoCommand("build", 15, 0)
command! GoRun           :call g:GoCommand("run", 15, 0)
command! GoDoc           :call g:GoDoc()
command! GoFmt           :call g:GoFmt()
command! GoGetUpdate     :call g:GoCommand("get -u all", 15, 5)
command! GoInstall       :call g:GoCommand("install", 15, 0)
command! GoLint          :call g:GoLint()
command! GoPackage       :call g:GoPackage()
command! GoTest          :call g:GoCommand("test", 15, 15)
command! GoBuildTest     :call g:GoCommand("test -c -i", 15, 15)
command! GoTestFunc      :call g:GoTestFunc()
command! GoTestCoverage  :call g:GoTestCoverage()
command! GoVet           :call g:GoCommand("vet", 15, 0)
command! GoGrep          :call g:GoGrep()
"
" Key Mappings.
"
nnoremap <unique> <buffer> <localleader>b :GoBuild<CR>
nnoremap <unique> <buffer> <localleader>r :GoRun<CR>
nnoremap <unique> <buffer> <localleader>D :GoDoc<CR>
nnoremap <unique> <buffer> <localleader>f :GoFmt<CR>
nnoremap <unique> <buffer> <localleader>g :GoGrep<CR>
nnoremap <unique> <buffer> <localleader>G :GoGetUpdate<CR>
nnoremap <unique> <buffer> <localleader>i :GoInstall<CR>
nnoremap <unique> <buffer> <localleader>l :GoLint<CR>
nnoremap <unique> <buffer> <localleader>m :GoBenchmarkFunc<CR>
nnoremap <unique> <buffer> <localleader>M :GoBenchmark<CR>
nnoremap <unique> <buffer> <localleader>s :TagbarToggle<CR>
nnoremap <unique> <buffer> <localleader>t :GoTestFunc<CR>
nnoremap <unique> <buffer> <localleader>T :GoTest<CR>
nnoremap <unique> <buffer> <localleader>B :GoBuildTest<CR>
nnoremap <unique> <buffer> <localleader>c :GoTestCoverage<CR>
nnoremap <unique> <buffer> <localleader>v :GoVet<CR>
nnoremap <unique> <buffer> <localleader>x :cclose<CR>

let &cpo = s:save_cpo
"
" EOF
"
