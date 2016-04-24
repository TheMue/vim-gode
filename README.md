# vim-gode

The *Vim Go Development Environment* is a small and lightweighted extension to the
original Vim Go plugins. So it is nothing very special, but provides some helpful
functions and according key mappings when editing a Go file.

In alphabetical order:

- `<localleader>b` builds the package of the current file
- `<localleader>D` shows the Go documentation of the identifier under the cursor
- `<localleader>f` formats the Go code
- `<localleader>g` shows all occurences of the word under the cursor in the package
- `<localleader>i` installs the package of the current file
- `<localleader>l` runs `golint` on the current file.
- `<localleader>m` takes the benchmark function surrounding the cursor and runs it
- `<localleader>M` runs all benchmarks of the package
- `<localleader>s` shows the file structure using the Tagbar plugin
- `<localleader>t` takes the test function surrounding the cursor and tests it
- `<localleader>T` runs all tests of the package
- `<localleader>v` examines Go source code and reports suspicious constructs
- `<localleader>x` closes the quicklist window, e.g. after running build or test

The opened quicklist window tries to have the best size.

*More commands will follow.*

## Installation

The plugin can easily be installed when using [pathogen.vim](https://github.com/tpope/vim-pathogen).
Simply call

    cd ~/.vim/bundle
    git clone git://github.com/TheMue/vim-gode

After a restart of Vim you can use *vim-gode*.

## License

*vim-gode* is distributed under the terms of the BSD 3-Clause license.
