vim.cmd([[cab cc CodeCompanion]])
return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        interactions = {
            chat = {
                --- ACP conversation with Claude Code is the default chat.
                adapter = "claude_code",
                --- To go back to OpenRouter over HTTP, swap the line above for:
                --- adapter = {
                ---     name = "openrouter",
                ---     --- best value/money for coding, high quality.
                ---     model = "openai/gpt-5.6-luna",
                ---     --- Cheaper, still very good code
                ---     --- model = "deepseek/deepseek-v4-pro",
                ---     -- A super simple free one
                ---     -- model = "nvidia/nemotron-3-nano-30b-a3b:free",
                ---     -- A more  detailed one
                ---     --model = "anthropic/claude-sonnet-4.5",
                --- },
                editor_context = {
                    ["buffer"] = {
                        opts = {
                            -- Always sync the buffer by sharing its "diff"
                            -- Or choose "all" to share the entire buffer
                            default_params = "diff",
                        },
                    },
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
            acp = {
                claude_code = function()
                    return require("codecompanion.adapters").extend("claude_code", {
                        env = {
                            CLAUDE_CODE_OAUTH_TOKEN = "cmd:secret-tool lookup password claudecodepolars",
                        },
                        defaults = {
                            --- ACP session config options, applied when the session starts.
                            --- Names/values are resolved case-insensitively against what the
                            --- agent advertises; check the chat debug window for the real list.
                            session_config_options = {
                                model = "Opus",
                            },
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
