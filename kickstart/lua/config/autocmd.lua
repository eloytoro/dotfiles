-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- local incsearch_id = vim.api.nvim_create_augroup("IncsearchClear", { clear = true })
--
-- vim.api.nvim_create_autocmd({"CmdlineEnter"}, {
--   pattern = {"/,\\?"},
--   group = incsearch_id,
--   callback = function() 
--     vim.o.hlsearch = true
--   end
-- })
--
-- vim.api.nvim_create_autocmd({"CmdlineLeave"}, {
--   pattern = {"/,\\?"},
--   group = incsearch_id,
--   callback = function() 
--     vim.o.hlsearch = false
--   end
-- })
