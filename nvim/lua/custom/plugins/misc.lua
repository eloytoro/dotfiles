return {
  'tpope/vim-repeat',
  'tpope/vim-surround',
  -- 'rcarriga/nvim-notify',
  'junegunn/gv.vim',
  'tpope/vim-rhubarb',
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = "ibl",
    event = 'VeryLazy'
  },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {}, event = 'VeryLazy' },
  'kyazdani42/nvim-web-devicons', -- file icons
  'tpope/vim-sleuth',             -- Detect tabstop and shiftwidth automatically
}
