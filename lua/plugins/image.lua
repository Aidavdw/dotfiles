-- Helper to expand `~` and normalize paths
local function expand_path(path)
    return vim.fn.expand(path)
end

-- Helper to check if file exists
local function file_exists(path)
    return vim.fn.filereadable(path) == 1
end

-- Helper to recursively search in a directory (and subdirsh) using glob
local function search_in_dir(dir, name)
    local pattern = dir .. "/**/" .. name
    local matches = vim.fn.glob(pattern, false, true)
    if #matches > 0 then
        return matches[1] -- return first match
    end
    return nil
end

return {
    "3rd/image.nvim",
    -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    build = false,
    ft = { "markdown" },
    opts = {
        processor = "magick_cli",
        integrations = {
            markdown = {
                resolve_image_path = function(document_path, local_image_path, fallback)
                    -- Search in for any files in the cwd or any of its sub-folders.
                    -- In addition, search in the extra search paths defined below
                    local working_dir = vim.fn.getcwd()
                    local search_paths = {
                        "~/notes/",
                    }
                    -- extract basename
                    local filename = vim.fn.fnamemodify(local_image_path, ":t")

                    -- Try in cwd and its subfolders
                    local found = search_in_dir(working_dir, filename)
                    if found then
                        return found
                    end

                    -- Try in additional search paths
                    for _, path in ipairs(search_paths) do
                        local dir = expand_path(path)
                        found = search_in_dir(dir, filename)
                        if found then
                            return found
                        end
                    end

                    -- Nothing found — call fallback
                    return fallback(document_path, local_image_path)
                end,
            },
        },
    },
}
