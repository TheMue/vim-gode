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

function! g:Go(command, errsize, oksize)
	let cwd = getcwd()
	let pd = fnamemodify(resolve(@%), ':p:h')
	cd `=pd`
	" echo "Running 'go " . a:command . "' ..."
	cexpr system("go " . a:command)
	if v:shell_error
		call s:COpenHeight(a:errsize)
	else
		call s:COpenHeight(a:oksize)
	endif
	cd `=cwd`
endfunction

function! g:GoTestFunc()
	let line = search("Test[A-Z][a-zA-Z0-9]*", "b")
	let fname = expand("<cword>")
	let command = "test -test.run " . fname
	call g:Go(command, 15, 2)
endfunction

function! g:GoBenchmarkFunc()
	let line = search("Benchmark[A-Z][a-zA-Z0-9]*", "b")
	let fname = expand("<cword>")
	let command = "test -bench " . fname
	call g:Go(command, 10, 3)
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
command! GoBenchmark :call g:Go("test -bench .", 10, 10)
command! GoBenchmarkFunc :call g:GoBenchmarkFunc()
command! GoBuild :call g:Go("build", 15, 0)
command! GoInstall :call g:Go("install", 15, 0)
command! GoLint :call g:GoLint()
command! GoPackage :call g:GoPackage()
command! GoTest :call g:Go("test", 15, 2)
command! GoTestFunc :call g:GoTestFunc()
command! GoVet :call g:Go("vet", 15, 0)
"
" Key Mappings.
"
nnoremap <unique> <buffer> <LocalLeader>b :GoBuild<CR>
nnoremap <unique> <buffer> <LocalLeader>d g<C-]>
nnoremap <unique> <buffer> <LocalLeader>D :Godoc<CR>
nnoremap <unique> <buffer> <LocalLeader>i :GoInstall<CR>
nnoremap <unique> <buffer> <LocalLeader>l :GoLint<CR>
nnoremap <unique> <buffer> <LocalLeader>m :GoBenchmarkFunc<CR>
nnoremap <unique> <buffer> <LocalLeader>M :GoBenchmark<CR>
nnoremap <unique> <buffer> <LocalLeader>t :GoTestFunc<CR>
nnoremap <unique> <buffer> <LocalLeader>T :GoTest<CR>
nnoremap <unique> <buffer> <LocalLeader>v :GoVet<CR>

nmap <LocalLeader>x :ccl<CR>

let &cpo = s:save_cpo
"
" EOF
"
