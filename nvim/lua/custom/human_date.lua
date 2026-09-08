local M = {}

local DEFAULT_HOUR = 9
local END_OF_DAY_HOUR = 18
local OUTPUT_FORMAT = '%Y-%m-%d %H:%M'

local weekdays = {
  sun = 1,
  sunday = 1,
  mon = 2,
  monday = 2,
  tue = 3,
  tues = 3,
  tuesday = 3,
  wed = 4,
  weds = 4,
  wednesday = 4,
  thu = 5,
  thur = 5,
  thurs = 5,
  thursday = 5,
  fri = 6,
  friday = 6,
  sat = 7,
  saturday = 7,
}

local function normalize(text)
  return (text:lower():gsub('a%.m%.', 'am'):gsub('p%.m%.', 'pm'):gsub('^%s+', ''):gsub('%s+$', ''):gsub('%s+', ' '))
end

local function clock(hour, minute, second)
  return { hour = hour, minute = minute or 0, second = second or 0 }
end

local function parse_clock(text)
  local start_index, end_index
  local hour, minute, meridiem

  start_index, end_index = text:find('%f[%a]end of day%f[%A]')
  if not start_index then
    start_index, end_index = text:find('%f[%a]eod%f[%A]')
  end
  if start_index then
    return clock(END_OF_DAY_HOUR), normalize(text:sub(1, start_index - 1) .. ' ' .. text:sub(end_index + 1))
  end

  start_index, end_index = text:find('%f[%a]noon%f[%A]')
  if start_index then
    return clock(12), normalize(text:sub(1, start_index - 1) .. ' ' .. text:sub(end_index + 1))
  end

  start_index, end_index = text:find('%f[%a]midnight%f[%A]')
  if start_index then
    return clock(0), normalize(text:sub(1, start_index - 1) .. ' ' .. text:sub(end_index + 1))
  end

  start_index, end_index, hour, minute, meridiem = text:find('(%d%d?):(%d%d)%s*([ap]m)')
  if not start_index then
    start_index, end_index, hour, meridiem = text:find('(%d%d?)%s*([ap]m)')
    minute = '0'
  end
  if start_index then
    hour, minute = tonumber(hour), tonumber(minute)
    if hour < 1 or hour > 12 or minute > 59 then
      return nil, nil, 'Invalid 12-hour time'
    end
    if meridiem == 'am' then
      hour = hour == 12 and 0 or hour
    else
      hour = hour == 12 and 12 or hour + 12
    end
    return clock(hour, minute), normalize(text:sub(1, start_index - 1) .. ' ' .. text:sub(end_index + 1))
  end

  start_index, end_index, hour, minute = text:find('(%d%d?):(%d%d)')
  if start_index then
    hour, minute = tonumber(hour), tonumber(minute)
    if hour > 23 or minute > 59 then
      return nil, nil, 'Invalid 24-hour time'
    end
    return clock(hour, minute), normalize(text:sub(1, start_index - 1) .. ' ' .. text:sub(end_index + 1))
  end

  return nil, text
end

local function at_date(date, time)
  return os.time {
    year = date.year,
    month = date.month,
    day = date.day,
    hour = time.hour,
    min = time.minute,
    sec = time.second,
  }
end

local function days_after(date, count)
  return {
    year = date.year,
    month = date.month,
    day = date.day + count,
  }
end

local function valid_exact_date(year, month, day, timestamp)
  local actual = os.date('*t', timestamp)
  return actual.year == year and actual.month == month and actual.day == day
end

function M.parse(text, now)
  text = normalize(text or '')
  if text == '' then
    return nil, 'Enter a date or time'
  end

  now = now or os.time()
  local current = os.date('*t', now)
  local time, date_text, clock_error = parse_clock(text)
  if clock_error then
    return nil, clock_error
  end

  date_text = normalize(date_text:gsub('^at%s+', ''):gsub('%s+at$', ''))
  local has_explicit_time = time ~= nil
  time = time or clock(DEFAULT_HOUR)

  if date_text == 'now' then
    if has_explicit_time then
      return nil, 'Use a time by itself instead of combining it with "now"'
    end
    return now
  end

  local year, month, day = date_text:match('^(%d%d%d%d)%-(%d%d?)%-(%d%d?)$')
  if year then
    year, month, day = tonumber(year), tonumber(month), tonumber(day)
    local timestamp = at_date({ year = year, month = month, day = day }, time)
    if not valid_exact_date(year, month, day, timestamp) then
      return nil, 'Invalid calendar date'
    end
    return timestamp
  end

  if date_text == 'today' then
    return at_date(current, time)
  end

  if date_text == 'tomorrow' then
    return at_date(days_after(current, 1), time)
  end

  local is_next = false
  local weekday_text = date_text:match('^next%s+(%a+)$')
  if weekday_text then
    is_next = true
  else
    weekday_text = date_text:match('^(%a+)$')
  end

  local target_weekday = weekdays[weekday_text]
  if target_weekday then
    local day_offset = (target_weekday - current.wday) % 7
    if is_next and day_offset == 0 then
      day_offset = 7
    end

    local timestamp = at_date(days_after(current, day_offset), time)
    if not is_next and timestamp <= now then
      timestamp = at_date(days_after(current, day_offset + 7), time)
    end
    return timestamp
  end

  if date_text == '' and has_explicit_time then
    local timestamp = at_date(current, time)
    if timestamp <= now then
      timestamp = at_date(days_after(current, 1), time)
    end
    return timestamp
  end

  return nil, 'Could not understand "' .. text .. '"'
end

function M.format(timestamp)
  return os.date(OUTPUT_FORMAT, timestamp)
end

function M.prompt_and_insert()
  local ok, input = pcall(vim.fn.input, 'Date/time: ')
  if not ok or input == '' then
    return
  end

  local timestamp, err = M.parse(input)
  if not timestamp then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  vim.api.nvim_put({ M.format(timestamp) }, 'c', true, true)
end

return M
