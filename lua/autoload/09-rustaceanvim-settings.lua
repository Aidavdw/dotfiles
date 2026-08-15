-- rustaceanvim's settings are set using vim.g.rustaceanvim, instead of in the plugin settings.
-- This should always work, even if the plugin is not loaded (though it will always be, because not lazy)
-- For all keys, see `help rustaceanvim.config`
vim.g.rustaceanvim = {
    tools = {
        -- Can only turn it on or off.
        -- Changing this value while it is running does not mean it is reloaded.
        -- It appears that allowing single runs using flycheck is not supported
        -- https://github.com/mrcjkb/rustaceanvim/issues/453
        enable_clippy = false,
    },
    -- LSP configuration
    server = {
        -- on_attach = function(_client, bufnr)
        --     -- you can also put keymaps in here
        -- end,
        default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
                diagnostics = {
                    disabled = {
                        -- this hides the "code is inactive due to #[cfg] directives: debug_assertions is enabled".
                        -- They did not show up in the Trouble panel before, but this also just removes the extra visual clutter from the inline.
                        -- this does *not* stop 'function is never called', that is "dead-code".
                        "inactive-code",
                    },
                },
            },
        },
    },
}
