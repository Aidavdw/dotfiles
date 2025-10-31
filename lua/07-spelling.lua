-- Neovim is rather slow when handling many spelling languages.
-- So, only start with English, but allow turning on more.
vim.opt.spelllang = { "en_gb" }
vim.opt.spell = true
vim.opt.spelloptions = "camel"

-- Pure toggle function: returns new_list, enabled (true if language is now enabled)
-- Return new list and whether the language is enabled after the toggle
function _G.toggle_spell_language(lang)
    local current = vim.opt.spelllang:get() -- returns a table of active languages
    local new = {}
    local found = false
    for _, l in ipairs(current) do
        if l == lang then
            found = true
        else
            table.insert(new, l)
        end
    end
    if not found then
        table.insert(new, lang)
        found = true
    else
        found = false
    end
    return new, found
end

-- bind_toggle: creates a keymap that toggles `lang`, updates vim.opt.spelllang,
-- and performs all notifications here.
local function bind_toggle(lang, key_sequence, desc, short_name)
    -- short_name is optional (shown in notifications); default to lang
    short_name = short_name or lang
    vim.keymap.set("n", key_sequence, function()
        local new_list, enabled = toggle_spell_language(lang)
        vim.opt.spelllang = new_list

        -- Notify about toggle action
        if enabled then
            vim.notify("Toggled spelling language '" .. short_name .. "' (enabled)")
        else
            vim.notify("Toggled spelling language '" .. short_name .. "' (disabled)")
        end

        -- Notify current languages
        vim.notify(
            "current spell languages: " .. (vim.tbl_isempty(new_list) and "<none>" or table.concat(new_list, ", "))
        )
    end, { desc = "[T]oggle [S]pelling: " .. desc })
end

-- Create bindings for your languages
bind_toggle("en_gb", "<leader>Tse", "English (GB)", "en_gb")
bind_toggle("nl", "<leader>Tsn", "Dutch", "nl")
bind_toggle("de", "<leader>Tsd", "German", "de")
bind_toggle("cjk", "<leader>Tsc", "CJK", "cjk")
