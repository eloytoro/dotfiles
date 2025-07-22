local M = {}

function M.on_enter_file(name, callback)
  local highlight_group = vim.api.nvim_create_augroup(name, { clear = true })
  vim.api.nvim_create_autocmd('BufReadPost', {
    callback,
    group = highlight_group,
    pattern = '*',
  })
end

function M.assign(...)
  local res = {}
  for _, t in ipairs({...}) do
    for k,v in pairs(t) do
      res[k] = v
    end
  end
  return res
end

function M.is_empty_before()
  local col = vim.fn.col('.') - 1
  return col == 0 or string.match(string.sub(vim.fn.getline('.'), 0, col), '^%s*$')
end

-- Function to get the highlight group under the cursor
function M.hl()
  local pos = vim.api.nvim_win_get_cursor(0)
  local line = pos[1]
  local col = pos[2]
  -- Get the syntax ID at the cursor position
  local syn_id = vim.fn.synID(line, col + 1, 1) -- col + 1 because Vimscript uses 1-based indexing

  -- If no syntax ID is found, return nil or an empty string
  if syn_id == 0 then
    return "None"
  end

  -- Get the name of the highlight group
  local hl_name = vim.fn.synIDattr(syn_id, "name")
  return hl_name ~= "" and hl_name or "None"
end

return M
