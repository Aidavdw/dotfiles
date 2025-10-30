local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Load everything from mathjax here too
local snippets = require 'snippets.mathjax'

local function add(snippet)
  table.insert(snippets, snippet)
end

add(s('equation', {
  t { '\\begin{equation}', '\t\\label{eq:' },
  i(1),
  t { '}', '\t' },
  i(2),
  t { '', '\\end{equation}' },
}))

-- A table of 2 columns wide
add(s('table2w', {
  -- 'ht' prefers placing it here, but otherwise the top of the page is also OK.
  -- 'H' places it exactly here.
  t { '\\begin{table}[ht]', '\\centering', '\\caption{' },
  i(1),
  -- Label must come after fig, because otherwise you can't \ref it.
  t { '}', '\\label{tab:' },
  i(2),
  t { '}', '\\begin{tabular}{lcc}\\toprule', ' ' },
  i(3),
  t { ' & ' },
  i(4),
  t { ' \\\\', '\\midrule', '% copy-paste the line under here for how many lines you need.', ' ' },
  i(5),
  t { ' & ' },
  i(6),
  t { ' \\\\', '\\bottomrule', '\\end{tabular}', '\\end{table}' },
}))

-- A table of 3 columns wide
add(s('table3w', {
  -- 'ht' prefers placing it here, but otherwise the top of the page is also OK.
  -- 'H' places it exactly here.
  t { '\\begin{table}[ht]', '\\centering', '\\caption{' },
  i(1),
  -- Label must come after fig, because otherwise you can't \ref it.
  t { '}', '\\label{tab' },
  i(2),
  t { '}', '\\begin{tabular}{lcc}\\toprule', '    & ' },
  i(3),
  t { ' & ' },
  -- Can add a \cmidrule for if you you have a multi-layer heading and need a small center line here too
  i(4),
  t { ' \\\\', '\\midrule', '% copy-paste the line under here for how many lines you need.', ' ' },
  i(5),
  t { ' & ' },
  i(6),
  t { ' & ' },
  i(7),
  t { ' \\\\', '\\bottomrule', '\\end{tabular}', '\\end{table}' },
}))

-- A table of 4 columns wide
add(s('table4w', {
  t { '\\begin{table}[ht]', '\\centering', '\\caption{' },
  i(1),
  -- Label must come after fig, because otherwise you can't \ref it.
  t { '}', '\\label{tab:' },
  i(2),
  t { '}', '\\begin{tabular}{lccc}\\toprule', '    & ' },
  i(3),
  t { ' & ' },
  i(4),
  t { ' & ' },
  i(5),
  t { ' \\\\', '\\midrule', '% copy-paste the line under here for how many lines you need.', ' ' },
  i(6),
  t { ' & ' },
  i(7),
  t { ' & ' },
  i(8),
  t { ' & ' },
  i(9),
  t { ' \\\\', '\\bottomrule', '\\end{tabular}', '\\end{table}' },
}))

-- A table of 5 columns wide
add(s('table5w', {
  t { '\\begin{table}[ht]', '\\centering', '\\caption{' },
  i(1),
  -- Label must come after fig, because otherwise you can't \ref it.
  t { '}', '\\label{tab:' },
  i(2),
  t { '}', '\\begin{tabular}{lcccc}\\toprule', '    & ' },
  i(3),
  t { ' & ' },
  i(4),
  t { ' & ' },
  i(5),
  t { ' & ' },
  i(6),
  t { ' \\\\', '\\midrule', '% copy-paste the line under here for how many lines you need.', ' ' },
  i(7),
  t { ' & ' },
  i(8),
  t { ' & ' },
  i(9),
  t { ' & ' },
  i(10),
  t { ' & ' },
  i(11),
  t { ' \\\\', '\\bottomrule', '\\end{tabular}', '\\end{table}' },
}))

add(s('figure', {
  t { '\\begin{figure}[htbp]', '\\centering', '\\includegraphics[width=0.8\\textwidth]{' },
  i(1),
  t { '}', '\\caption{' },
  i(2),
  -- Label must come after fig, because otherwise you can't \ref it.
  t { '}', '\\label{fig:' },
  i(3),
  t { '}', '\\end{figure}' },
}))

add(s('\\autoref', {
  t { '\\autoref{' },
  i(1),
  t { '}' },
}))

add(s('\\acrshort', {
  t { '\\acrshort{' },
  i(1),
  t { '}' },
}))

add(s('\\textcite', {
  t { '\\textcite{' },
  i(1),
  t { '}' },
}))

add(s('\\cite', {
  t { '\\cite{' },
  i(1),
  t { '}' },
}))

add(s('verbatim', {
  t { '\\verb|' },
  i(1),
  t { '|' },
}))

add(s('subfigure2w', {
  t { '\\begin{figure}', '\\centering', '\\begin{subfigure}[htb]{0.44\\textwidth}', '\\centering', '\\includegraphics[width=\\textwidth]{' },
  i(1),
  t { '}', '\\caption{' },
  i(2),
  -- Label must come after fig, because otherwise you can't \ref it.
  t { '}', '\\label{fig:' },
  i(3),
  t { '}', '\\end{subfigure}', '\\hfill', '\\begin{subfigure}[htb]{0.44\\textwidth}', '\\centering', '\\includegraphics[width=\\textwidth]{' },
  i(4),
  t { '}', '\\caption{' },
  i(5),
  -- Label must come after fig, because otherwise you can't \ref it.
  t { '}', '\\label{fig:' },
  i(6),
  -- A shared caption and label too.
  t { '}', '\\end{subfigure}', '\\caption{' },
  i(7),
  t { '}', '\\label{fig:' },
  i(8),
  t { '}', '\\end{figure}' },
}))
-- There is a rather complex script that automatically does latex tables.
-- Dynamic latex table, taken from https://github.com/L3MON4D3/LuaSnip/wiki/Misc#dynamicnode-with-user-input

add(s('enumerate', {
  t { '\\begin{enumerate}', '  \\item ' },
  i(1),
  t { '', '\\end{enumerate}' },
}))

add(s('itemize', {
  t { '\\begin{itemize}', '  \\item ' },
  i(1),
  t { '', '\\end{itemize}' },
}))

return snippets
