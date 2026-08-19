vim.cmd([[cab cc CodeCompanion]])
return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        interactions = {
            chat = {
                adapter = {
                    name = "openrouter",
                    --- best value/money for coding, high quality.
                    model = "openai/gpt-5.6-luna",
                    --- Cheaper, still very good code
                    --- model = "deepseek/deepseek-v4-pro",
                    -- A super simple free one
                    -- model = "nvidia/nemotron-3-nano-30b-a3b:free",
                    -- A more  detailed one
                    --model = "anthropic/claude-sonnet-4.5",
                },
            },
            inline = {
                adapter = {
                    name = "openrouter",
                    --- Cheaper, still very good code
                    model = "deepseek/deepseek-v4-pro",
                },
            },
        },
        adapters = {
            http = {
                openrouter = function()
                    return require("codecompanion.adapters").extend("openrouter", {
                        env = {
                            api_key = "cmd:secret-tool lookup password openrouterapi",
                        },
                        schema = {
                            preset = { default = "email-copywriter" },
                            ["nvidia-nano"] = "nvidia/nemotron-3-nano-30b-a3b:free",
                            ["claude-sonnet"] = "anthropic/claude-sonnet-4.5",
                        },
                    })
                end,
            },
        },
    },
    cmd = {
        "CodeCompanion",
    },
    keys = {
        {
            "<leader>ll",
            "<cmd>CodeCompanionActions<cr>",
            desc = "Action menu",
        },
        {
            "<leader>lc",
            "<cmd>CodeCompanionChat Toggle<cr>",
            desc = "Toggle chat",
        },
        {
            "<leader>ly",
            "<cmd>CodeCompanionChat Add<cr>",
            mode = "v",
            desc = "Add selected code to chat",
        },
    },
}
