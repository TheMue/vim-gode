"
" Vim Go Development Environment
"
" Copyright (c) 2014, Frank Mueller / Tideland / Oldenburg / Germany
"
if exists("g:vim_gode_loaded")
    finish
endif
let g:vim_gode_loaded = 1
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

function! g:GoLint()
	cexpr system("golint " . shellescape(expand('%')))
	if v:shell_error
		copen 15
	endif
endfunction
"
" Commands.
"
command! GoPackage :call g:GoPackage()
command! GoBuild :call g:Go("build", 15, 0)
command! GoTest :call g:Go("test", 15, 2)
command! GoTestFunc :call g:GoTestFunc()
command! GoInstall :call g:Go("install", 15, 0)
command! GoVet :call g:Go("vet", 15, 0)
command! GoLint :call g:GoLint()
"
" Key Mappings.
"
nmap <Leader>d g<C-]>
nmap <Leader>D :Godoc<CR>
nmap <Leader>b :GoBuild<CR>
nmap <Leader>c :ccl<CR>
nmap <Leader>T :GoTest<CR>
nmap <Leader>t :GoTestFunc<CR>
nmap <Leader>i :GoInstall<CR>
nmap <Leader>v :GoVet<CR>
nmap <Leader>l :GoLint<CR>
"
" EOF
"
