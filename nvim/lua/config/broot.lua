local function open_broot()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  local win_opts = {
    relative = "editor",
    width = math.ceil(width * 0.8),
    height = math.ceil(height * 0.8),
    col = math.ceil(width * 0.1),
    row = math.ceil(height * 0.1),
    style = "minimal",
    border = "rounded"
  }

  local win_id = vim.api.nvim_open_win(buf, true, win_opts)

  vim.cmd("au BufWipeout <buffer> exe 'silent bwipeout! '" .. buf)

  local cmd = "startinsert | term broot --outcmd 'nvr --remote-silent %file'"
  vim.fn.termopen(cmd, { on_exit = function() vim.api.nvim_win_close(win_id, true) end })

  vim.cmd("startinsert")
end

vim.keymap.set('n', '<leader>br', open_broot)
