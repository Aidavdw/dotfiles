local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local snippets = {}

local function add(snippet)
  table.insert(snippets, snippet)
end

add(s('frac', {
  t { '\\frac{' },
  i(1),
  t { '}{' },
  i(2),
  t { '}' },
}))

add(s('EN', {
  t { '\\times 10^{' },
  i(1),
  t { '}' },
}))

return snippets
