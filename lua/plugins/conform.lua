return {
    -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            -- Probably not used as much, since autoformat on save. Still nice to have as a backup.
            "<leader>bf",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = "",
            desc = "[B]uffer: Auto[F]ormat",
        },
        {
            "<leader>bF",
            function()
                vim.b.disable_autoformat = not vim.b.disable_autoformat
                if vim.b.disable_autoformat then
                    vim.notify("Autoformat on save disabled for this buffer", vim.log.levels.INFO)
                else
                    vim.notify("Autoformat on save enabled for this buffer", vim.log.levels.INFO)
                end
            end,
            desc = "[B]uffer: toggle auto[F]ormat on save",
        },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        notify_on_error = true,
        format_on_save = function(bufnr)
            -- Check if a variable is set for this specific buffer to *NOT* apply autoformatting.
            -- In doing so, we can opt-out of autoformatting.
            -- Note that this resets on every time you load the file, but it's a rare enough occurrence that this should be pretty alright
            -- taken from https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
            if vim.b[bufnr].disable_autoformat then
                return nil
            end

            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true }
            if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
            else
                return {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                }
            end
        end,
        formatters_by_ft = {
            lua = { "stylua" },
            yaml = { "yamlformat" },
            sh = { "shfmt" },
            json = { "fixjson" },
            tex = { "tex-fmt" },
            -- TODO: Add bibtex-tidy for bibtex
            -- Rust uses rustaceanvim, which means it can just fall back on the LSP
            --
            -- Conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
            --
            -- You can use 'stop_after_first' to run the first available formatter from the list
            -- javascript = { "prettierd", "prettier", stop_after_first = true },
        },
        -- Configuration of formatters
        formatters = {
            stylua = {
                -- Use append_anrgs instead of "args" as that will delete existing args.
                append_args = {
                    "--indent-type",
                    "Spaces",
                },
            },
        },
    },
}
