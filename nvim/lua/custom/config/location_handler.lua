local api = vim.api
local util = vim.lsp.util
local handlers = vim.lsp.handlers

---https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/handlers.lua

---@private
--- Jumps to a location. Used as a handler for multiple LSP methods.
---@param _ (not used)
---@param result (table) result of LSP method; a location or a list of locations.
---@param ctx (table) table containing the context of the request, including the method
---(`textDocument/definition` can return `Location` or `Location[]`
local function location_handler(_, result, ctx, config)
  if result == nil or vim.tbl_isempty(result) then
    vim.cmd.echo('No location found')
    return nil
  end
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client == nil then
    return nil
  end

  config = config or {}

  -- textDocument/definition can return Location or Location[]
  -- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_definition

  if vim.tbl_islist(result) then
    local title = 'LSP locations'
    local items = util.locations_to_items(result, client.offset_encoding)

    if config.on_list then
      assert(type(config.on_list) == 'function', 'on_list is not a function')
      config.on_list({ title = title, items = items })
    else
      -- if #result == 1 then
      --   util.jump_to_location(result[1], client.offset_encoding, config.reuse_win)
      --   return
      -- end
      vim.fn.setqflist({}, ' ', { title = title, items = items })
      api.nvim_command('botright copen')
    end
  else
    vim.fn.setqflist({}, ' ', { title = 'Location', items = {result} })
    api.nvim_command('botright copen')
    -- util.jump_to_location(result, client.offset_encoding, config.reuse_win)
  end
end

handlers['textDocument/declaration']    = location_handler
handlers['textDocument/definition']     = location_handler
handlers['textDocument/typeDefinition'] = location_handler
handlers['textDocument/implementation'] = location_handler
