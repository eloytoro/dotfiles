local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local action = wezterm.action

local function concat(...)
  local result = {}
  for _, tb in ipairs({...}) do
    for _, v in ipairs(tb) do
      table.insert(result, v)
    end
  end
  return result
end

config.leader = { key = '\\', mods = 'CTRL', timeout_milliseconds = 1000 }
config.window_decorations = "NONE"

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.3,
}

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.font_size = 14

local tmux_keys = {
  {
    key = '-',
    mods = 'ALT',
    action = action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = '\\',
    mods = 'ALT',
    action = action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '[',
    mods = 'ALT',
    action = action.ActivateTabRelative(-1),
  },
  {
    key = ']',
    mods = 'ALT',
    action = action.ActivateTabRelative(1),
  },
  {
    key = 'h',
    mods = 'ALT|SHIFT',
    action = action.AdjustPaneSize {"Left", 5}
  },
  {
    key = 'l',
    mods = 'ALT|SHIFT',
    action = action.AdjustPaneSize {"Right", 5}
  },
  {
    key = 'k',
    mods = 'ALT|SHIFT',
    action = action.AdjustPaneSize {"Up", 1}
  },
  {
    key = 'j',
    mods = 'ALT|SHIFT',
    action = action.AdjustPaneSize {"Down", 1}
  },
  {
    key = 'h',
    mods = 'ALT',
    action = action.ActivatePaneDirection "Left"
  },
  {
    key = 'l',
    mods = 'ALT',
    action = action.ActivatePaneDirection "Right"
  },
  {
    key = 'k',
    mods = 'ALT',
    action = action.ActivatePaneDirection "Up"
  },
  {
    key = 'j',
    mods = 'ALT',
    action = action.ActivatePaneDirection "Down"
  },
  {
    key = 't',
    mods = 'ALT',
    action = action.SpawnTab "DefaultDomain"
  },
  {
    key = 't',
    mods = 'ALT|SHIFT',
    action = wezterm.action_callback(function(_, pane)
      local tab, _ = pane:move_to_new_tab()
      tab:activate()
    end),
  },
  {
    key = 'Enter',
    mods = 'ALT',
    action = action.ToggleFullScreen,
  },
}

local darwin_keys = {
  {
    key = '-',
    mods = 'SUPER',
    action = action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = '\\',
    mods = 'SUPER',
    action = action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'h',
    mods = 'SUPER|SHIFT',
    action = action.AdjustPaneSize {"Left", 5}
  },
  {
    key = 'l',
    mods = 'SUPER|SHIFT',
    action = action.AdjustPaneSize {"Right", 5}
  },
  {
    key = 'k',
    mods = 'SUPER|SHIFT',
    action = action.AdjustPaneSize {"Up", 1}
  },
  {
    key = 'j',
    mods = 'SUPER|SHIFT',
    action = action.AdjustPaneSize {"Down", 1}
  },
  {
    key = 'h',
    mods = 'SUPER',
    action = action.ActivatePaneDirection "Left"
  },
  {
    key = 'l',
    mods = 'SUPER',
    action = action.ActivatePaneDirection "Right"
  },
  {
    key = 'k',
    mods = 'SUPER',
    action = action.ActivatePaneDirection "Up"
  },
  {
    key = 'j',
    mods = 'SUPER',
    action = action.ActivatePaneDirection "Down"
  },
  {
    key = 't',
    mods = 'SUPER|SHIFT',
    action = wezterm.action_callback(function(_, pane)
      local tab, _ = pane:move_to_new_tab()
      tab:activate()
    end),
  },
}

config.keys = concat(
  tmux_keys,
  {
    {
      key = '.',
      mods = 'ALT',
      action = wezterm.action.ShowLauncher,
    },
    {
      key = 'r',
      mods = 'ALT',
      action = action.RotatePanes 'Clockwise',
    },
    {
      key = 'z',
      mods = 'ALT',
      action = action.TogglePaneZoomState,
    },
    { key = 'b', mods = 'ALT|SHIFT', action = action.ScrollByPage(-0.5) },
    { key = 'f', mods = 'ALT|SHIFT', action = action.ScrollByPage(0.5) },
    { key = 'k', mods = 'ALT|SHIFT', action = action.ScrollByLine(-1) },
    { key = 'j', mods = 'ALT|SHIFT', action = action.ScrollByLine(1) },
    { key = 'g', mods = 'ALT|SHIFT', action = action.ScrollToBottom },
  }
)

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

local known_process = {
  "zsh",
  "nvim",
  "yazi"
}

local function is_known_process(process)
  for _, p in ipairs(known_process) do
    if process == p then
      return true
    end
  end
  return false
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local active_pane = tab.active_pane
    local rules = {}
    if tab.is_active then
      local process = basename(active_pane.foreground_process_name)
      if is_known_process(process) then
        table.insert(rules, { Text = basename(active_pane.current_working_dir) })
      else
        table.insert(rules, { Text = process })
      end
    else
      for _, pane in ipairs(tab.panes) do
        if pane.has_unseen_output and not is_known_process(basename(pane.foreground_process_name)) then
          table.insert(rules, { Foreground = { Color = '#fab387' } })
          break
        end
      end
      table.insert(rules, { Text = basename(active_pane.current_working_dir) })
    end
    return rules
  end
)

return config
