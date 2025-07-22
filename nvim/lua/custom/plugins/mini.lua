return {
  {
    "echasnovski/mini.nvim",
    config = function()
      local splitjoin = require "mini.splitjoin"
      splitjoin.setup()
    end,
  },
}
