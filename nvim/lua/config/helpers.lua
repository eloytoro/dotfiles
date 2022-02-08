local M = {}

function M.starts_with(str, start)
   return str:sub(1, #start) == start
end

-- Concat the contents of the parameter list,
-- separated by the string delimiter (just like in perl)
-- example: strjoin(", ", {"Anna", "Bob", "Charlie", "Dolores"})
function M.strjoin(delimiter, list)
  local len = getn(list)
  if len == 0 then
    return "" 
  end
  local string = list[1]
  for i = 2, len do 
    string = string .. delimiter .. list[i] 
  end
  return string
end

-- Split text into a list consisting of the strings in text,
-- separated by strings matching delimiter (which may be a pattern). 
-- example: strsplit(",%s*", "Anna, Bob, Charlie,Dolores")
function M.strsplit(delimiter, text)
  local list = {}
  local pos = 1
  if strfind("", delimiter, 1) then -- this would result in endless loops
    error("delimiter matches empty string!")
  end
  while 1 do
    local first, last = strfind(text, delimiter, pos)
    if first then -- found?
      table.insert(list, strsub(text, pos, first-1))
      pos = last+1
    else
      table.insert(list, strsub(text, pos))
      break
    end
  end
  return list
end

-- Split text into a list consisting of the strings in text,
-- separated by strings matching delimiter (which may be a pattern). 
-- example: strsplit(",%s*", "Anna, Bob, Charlie,Dolores")
function M.strsplit_once(delimiter, text)
  if string.find("", delimiter, 1) then -- this would result in endless loops
    error("delimiter matches empty string!")
  end
  local first, last = string.find(text, delimiter, 1, true)
  if first and last then -- found?
    local list = {}
    list[0] = string.sub(text, 1, first-1)
    list[1] = string.sub(text, last+1)
    return list
  end
  return nil
end

function M.denormalize_json(json)
  -- if type(json) ~= "table" then
  --   return json
  -- end
  local result = {}
  for k, v in pairs(json) do
    local parts = M.strsplit_once(".", k)
    if parts ~= nil then
      if (result[parts[0]] == nil) then
        result[parts[0]] = {}
      end
      result[parts[0]][parts[1]] = v
    else
      result[k] = v
    end
  end
  return result
end

function M.read_local_editor_config(args)
  local conf = {}
  local file = require("plenary.path"):new(".vscode/settings.json")
  if not file:is_file() then
    return {}
  end
  local plain_text = file:read()
  local json_ok, result = pcall(vim.json.decode, plain_text)
  if not json_ok then
    return {}
  end
  return M.denormalize_json(result)
end

function M.assign(...)
  local r = {}
  for _, t in ipairs({...}) do
    if t then
      for k,v in pairs(t) do r[k] = v end
    end
  end
  return r
end

return M
