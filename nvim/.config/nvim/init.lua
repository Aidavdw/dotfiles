--- Load all of the (partial) config files in the `./lua/autoload` dir.
--- Very much inspired by the `conf.d`-style thing.
--- Note that Lazy.nvim is loaded this way too, and that in turn loads all the entries of `./lua/plugins`
local files = vim.fn.glob(vim.fn.stdpath("config") .. "/lua/autoload/*.lua", false, true)
table.sort(files)
for _, file in ipairs(files) do
    require("autoload." .. vim.fn.fnamemodify(file, ":t:r"))
end
