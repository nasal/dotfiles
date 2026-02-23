local wezterm = require 'wezterm'
local act = wezterm.action
local sessions = wezterm.plugin.require("https://github.com/abidibo/wezterm-sessions")

local is_darwin = function()
  return wezterm.target_triple:find("darwin") ~= nil
end

local is_linux = function()
  return wezterm.target_triple:find("linux") ~= nil
end

local is_windows = function()
  return wezterm.target_triple:find("windows") ~= nil
end

local function basename(path)
  if not path or path == "" then
    return ""
  end
  return path:gsub("/+$", ""):match("([^/]+)$") or path
end

local function cwd_basename(pane)
  -- current_working_dir is typically a URI like "file:///Users/me/project"
  local cwd = pane and pane.current_working_dir
  if not cwd then
    return ""
  end

  local s = tostring(cwd)

  -- WezTerm returns a URI; parse and decode it
  local url = wezterm.url.parse(s)
  local path = url and url.file_path or s

  return basename(path)
end

local function truncate_left(s, max_width)
  local len = wezterm.column_width(s)
  if len <= max_width then
    return s
  end

  local ellipsis = "…"
  local ellipsis_width = wezterm.column_width(ellipsis)
  local target = max_width - ellipsis_width

  -- Remove characters from the start until it fits
  local i = 1
  while i <= #s do
    local char_start = i
    -- Skip UTF-8 continuation bytes
    while i <= #s and s:byte(i) >= 0x80 and s:byte(i) < 0xC0 do
      i = i + 1
    end
    i = i + 1

    local trimmed = s:sub(char_start)
    if wezterm.column_width(trimmed) <= target then
      return ellipsis .. trimmed
    end
  end

  return ellipsis
end

local function shorten_cwd(pane)
  local user_vars = pane.user_vars or {}
  local path = ""
  local home = ""

  -- Try user vars first (WSL)
  if user_vars.WEZTERM_CWD and user_vars.WEZTERM_CWD ~= "" then
    path = user_vars.WEZTERM_CWD
    home = user_vars.WEZTERM_HOME or ""
  else
    -- Fallback to native (macOS/Linux)
    local cwd = pane and pane.current_working_dir
    if cwd then
      local s = tostring(cwd)
      local url = wezterm.url.parse(s)
      if url then
        path = url.file_path or ""
      end
    end
    home = wezterm.home_dir or os.getenv("HOME") or ""
  end

  -- Skip Windows paths
  if path:match("^/[A-Za-z]:") or path:match("%.exe") then
    return ""
  end

  if path == "" then
    return ""
  end

  path = path:gsub("/+$", "")
  home = home:gsub("/+$", "")

  if home ~= "" then
    if path == home then
      return "~"
    elseif path:sub(1, #home + 1) == home .. "/" then
      return "~" .. path:sub(#home + 1)
    end
  end

  return path
end

local function proc_name(pane)
  local user_vars = pane.user_vars or {}

  -- Try user var first (WSL)
  local user_prog = user_vars.WEZTERM_PROG
  if user_prog and user_prog ~= "" then
    return user_prog:match("([^/]+)$") or user_prog
  end

  local p = pane and pane.foreground_process_name or ""

  -- Skip Windows paths (WSL) - default to bash
  if p:match("^[A-Za-z]:") or p:match("%.exe$") then
    return "bash"
  end

  if p ~= "" then
    return p:match("([^/]+)$") or p
  end

  return ""
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local FIXED = 30

  local pane = tab.active_pane
  local id = (tab.tab_index or 0) + 1

  -- 1) custom tab title (set_title)
  local custom = tab.tab_title or ""

  -- 2) path (fallback if no custom title)
  local path = shorten_cwd(pane)

  -- 3) process
  local proc = proc_name(pane)

  local main = custom
  if main == "" then
    main = path
  end
  if main == "" then
    main = "Tab " .. tostring(id)
  end

  -- Calculate fixed parts: "{id}: " and " ({proc})"
  local prefix = string.format("%d: ", id)
  local suffix = proc ~= "" and string.format(" (%s)", proc) or ""

  local prefix_width = wezterm.column_width(prefix)
  local suffix_width = wezterm.column_width(suffix)

  -- Available space for the main part (path/title)
  local available = FIXED - prefix_width - suffix_width

  -- Truncate path from the left if too long
  if available > 0 then
    main = truncate_left(main, available)
  else
    main = "…"
  end

  local title = prefix .. main .. suffix

  -- Pad to fixed width
  title = wezterm.pad_right(title, FIXED)

  return { { Text = title } }
end)

wezterm.on('augment-command-palette', function(window, pane)
  return {
    {
      brief = 'Rename tab',
      icon = 'md_rename_box',

      action = act.PromptInputLine {
        description = 'Enter new name for tab',
        initial_value = '',
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      },
    },
  }
end)

local config = wezterm.config_builder()

if is_windows() then
  config.default_prog = { "ubuntu.exe" }
  config.default_cwd = "/home/nasal"
  config.font = wezterm.font("Cascadia Mono")
  -- config.font = wezterm.font 'CaskaydiaMono Nerd Font'
end

if is_darwin() then
  config.default_cwd = "/Users/Skejgo"
  config.font = wezterm.font("Firacode Nerd Font")
end

-- config.show_tab_index_in_tab_bar = true
-- config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'

-- config.line_height = 1
config.animation_fps = 1

config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.cursor_blink_rate = 600

config.initial_cols = 120
config.initial_rows = 30
config.font_size = 15
config.color_scheme = 'OneHalfDark'

config.window_frame = {
  font = wezterm.font { family = 'Roboto', weight = 'Bold' },
  font_size = 13,
  inactive_titlebar_bg = '#333333',
  border_top_height = '0.3cell',
  border_top_color = '#333333',
  border_left_width = '0.3cell',
}

config.colors = {
  tab_bar = {
    active_tab = {
      bg_color = '#282c34',
      fg_color = '#ffffff',
    },
    inactive_tab_edge = '#333333',
  },
}

config.keys = {
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
}

sessions.apply_to_config(config, {
  auto_save_interval_s = 30,
})

return config
