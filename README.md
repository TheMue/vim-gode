vim-gode
========

The *Vim Go Development Environment* is a small and lightweighted extension to the
original Vim Go plugins. So it is nothing very special, but provides some helpful
functions and according key mappings when editing a Go file.

In alphabetical order:

- `<LEADER>b` builds the package of the current file with `go build`.
- `<LEADER>d` jumps to the definition of the identifier under the cursor, based on
  the *ctags*. In case of multiple definitions all are shown in a menu.
- `<LEADER>D` shows the Go documentation of the identifier under the cursor.
- `<LEADER>i` installs the package of the current file with `go install`.
- `<LEADER>m` takes the benchmark function surrounding the cursor and runs it.
- `<LEADER>M` runs all benchmarks.
- `<LEADER>l` runs `golint` on the current file.
- `<LEADER>t` takes the test function surrounding the cursor and tests it.
- `<LEADER>T` runs all tests.
- `<LEADER>v` checks the current packages with `go vet`.
- `<LEADER>x` closes the quicklist window, e.g. after running build or test.

The opened quicklist window tries to have the best size.

*More commands will follow.*

Installation
------------

The plugin can easily be installed when using [pathogen.vim](https://github.com/tpope/vim-pathogen).
Simply call

    cd ~/.vim/bundle
    git clone git://github.com/TheMue/vim-gode

After a restart of Vim you can use *vim-gode*.

License
-------

*vim-gode* is distributed under the terms of the BSD 3-Clause license.
