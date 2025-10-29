-- We don't need lspconfig in the traditional sense any more.
-- However, it still gives nice presets for lsp configurations.
-- so for LSPs where we just want to use a 'default' configuration
-- we can just 'enable()' here and that's it.
-- you can still customise it though, for which you'd place a file in the
-- ../lsp directory.
-- https://0xunicorn.com/neovim-native-lsp-config/
vim.lsp.enable({
    'lua_ls',
    'clangd',
    'cmake',
    'cssls',
    -- Fortran
    'fortls',
    'html',
    'texlab',
    -- Python static type checker
    'basedpyright',
    -- Python linter
    'ruff',
    -- Obsidian-like markdown
    'markdown-oxide',
})


-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.have_nerd_font and {
        text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
    } or {},
    virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
            local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
        end,
    },
}

-- In an autocommand so that these keybinds are only available in
-- files that actually have lsp support
-- This was stolen from kickstart.nvim
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)

        -- Shorthand for making keybinds
        local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
        end

        -- For GOTOs etc. we use the fzf-lua wrapper.
        -- vim.lsp.buf.definition() will show a `location_list`
        -- if there are multiple hits, which is not nice.
        -- The fzf-lua wrappers instead show them in a floating window.
        local fzf = require('fzf-lua')

        -- Definition: 
        -- This is where you define a value for a symbol
        -- `myValue = 'foo';`
        -- Most LSPs resolve this to the same thing as Declaration
        -- Declaration:
        -- This is where you first declare a symbol (variable, constant, function etc.)
        -- supported by very few LSPs.
        -- For example, in C this would take you to the header.
        -- `let myValue: string;`
        map('gd', fzf.lsp_definitions, '[G]oto variable [D]efinition')

        -- Type Definition:
        -- This is where the underlying type of this variable is defined.
        -- `let a: MyType = {...}` -> brings you to `struct MyType {}`
        map('gD', fzf.lsp_typedefs, '[G]oto type [D]efinition')

        -- Find references for the word under your cursor.
        -- For markdown_oxide, this is like 'backlinks'
        map('gr', fzf.lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        -- Useful when your language has ways of declaring types without an actual implementation.
        map('gI', fzf.lsp_implementations, '[G]oto [I]mplementation')

        -- Keeps paradigm of capital = workspace, small is this buffer
        map('<leader>ss', fzf.lsp_document_symbols, '[S]earch LSP [S]ymbols (document)')
        map('<leader>sS', fzf.lsp_live_workspace_symbols, '[S]earch LSP [S]ymbols (workspace)')

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('<leader>rs', vim.lsp.buf.rename, '[R]ename [S]ymbol')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        -- This requires require('fzf-lua').register_ui_select() to have been called.
        map('<leader><leader>', fzf.lsp_code_actions, 'Suggestion or Action', { 'n', 'x' })

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        -- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Sometimes the diagnostics that are drawn in virtual text are very long, and go off the screen. Wrapping virtual text is impossible(?), but you can pop-up the entire message in a little window
        map('<leader>pd', vim.diagnostic.open_float, '[P]opup [D]iagnostic')

        map('<leader>h', function()
            -- See :h vim.lsp.utils.open_floating_preview.Opts for options here
            vim.lsp.buf.hover()
        end, 'LSP [H]over action')

        -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer some lsp support methods only in specific files
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
                return client:supports_method(method, bufnr)
            else
                return client.supports_method(method, { bufnr = bufnr })
            end
        end

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        -- This was stolen from kickstart.nvim
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                end,
            })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')

            -- Enable inlay hints by default (at startup)
            vim.lsp.inlay_hint.enable()
        end
    end,
})
