-- does not take over the 's' key like mini.surround does.
-- Many advanced use cases:
-- See `:h nvim-surround.introduction` for basic binds.
return {
    "kylechui/nvim-surround",
    version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
}
