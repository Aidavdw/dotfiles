local M = {}

M.root = vim.fn.expand("~/notes")

---@param bufnr integer
---@return boolean
function M.contains_buffer(bufnr)
    return vim.fs.relpath(M.root, vim.api.nvim_buf_get_name(bufnr)) ~= nil
end

return M
