-- Pull in the wezTerm API
local wezterm = require("wezterm")

-- Use the wezterm config builder for Neovim-style setup
local config = wezterm.config_builder()

-- Platform-specific default program
local default_prog
local window_decorations

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  -- Windows configuration
  default_prog = {"powershell.exe"}
  window_decorations = "TITLE | RESIZE"
elseif wezterm.target_triple == "x86_64-apple-darwin" then
  -- macOS configuration
  default_prog = {"/bin/zsh"} -- Or another shell of your choice
  window_decorations = "RESIZE"
end

-- Core configuration settings
config = {
  -- Prevent window resizing when font size changes to keep dimensions consistent
  adjust_window_size_when_changing_font_size = false,

  -- Automatically reload configuration when the file changes
  automatically_reload_config = true,

  -- Set color scheme to Catppuccin Mocha for a visually appealing theme
  color_scheme = "Catppuccin Mocha",

  -- Set cursor blink behavior with easing functions
	cursor_blink_ease_in = "Constant",
  cursor_blink_ease_out = "Constant",
  -- Optional: Define cursor blink rate in milliseconds
	-- cursor_blink_rate = 500,
  default_cursor_style = "BlinkingBar",
  
  -- Apply the platform-specific default program
  default_prog = default_prog,

  -- Disable the tab bar since this configuration doesn't use multiple tabs
  enable_tab_bar = false,

  -- Set the terminal font to JetBrains Mono with a bold weight for better readability
  font = wezterm.font("JetBrains Mono", { weight = "Bold"}),
  -- Set a comfortable font size for readability
  font_size = 16.0,

  -- Set a blurred effect for the macOS window background
	macos_window_background_blur = 30,

  -- Disable native macOS fullscreen to allow more flexible window management
  native_macos_fullscreen_mode = false,

  -- Set window opacity
  window_background_opacity = 0.90,

  -- Limit window decorations to only resizing to create a minimalistic look
  window_close_confirmation = "NeverPrompt",

  -- Disable all window decorations except resize
  window_decorations = window_decorations,

  -- Define padding around the terminal content for visual comfort
	window_padding = {
		left = 8,
		right = 8,
		top = 8,
		bottom = 8,
	},
}

-- Return the configuration to wezTerm
return config
