local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "tokyonight"
config.font = wezterm.font("CommitMono Nerd Font")
config.font_size = 14
config.line_height = 1.1

config.window_decorations = "RESIZE"
config.show_tab_index_in_tab_bar = false

config.colors = {
	tab_bar = {
		background = "#222333",

		active_tab = {
			bg_color = "#1a1b26",
			fg_color = "#fcfcfc",
		},
		inactive_tab = {
			bg_color = "#222333",
			fg_color = "#707070",
		},
		inactive_tab_hover = {
			bg_color = "#1f2030",
			fg_color = "#707070",
		},
		new_tab = {
			bg_color = "#222333",
			fg_color = "#707070",
		},
		new_tab_hover = {
			bg_color = "#1f2030",
			fg_color = "#707070",
		},
	},
}

config.window_frame = {
	inactive_titlebar_bg = "#2d2f44",
	inactive_titlebar_fg = "#cccccc",
	active_titlebar_bg = "#222333",
	active_titlebar_fg = "#ffffff",
}

return config
