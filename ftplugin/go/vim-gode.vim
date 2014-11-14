"
" Vim Go Development Environment
"
" Copyright (c) 2014, Frank Mueller / Tideland / Oldenburg / Germany
"
if exists("b:vim_gode_loaded")
    finish
endif
let b:vim_gode_loaded = 1

let s:save_cpo = &cpo
set cpo&vim
"
" Functions.
"
function! s:COpenHeight(height)
	if a:height > 0
		exec "copen " . a:height
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
		call s:COpenHeight(a:errsize)
	else
		call s:COpenHeight(a:oksize)
	endif
	cd `=cwd`
endfunction

function! g:GoTestFunc()
	let line = search("func Test[A-Z][a-zA-Z0-9]*", "b")
	normal w
	let fname = expand("<cword>")
	let command = "test -test.run " . fname
	call g:GoCommand(command, 15, 5)
endfunction

function! g:GoBenchmarkFunc()
	let line = search("func Benchmark[A-Z][a-zA-Z0-9]*", "b")
	normal w
	let fname = expand("<cword>")
	let command = "test -bench " . fname
	call g:GoCommand(command, 15, 5)
endfunction

function! g:GoLint()
	cexpr system("golint " . shellescape(expand('%')))
	if v:shell_error
		copen 15
	endif
endfunction
"
" Commands.
"
command! GoBenchmark :call g:GoCommand("test -bench .", 15, 5)
command! GoBenchmarkFunc :call g:GoBenchmarkFunc()
command! GoBuild :call g:GoCommand("build", 15, 0)
command! GoInstall :call g:GoCommand("install", 15, 0)
command! GoLint :call g:GoLint()
command! GoPackage :call g:GoPackage()
command! GoTest :call g:GoCommand("test", 15, 5)
command! GoTestFunc :call g:GoTestFunc()
command! GoVet :call g:GoCommand("vet", 15, 0)
"
" Key Mappings.
"
nnoremap <unique> <buffer> <LocalLeader>b :GoBuild<CR>
nnoremap <unique> <buffer> <LocalLeader>D :Godoc<CR>
nnoremap <unique> <buffer> <LocalLeader>f :Fmt<CR>
nnoremap <unique> <buffer> <LocalLeader>i :GoInstall<CR>
nnoremap <unique> <buffer> <LocalLeader>l :GoLint<CR>
nnoremap <unique> <buffer> <LocalLeader>m :GoBenchmarkFunc<CR>
nnoremap <unique> <buffer> <LocalLeader>M :GoBenchmark<CR>
nnoremap <unique> <buffer> <LocalLeader>t :GoTestFunc<CR>
nnoremap <unique> <buffer> <LocalLeader>T :GoTest<CR>
nnoremap <unique> <buffer> <LocalLeader>v :GoVet<CR>

nmap <F10> :execute "vimgrep /" . expand("<cword>") . "/j **/*.go"<Bar>cw<CR> 

let &cpo = s:save_cpo
"
" EOF
"
