return {
  'svermeulen/vim-yoink',
  dependencies = {
    'svermeulen/vim-cutlass',
    'svermeulen/vim-subversive',
  },
  init = function()
    vim.g.yoinkIncludeDeleteOperations = 1
  end,
  config = function()
    vim.keymap.set('n', 's', '<plug>(SubversiveSubstitute)')
    vim.keymap.set('n', 'ss', '<plug>(SubversiveSubstituteLine)')
    vim.keymap.set('n', 'S', '<plug>(SubversiveSubstituteToEndOfLine)')
    vim.keymap.set('x', 'p', '<plug>(SubversiveSubstitute)')
    vim.keymap.set('x', 'P', '<plug>(SubversiveSubstitute)')
    vim.keymap.set('x', 's', '<plug>(SubversiveSubstituteRangeConfirm)')
    vim.keymap.set('n', '<leader>s', '<plug>(SubversiveSubstituteRange)')
    vim.keymap.set('n', '<leader>s', '<plug>(SubversiveSubstituteRangeConfirm)')
    vim.keymap.set('n', '[y', '<plug>(YoinkRotateBack)')
    vim.keymap.set('n', ']y', '<plug>(YoinkRotateForward)')
    vim.keymap.set('n', ']p', '<plug>(YoinkPostPasteSwapBack)')
    vim.keymap.set('n', '[p', '<plug>(YoinkPostPasteSwapForward)')
    vim.keymap.set('n', 'p', '<plug>(YoinkPaste_p)')
    vim.keymap.set('n', 'P', '<plug>(YoinkPaste_P)')
    vim.keymap.set('n', 'm', 'd', { noremap = true })
    vim.keymap.set('x', 'm', 'd', { noremap = true })
    vim.keymap.set('n', 'mm', 'dd', { noremap = true })
    vim.keymap.set('n', 'M', 'D', { noremap = true })
  end
}
