local M = {}

function M.show_response(response)
  vim.schedule(function()
    vim.cmd("botright 15new")
    local buf = vim.api.nvim_get_current_buf()

    local lines = {}
    for line in response:gmatch("[^\r\n]+") do
      table.insert(lines, line)
    end

    if #lines == 0 then
      lines = { response }
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "modifiable", false)

    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
  end)
end

return M
