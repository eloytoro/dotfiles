local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local action = wezterm.action

config.leader = { key = '\\', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
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
    key = 'r',
    mods = 'ALT',
    action = action.RotatePanes 'Clockwise',
  },
  {
    key = 'z',
    mods = 'ALT',
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    key = 'Enter',
    mods = 'ALT',
    action = wezterm.action.ToggleFullScreen,
  },
  {
    key = 't',
    mods = 'ALT|SHIFT',
    action = wezterm.action_callback(function(win, pane)
      local tab, window = pane:move_to_new_tab()
      tab:activate()
    end),
  },
}

return config
