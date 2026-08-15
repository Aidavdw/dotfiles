-- wrap around text if it goes off-screen. This breaks off words mid-word.
-- vim.o.wrap = true
-- Wrapping on a word basis, so you don't cutt of words so much.
vim.o.linebreak = true
-- Add character to start of wrapped line.
vim.o.showbreak = " 󱞵 "

-- Wrapped lines are indented.
vim.opt.breakindent = true
