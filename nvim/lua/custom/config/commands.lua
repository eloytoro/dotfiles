local helpers = require 'custom.helpers';

vim.api.nvim_create_user_command("HL", function()
  print(helpers.hl())
end, {})
