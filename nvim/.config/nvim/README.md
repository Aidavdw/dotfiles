# Neovim configuration

My personal, opinionated neovim configuration.
I use this mostly for programming and taking notes!
I intend for it to be pretty lightweight, yet still have all the features I need.
With that, it falls somewhere between a minimal and an IDE-like config.

Minimal abstraction.
No installer scripts, no extra config files.
If you want to edit anything, the config itself should be easy enough to follow.

| Feature | included? | remark |
| - | - | - |
| plugin dependency management | ◯ | Using lazy.nvim, because vim.pack does not yet support lazy loading. |
| LSP dependency management | ✘ | Bring your own tools. See installation steps. If you want, you can definitely still use mason, it is not required. |
| Treesitter dependency management | ◯ | Uses tree-sitter-manager to install treesitter things. Auto-install is disabled. |
| LSP | ◯ | Uses neovim's built-in LSP. Still uses `lspconfig` for stubs of configuration files for brevity. |
| snippets | ◯ | using LuaSnip |
| spell checking | ◯ | using built-in nvim spell-checker |
| code formatting | ◯ | using conform |
| notifications | ◯ | using fidget.nvim |
| autocompletion | ◯ | using blink.cmp |
| file annotation and linking | ◯ | shows LSP things, renders markdown, colour-coded scopes and indentation. |
| editing extensions | ◯ | select entire functions, swap arguments, etc. |
| tree file view / sidebar | ✘ | use fzf-lua to search/switch. For file operations, netrw is just fine. |
| basic git | ◯ | shows new lines etc. Some keybinds to make working with git *inside the buffer* easier. |
| complex git manager | ✘ | do your merging/commiting/branching externally. May I suggest `lazygit`? |
| linter extension | ✘ | This config does not use a linter extension like nvim-lint, as most of the linting I need can be done by LSPs.|

## Organisation

It is organised very simply.
All 'normal' configuration is in the lua files in the root of `./lua`,
while all of the plugins (loaded using lazy.nvim) are in `./lua/plugins/`.
The entire config is commented so you can steal little bits and pieces everywhere <3

## Installation

Bring your own external dependencies. Use your system package manager if possible!
This differs per operating system.

| Arch package | Void package |
| - | - |
| neovim | neovim |
| fzf | fzf |

Then optional dependencies:
If missing, Neovim should still work but the language servers simply won't load.
For Void Linux, unfortunately some packages are missing.
You can also supplement with Mason.

| Arch package | Void package | Mason | reason |
| - | - | - | - |
| fzf | . | - | fuzzy finder |
| wl-clipboard | . | - | Copying to the system clipboard (wayland) |
| ripgrep | ripgrep | - | ripgrep, better grep utility. Used by fzf |
| bat | . | - | used for higlighting previews in fzf |
| tree-sitter-cli | . | ? | dependency of texlab |
| clang | . | - | clang contains the `clangd` LSP for c. You also need this or `gcc` for Luasnip.|
| vscode-css-languageserver | - | ? | # css LSP |
| dot-language-server | - | ? | dot (graph) ls |
| vscode-html-languageserver | - | ? | |
| texlab | . | ? | LSP for latex|
| ruff | . | ? | Linter for python|
| ty | . | ? | python static type checker|
| rumdl | (self-packaged) | ? | markdown linter and formatter |
| markdown-oxide | . | ? | LSP for markdown in my notes |
| bash-language-server | . | ? | bashls|
| stylua | StyLua | ? | formatter for lua|
| yamlfmt | yamlfmt | ? | |
| shfmt | . | ? | shell formatter|
| python-pylatexenc | - | ? | Rendering latex equations inline for markdown-render|
| imagemagick | . | ? | needed for the image.nvim plugin|
| unzip | . | ? | used to use the lua lsp.|
| fortls (AUR) | - | ? | fortran LSP|
| fortitude-bin (AUR) | - | ? | fortran linter|
| codelldb-bin (AUR) | - | ? | debugger. Rustaceanvim works best with this specific build. |
| tex-fmt (AUR) | - | ? | latex formatter|
| libtexprintf (AUR) | - | ? | Rendering latex equations inline for markdown-render|

Be sure you have `unzip` and `npm` installed, as they are required for lua & latex LSP respectively!

### Rustaceanvim

[mrcjkb/rustaceanvim](https://github.com/mrcjkb/rustaceanvim?tab=readme-ov-file#books-usage--features) runs better with the VSCode version of LLDB, so that must be installed with `paru -S codelldb-bin`.
In addition, it runs with the **local** Rust toolchain. Trying to install rust-analyzer through mason will cause conflicts. So, **do not install rust-analyzer through mason**.
Also note that you must have `rust-analyser` installed, it does not come with the toolchain by default!

### TreeSitter

Using latex requires the CLI client of **Treesitter** to be installed.
using the ensure_installed flag does not actually force installation until you open a file of that type. For Mathjax/latex, this is a problem. Install some manually:

```nvim
:TSInstall markdown markdown_inline html latex typst yaml
```

the latex one requires you to build the grammar, which means that you need to have nodejs installed.

## Troubleshooting

If you get an error like `[fzf-lua] Unable to add buffer`, you should probably wait for `TSManager` to finish installing all the treesitter grammars. It does not load automatically (lazy)!
