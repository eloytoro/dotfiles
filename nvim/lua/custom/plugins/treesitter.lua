return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    lazy = 'false',
    config = function()
      vim.cmd 'autocmd BufRead,BufNewFile *.mdx set filetype=markdown'
      -- [[ Configure Treesitter ]]
      -- See `:help nvim-treesitter`
      require('nvim-treesitter').install { 'rust', 'javascript', 'zig', 'typescript' }
    end
  },
}
