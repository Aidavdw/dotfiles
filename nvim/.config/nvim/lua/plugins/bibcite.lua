-- My own plugin for adding bibtex references
return {
    -- Alternatively use this:
    -- path to my local dev copy of the plugin
    -- dir = "/home/aida/repos/bibcite.nvim/",
    "aidavdw/bibcite.nvim",

    -- optional name if it's not in a Git repo
    name = "bibcite",
    -- Running these commands triggers lazy load. They are still auto-completed.
    cmd = { "CiteDebug", "CiteOpen", "CiteInsert", "CitePeek", "CiteNote" },
    -- Hitting these keybinds triggers lazy-load. They still show up in which-keys.
    keys = {
        { "<leader>ci", "<cmd>CiteInsert<CR>", desc = "Insert citation" },
        { "<leader>cp", "<cmd>CitePeek<CR>", desc = "Peek citation info" },
        { "<leader>co", "<cmd>CiteOpen<CR>", desc = "Open citation file" },
        { "<leader>cn", "<cmd>CiteNote<CR>", desc = "Open citation note" },
    },
    opts = {
        bibtex_path = vim.fn.expand("~/repos/bibliography/thesis.bib"),
        pdf_dir = vim.fn.expand("/alt/literature"),
        notes_dir = vim.fn.expand("~/notes/literature-notes"),
    },
}
