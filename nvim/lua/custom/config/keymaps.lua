local helpers = require('custom.helpers')
local set = vim.keymap.set
-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help set()`
set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
set('n', '<Esc>', '<C-\\><C-n>', { noremap = true })

-- Remap for dealing with word wrap
set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


-- map <F2> :so $MYVIMRC<CR>
set('n', '_', 'O<Esc>')
set('n', '-', 'o<Esc>')
set('n', 'Q', '@q', { noremap = true })
-- nmap <leader>q :cope<CR>
-- nmap cd :cd %:p:h<CR>
set('n', '<Tab>', 'gt', { noremap = true })
set('n', '<S-Tab>', 'gT', { noremap = true })
set('n', '<c-i>', '<Tab>', { noremap = true })
-- set('n', '<silent>', '<M-n> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>', { noremap = true })
-- set('n', '<silent>', '<M-p> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>', { noremap = true })
set('', '<C-b>', '<C-U>')
set('', '<C-f>', '<C-D>')
set('o', 'H', '^', { noremap = true })
set('o', 'L', '$', { noremap = true })
set('n', 'H', '^', { noremap = true })
set('n', 'L', '$', { noremap = true })
set('v', 'H', '^', { noremap = true })
set('v', 'L', '$', { noremap = true })
set('n', 'Y', 'y$', { noremap = true })
set('i', '<c-t>', '<C-R>=strftime("%c")<CR>', { noremap = true })
set('i', '<c-l>', '<space>=><space>', { noremap = true })
-- set('c', '<expr>', '%% expand(\'%:h\').'/'', { noremap = true })
-- set('c', '<expr>', '!! expand(\'%:p\')', { noremap = true })
-- set('c', '<expr>', '@@ expand(\'%:p:h\').'/'', { noremap = true })
set('n', ']b', ':bn<CR>', { noremap = true, silent = true })
set('n', '[b', ':bp<CR>', { noremap = true, silent = true })
set('n', ']q', ':cn<CR>zz', { noremap = true, silent = true })
set('n', '[q', ':cp<CR>zz', { noremap = true, silent = true })
set('n', '<C-t>', ':tabnew<cr>', { noremap = true })
set('i', '<C-s>', '<C-O>:update<cr>', { noremap = true })
set('n', '<C-s>', ':update<cr>', { noremap = true })
set('i', '<C-Q>', '<esc>:q<cr>', { noremap = true })
set('n', '<C-Q>', ':q<cr>', { noremap = true })
set('i', '<C-e>', '<End>', { noremap = true })
set('i', '<C-a>', '<Home>', { noremap = true })

----------------------------------------------------------------------------
--   Moving lines | for quick line swapping purposes
----------------------------------------------------------------------------
set('n', '<C-k>', ':move-2<cr>', { noremap = true, silent = true })
set('n', '<C-j>', ':move+<cr>', { noremap = true, silent = true })
set('n', '<C-h>', '<<', { noremap = true })
set('n', '<C-l>', '>>', { noremap = true })
set('x', '<C-k>', ':move-2<cr>gv', { noremap = true, silent = true })
set('x', '<C-j>', ':move\'>+<cr>gv', { noremap = true, silent = true })
set('v', '<C-l>', '>gv', { noremap = true })
set('v', '<C-h>', '<gv', { noremap = true })
set('v', '<', '<gv', { noremap = true })
set('v', '>', '>gv', { noremap = true })

----------------------------------------------------------------------------
-- Window Controls | much like hjkl but using the g prefix
----------------------------------------------------------------------------
set('n', 'gh', '<C-w>h')
set('n', 'gj', '<C-w>j')
set('n', 'gk', '<C-w>k')
set('n', 'gl', '<C-w>l')
set('n', '<down>', ':res +4<CR>')
set('n', '<up>', ':res -4<CR>')
set('n', '<right>', '4<C-W>>')
set('n', '<left>', '4<C-W><')
set('n', '<C-w>-', ':sp<CR>')
set('n', '<C-w>\\', ':vsp<CR>')

set('n', 'ygr', function()
  local root = vim.fn.trim(vim.fn.system {
    'git', '-C', vim.fn.getcwd(), 'rev-parse', '--show-toplevel'
  })
  vim.fn.setreg('+', root)
  vim.cmd.echo('"Yanked ' .. root .. '"')
end, { silent = true })

set('n', 'ycd', function()
  local cwd = vim.fn.expand("%:h")
  vim.fn.setreg('+', cwd)
  vim.cmd.echo('"Yanked ' .. cwd .. '"')
end, { silent = true })

set('n', 'ycf', function()
  local cwd = vim.fn.expand("%")
  vim.fn.setreg('+', cwd)
  vim.cmd.echo('"Yanked ' .. cwd .. '"')
end, { silent = true })

set('i', '<c-/>', function()
  local hl = helpers.hl()
  if hl == "markdownCode" then
    return '¯\\\\\\_(ツ)\\_/¯'
  end
  return "¯\\_(ツ)_/¯"
end, { expr = true })
