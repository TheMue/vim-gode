# vim-gode

The *Vim Go Development Environment* is a small and lightweighted extension to the
original Vim Go plugins. So it is nothing very special, but provides some helpful
functions and according key mappings when editing a Go file.

The commands are

- `GoBuild` / `<C-G>b` builds the package of the current file
- `GoRun` / `<C-G>r` builds and runs the current file
- `GoDoc` / `<C-G>D` shows the Go documentation of the identifier under the cursor
- `GoFmt` / `<C-G>f` formats the Go code
- `GoGrep` / `<C-G>g` shows all occurences of the word under the cursor in the package
- `GoInstall` / `<C-G>i` installs the package of the current file
- `GoLint` / `<C-G>l` runs `golint` on the current file
- `GoBenchmarkFunc` / `<C-G>m` takes the benchmark function surrounding the cursor and runs it
- `GoBenchmark` / `<C-G>M` runs all benchmarks of the package
- `GoTestFunc` / `<C-G>t` takes the test function surrounding the cursor and tests it
- `GoTest` / `<C-G>T` runs all tests of the package
- `GoBuildTest` / `<C-G>B` runs a build of the tests without executing them
- `GoTestCoverage` / `<C-G>c` runs a coverage test of the package
- `GoVet` / `<C-G>v` examines Go source code and reports suspicious constructs

The opened quicklist window tries to have the best size.

*More commands will follow.*

## Installation

The plugin can easily be installed when using the cool [vim-plug](https://github.com/junegunn/vim-plug)
and add

    Plug 'themue/vim-gode'

to your `.vimrc`. Alternatively you can use [pathogen.vim](https://github.com/tpope/vim-pathogen).
Simply call

    cd ~/.vim/bundle
    git clone git://github.com/themue/vim-gode

After a restart of Vim you can use *vim-gode*.

## License

*vim-gode* is distributed under the terms of the BSD 3-Clause license.
