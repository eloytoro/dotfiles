-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<Esc>', '<C-\\><C-n>', { noremap = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


-- map <F2> :so $MYVIMRC<CR>
vim.keymap.set('n', '_', 'O<Esc>')
vim.keymap.set('n', '-', 'o<Esc>')
vim.keymap.set('n', 'Q', '@q', { noremap = true })
-- nmap <leader>q :cope<CR>
-- nmap cd :cd %:p:h<CR>
vim.keymap.set('n', '<Tab>', 'gt', { noremap = true })
vim.keymap.set('n', '<S-Tab>', 'gT', { noremap = true })
vim.keymap.set('n', '<c-i>', '<Tab>', { noremap = true })
-- vim.keymap.set('n', '<silent>', '<M-n> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>', { noremap = true })
-- vim.keymap.set('n', '<silent>', '<M-p> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>', { noremap = true })
vim.keymap.set('', '<C-b>', '<C-U>')
vim.keymap.set('', '<C-f>', '<C-D>')
vim.keymap.set('o', 'H', '^', { noremap = true })
vim.keymap.set('o', 'L', '$', { noremap = true })
vim.keymap.set('n', 'H', '^', { noremap = true })
vim.keymap.set('n', 'L', '$', { noremap = true })
vim.keymap.set('v', 'H', '^', { noremap = true })
vim.keymap.set('v', 'L', '$', { noremap = true })
vim.keymap.set('n', 'Y', 'y$', { noremap = true })
vim.keymap.set('i', '<c-t>', '<C-R>=strftime("%c")<CR>', { noremap = true })
vim.keymap.set('i', '<c-l>', '<space>=><space>', { noremap = true })
-- vim.keymap.set('c', '<expr>', '%% expand(\'%:h\').'/'', { noremap = true })
-- vim.keymap.set('c', '<expr>', '!! expand(\'%:p\')', { noremap = true })
-- vim.keymap.set('c', '<expr>', '@@ expand(\'%:p:h\').'/'', { noremap = true })
vim.keymap.set('n', ']b', ':bn<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '[b', ':bp<CR>', { noremap = true, silent = true })
vim.keymap.set('n', ']q', ':cn<CR>zz', { noremap = true, silent = true })
vim.keymap.set('n', '[q', ':cp<CR>zz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-t>', ':tabnew<cr>', { noremap = true })
vim.keymap.set('i', '<C-s>', '<C-O>:update<cr>', { noremap = true })
vim.keymap.set('n', '<C-s>', ':update<cr>', { noremap = true })
vim.keymap.set('i', '<C-Q>', '<esc>:q<cr>', { noremap = true })
vim.keymap.set('n', '<C-Q>', ':q<cr>', { noremap = true })
vim.keymap.set('i', '<C-e>', '<End>', { noremap = true })
vim.keymap.set('i', '<C-a>', '<Home>', { noremap = true })

----------------------------------------------------------------------------
--   Moving lines | for quick line swapping purposes
----------------------------------------------------------------------------
vim.keymap.set('n', '<C-k>', ':move-2<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', ':move+<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-h>', '<<', { noremap = true })
vim.keymap.set('n', '<C-l>', '>>', { noremap = true })
vim.keymap.set('x', '<C-k>', ':move-2<cr>gv', { noremap = true, silent = true })
vim.keymap.set('x', '<C-j>', ':move\'>+<cr>gv', { noremap = true, silent = true })
vim.keymap.set('v', '<C-l>', '>gv', { noremap = true })
vim.keymap.set('v', '<C-h>', '<gv', { noremap = true })
vim.keymap.set('v', '<', '<gv', { noremap = true })
vim.keymap.set('v', '>', '>gv', { noremap = true })

----------------------------------------------------------------------------
-- Window Controls | much like hjkl but using the g prefix
----------------------------------------------------------------------------
vim.keymap.set('n', 'gh', '<C-w>h')
vim.keymap.set('n', 'gj', '<C-w>j')
vim.keymap.set('n', 'gk', '<C-w>k')
vim.keymap.set('n', 'gl', '<C-w>l')
vim.keymap.set('n', '<down>', ':res +4<CR>')
vim.keymap.set('n', '<up>', ':res -4<CR>')
vim.keymap.set('n', '<right>', '4<C-W>>')
vim.keymap.set('n', '<left>', '4<C-W><')
vim.keymap.set('n', '<C-w>-', ':sp<CR>')
vim.keymap.set('n', '<C-w>\\', ':vsp<CR>')

vim.keymap.set('n', 'ygr', function()
  local root = vim.fn.trim(vim.fn.system {
    'git', '-C', vim.fn.getcwd(), 'rev-parse', '--show-toplevel'
  })
  vim.fn.setreg('+', root)
  vim.cmd.echo('"Yanked '..root..'"')
end, { silent = true })

vim.keymap.set('n', 'ycd', function()
  local cwd = vim.fn.expand("%:h")
  vim.fn.setreg('+', cwd)
  vim.cmd.echo('"Yanked '..cwd..'"')
end, { silent = true })

vim.keymap.set('n', 'ycf', function()
  local cwd = vim.fn.expand("%")
  vim.fn.setreg('+', cwd)
  vim.cmd.echo('"Yanked '..cwd..'"')
end, { silent = true })
