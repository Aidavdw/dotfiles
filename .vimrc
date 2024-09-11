nnoremap <SPACE> <Nop> " Reset space before allowing it to be leader key
let mapleader = "\<Space>"
set number "Show linenumbers
set relativenumber "Linenumbers relative to where you are now
set nocp "Vim must not be in compatible mode to be able to use line completion


set splitbelow
set splitright

" Use spaces instead of tabs. If there are tabs, make them 4 chars wide. another comment like this
set tabstop=4
set expandtab
set shiftwidth=4
set smarttab " let's tab key insert 'tab stops', and bksp deletes tabs.
set shiftround " tab / shifting moves to closest tabstop.
set autoindent " Match indents on new lines.
set smartindent " Intellegently dedent / indent new lines based on rules.

" easier way to exit insert mode with colemak keys. Sorry qwerty nerds.
:inoremap tn <esc>

" Allow yanking to system clipboard (linux). Note that  vim needs to be compiled with the +clipboard flag, and the one on arch repo is not. (workaround is installing gvim)
set clipboard=unnamedplus

" Scroll in such a way that the current line is in the centre, not at the last line.
set scrolloff=8

set wrap
set breakindent
set showbreak=⤷/ 
set linebreak

" Disable backups etc. We got git
set nobackup
set nowritebackup
set noswapfile

" Search settings
set ignorecase
set smartcase
set incsearch
set gdefault "\g flag → Search in the entire line, not just the first word. This auto-sets this flag.
set hlsearch
" Press Space to turn off highlighting and clear any message already displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

set virtualedit+=block "Allow block select cursor to go past end of line

" Visual line nav, not real line nav
" If you wrap lines, vim by default won't let you move down one line to the
" wrapped portion. This fixes that.
noremap j gj
noremap k gk

syntax on "Enable syntax highlighting

" CUSTOM KEYBINDS
" easier way to exit insert mode with colemak keys. Sorry qwerty nerds.
:inoremap tn <esc>
set smarttab " let's tab key insert 'tab stops', and bksp deletes tabs.
set shiftround " tab / shifting moves to closest tabstop.
set autoindent " Match indents on new lines.
set smartindent " Intellegently dedent / indent new lines based on rulesset smarttab " let's tab key insert 'tab stops', and bksp deletes tabs.
set shiftround " tab / shifting moves to closest tabstop.
set autoindent " Match indents on new lines.
set smartindent " Intellegently dedent / indent new lines based on rules.
