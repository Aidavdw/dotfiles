-------------------------------------------------------
-- Load all the other things in specific order,
-- that's why they're numbered!
-------------------------------------------------------
require("01-options")
require("02-keymaps")
require("03-autocommands")
require("04-neovide")
-- also loads all the plugins in the plugins dir.
require("05-lazy")
require("06-lsp")
require("07-spelling")
require("08-open-in-obsidian")
