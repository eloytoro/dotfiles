return {
  {
    'folke/sidekick.nvim',
    keys = {
        -- Example of a keybinding to open Claude directly
        {
          "<leader>ac",
          function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
          desc = "Sidekick Toggle Claude",
        },
    }
  }
}
