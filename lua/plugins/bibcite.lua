-- My own plugin for adding bibtex references
return {
    -- path to your local plugin
    dir = "/home/aida/repos/bibcite.nvim/",
    -- optional name if it's not in a Git repo
    name = "bibcite",
    -- Running these commands triggers lazy load. They are still auto-completed.
    cmd = { "CiteDebug", "CiteOpen", "CiteInsert", "CitePeek", "CiteNote" },
    -- Hitting these keybinds triggers lazy-load. They still show up in which-keys.
    keys = {
        { "<leader>ci", ":CiteInsert<CR>", desc = "Insert citation" },
        { "<leader>cp", ":CitePeek<CR>", desc = "Peek citation info" },
        { "<leader>co", ":CiteOpen<CR>", desc = "Open citation file" },
        { "<leader>cn", ":CiteNote<CR>", desc = "Open citation note" },
    },
    opts = {
        bibtex_path = vim.fn.expand("/alt/code/bibliography/thesis.bib"),
        pdf_dir = vim.fn.expand("/alt/code/bibliography/files"),
        notes_dir = vim.fn.expand("~/notes/literature-notes"),
    },
}
