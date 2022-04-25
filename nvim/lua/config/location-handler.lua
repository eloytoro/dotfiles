local api = vim.api
local util = vim.lsp.util
local handlers = vim.lsp.handlers
local log = vim.lsp.log

local function starts_with(str, start)
  return string.sub(str, 1, string.len(start)) == start
end

local function handle_location(location, offset_encoding)
  local uri = location.uri or location.targetUri
  local name = string.gsub(uri, "file://", "")
  local bufnr = vim.fn.bufnr(name)
  local winid = vim.fn.win_findbuf(bufnr)
  if #winid > 0 then
    vim.fn.win_gotoid(winid[1])
    util.jump_to_location(location, offset_encoding)
  else
    api.nvim_command('tabnew')
    local buf = api.nvim_get_current_buf()
    util.jump_to_location(location, offset_encoding)
    api.nvim_command(buf .. 'bd')
  end
end

---https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/handlers.lua
--
---@private
--- Jumps to a location. Used as a handler for multiple LSP methods.
---@param _ (not used)
---@param result (table) result of LSP method; a location or a list of locations.
---@param ctx (table) table containing the context of the request, including the method
---(`textDocument/definition` can return `Location` or `Location[]`
local function location_handler(_, result, ctx, _)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(ctx.method, 'No location found')
    return nil
  end
  local client = vim.lsp.get_client_by_id(ctx.client_id)

  -- textDocument/definition can return Location or Location[]
  -- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_definition

  if vim.tbl_islist(result) then
    handle_location(result[1], client.offset_encoding)

    if #result > 1 then
      vim.fn.setqflist({}, ' ', {
        title = 'LSP locations',
        items = util.locations_to_items(result, client.offset_encoding)
      })
      api.nvim_command("botright copen")
    end
  else
    handle_location(result, client.offset_encoding)
  end
end

handlers['textDocument/declaration']    = location_handler
handlers['textDocument/definition']     = location_handler
handlers['textDocument/typeDefinition'] = location_handler
handlers['textDocument/implementation'] = location_handler
