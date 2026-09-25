-- Though the idea of a swapfile is really nice,
-- holy shit have I run into corruption and stale swap files often.
-- I generally use neovim only for files that are version controlled anyway,
-- so let's just write them directly.

vim.opt.swapfile = false
vim.opt.autowrite = true
vim.opt.autoread = true
