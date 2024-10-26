-- Pull in the wezTerm API
local wezterm = require("wezterm")

local config = wezterm.config_builder()

config = {
  automatically_reload_config = true,

  color_scheme = "Catppuccin Mocha",

	cursor_blink_ease_in = "Constant",
  cursor_blink_ease_out = "Constant",
	-- cursor_blink_rate = 500,
  default_cursor_style = "BlinkingBar",

  hide_tab_bar_if_only_one_tab = true,

  font = wezterm.font("JetBrains Mono", { weight = "Bold"}),
  font_size = 16.0,

	macos_window_background_blur = 30,
  window_background_opacity = 0.90,

  window_close_confirmation = "NeverPrompt",

	window_padding = {
		left = 16,
		right = 16,
		top = 16,
		bottom = 16,
	},
}

-- Return the configuration to wezTerm
return config
