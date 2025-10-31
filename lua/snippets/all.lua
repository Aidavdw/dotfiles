local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local snippets = {}

local function add(snippet)
  table.insert(snippets, snippet)
end

-- Okabe-ito hex colour codes
add(s('ito-orange', {
  t { '#E69F00' },
}))
add(s('ito-sky-blue', {
  t { '#56B4E9' },
}))
add(s('ito-bluish-green', {
  t { '#009E73' },
}))
add(s('ito-yellow', {
  t { '#F0E442' },
}))
add(s('ito-blue', {
  t { '#0072B2' },
}))
add(s('ito-vermillion', {
  t { '#D55E00' },
}))
add(s('ito-reddish-purple', {
  t { '#CC79A7' },
}))

-- Catppuccin colour codes
add(s('catppuccin-mocha-rosewater', {
  t { '#F5E0DC' },
}))
add(s('catppuccin-mocha-flamingo', {
  t { '#F2CDCD' },
}))
add(s('catppuccin-mocha-pink', {
  t { '#F5C2E7' },
}))
add(s('catppuccin-mocha-mauve', {
  t { '#CBA6F7' },
}))
add(s('catppuccin-mocha-red', {
  t { '#F38BA8' },
}))
add(s('catppuccin-mocha-maroon', {
  t { '#EBA0AC' },
}))
add(s('catppuccin-mocha-peach', {
  t { '#FAB387' },
}))
add(s('catppuccin-mocha-yellow', {
  t { '#F9E2AF' },
}))
add(s('catppuccin-mocha-green', {
  t { '#A6E3A1' },
}))
add(s('catppuccin-mocha-teal', {
  t { '#94E2D5' },
}))
add(s('catppuccin-mocha-sky', {
  t { '#89DCEB' },
}))
add(s('catppuccin-mocha-sapphire', {
  t { '#74C7EC' },
}))
add(s('catppuccin-mocha-blue', {
  t { '#89B4FA' },
}))
add(s('catppuccin-mocha-text', {
  t { '#CDD6F4' },
}))
add(s('catppuccin-mocha-subtext1', {
  t { '#BAC2DE' },
}))
add(s('catppuccin-mocha-subtext0', {
  t { '#A6ADC8' },
}))
add(s('catppuccin-mocha-overlay2', {
  t { '#9399B2' },
}))
add(s('catppuccin-mocha-overlay1', {
  t { '#7F849C' },
}))
add(s('catppuccin-mocha-overlay0', {
  t { '#6C7086' },
}))
add(s('catppuccin-mocha-surface2', {
  t { '#585B70' },
}))
add(s('catppuccin-mocha-surface1', {
  t { '#45475A' },
}))
add(s('catppuccin-mocha-surface0', {
  t { '#313244' },
}))
add(s('catppuccin-mocha-base', {
  t { '#1E1E2E' },
}))
add(s('catppuccin-mocha-mantle', {
  t { '#181825' },
}))
add(s('catppuccin-mocha-crust', {
  t { '#11111B' },
}))

return snippets
