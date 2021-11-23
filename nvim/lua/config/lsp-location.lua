local api = vim.api
local util = vim.lsp.util
local handlers = vim.lsp.handlers
local log = vim.lsp.log

local function starts_with(str, start)
  return string.sub(str, 1, string.len(start)) == start
end

local function handle_location(location)
  local uri = location.uri or location.targetUri
  local name = string.gsub(uri, "file://", "")
  local bufnr = vim.fn.bufnr(name)
  local winid = vim.fn.win_findbuf(bufnr)
  print(#winid, winid[1], bufnr)
  if #winid > 0 then
    vim.fn.win_gotoid(winid[1])
  else
    api.nvim_command('tabnew')
    local buf = api.nvim_get_current_buf()
    util.jump_to_location(location)
    api.nvim_command(buf .. 'bd')
  end
end

local function location_callback(_, result, ctx, _)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(ctx.method, 'No location found')
    return nil
  end

  if vim.tbl_islist(result) then
    handle_location(result[1])

    if #result > 1 then
      util.set_qflist(util.locations_to_items(result))
      api.nvim_command("copen")
    end
  else
    handle_location(result)
  end
end

handlers['textDocument/declaration']    = location_callback
handlers['textDocument/definition']     = location_callback
handlers['textDocument/typeDefinition'] = location_callback
handlers['textDocument/implementation'] = location_callback
