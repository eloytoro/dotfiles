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

return M
