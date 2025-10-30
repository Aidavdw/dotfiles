A very lightweight, modern, yet featureful neovim configuration.
Optimised for note-taking and programming.
It falls somewhere between a minimal and an IDE-like config:

| Feature | included? | remark |
| - | - | - |
| LSP | ✓ | Modern setup, using locally installed LSPs (no Mason) |
| snippets | ✓ | using LuaSnip |
| spell checking | ✓ | using built-in nvim spell-checker |
| code formatting | ✓ | using conform |
| notifications | ✓ | using fidget.nvim |
| autocompletion | ✓ | using blink.cmp |
| file annotation | ✓ | shows LSP things, renders markdown, colour-coded scopes and indentation. |
| editing extensions | ✓ | select entire functions, swap arguments, etc. |
| file manager | ✘ | use fzf-lua to search/switch. For file operations, netrw is just fine. |
| git manager | ✘ | operations like stashing, hunking etc is supported through gitsigns.nvim, |
| | | but do your committing, branching etc. using a dedicated tool. |
| | | May I suggest something like lazygit or cli? |
| | | For merging, just use `nvim -d`|


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
imagemagick # needed for the image.nvim plugin
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

The entire config is commented so you can steal little bits and pieces everywhere <3

