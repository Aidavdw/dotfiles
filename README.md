This entire config is made to be very lightweight, while still having some IDE-like features.

Focus is on integrating with operating system.
Therefore, it also does not use mason, but relies on you managing your packages using the system package manager.
For arch linux, use the following packages:
```bash
pacman --needed -S neovim 
fzf # for fzf-lua
clang # for c LSP clangd 
vscode-css-languageserver # css LSP
dot-language-server # dot (graph) ls 
vscode-html-languageserver
texlab # LSP for latex
ruff # Linter for python
bash-language-server # bashls
stylua # formatter for lua
yamlformat
shfmt # shell formatter
python-pylatexenc # Rendering latex equations inline for markdown-render
```

And these packages from the AUR:
```bash
paru -S --needed \
fortls \ # fortran LSP 
basedpyright # static type checker
codelldb-bin # debugger for rust
tex-fmt # latex formatter
libtexprintf # Rendering latex equations inline for markdown-render
```

This config does not use a linter extension like [nvim-lint](https://github.com/mfussenegger/nvim-lint), as most of the linting I need can be done by LSPs.

It is organised very simply. All 'normal' configuration is in the lua files in the root of `./lua`, while all of the plugins (loaded using lazy.nvim) are in `./lua/plugins/`.

Being a modern setup, it uses fzf-lua instead of Telescope, and Blink.cmp instead of nvim-cmp.
It also has a simpler LSP set-up, utilising the built-in lsp functionality instead of deferring everything to lspconfig.

