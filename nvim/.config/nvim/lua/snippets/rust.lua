local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local snippets = {}

local function add(snippet)
    table.insert(snippets, snippet)
end

add(s("test-miette", {
    t({ "#[test]", "fn " }),
    i(1),
    t({ "() -> miette::Result<()> {", " ", " " }),
    i(2),
    t({
        "    Ok(())",
        "}",
    }),
}))

return snippets
