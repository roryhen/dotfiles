local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "tokyonight"
config.font = wezterm.font("CommitMono Nerd Font")
config.font_size = 14
config.line_height = 1.1

config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = false
config.show_tab_index_in_tab_bar = false

local light_black = wezterm.color.parse("Black"):lighten(0.15)
local lighter_black = wezterm.color.parse("Black"):lighten(0.2)
-- Ansi colors: Black, Maroon, Green, Olive, Navy, Purple, Teal, Silver, Grey, Red, Lime, Yellow, Blue, Fuchsia, Aqua, White
config.colors = {
	tab_bar = {
		background = light_black,

		active_tab = {
			bg_color = "Black",
			fg_color = "White",
		},
		inactive_tab = {
			bg_color = light_black,
			fg_color = "Grey",
		},
		inactive_tab_hover = {
			bg_color = lighter_black,
			fg_color = "Grey",
		},
		new_tab = {
			bg_color = light_black,
			fg_color = "Grey",
		},
		new_tab_hover = {
			bg_color = lighter_black,
			fg_color = "Grey",
		},
	},
}

wezterm.on("format-tab-title", function(tab)
	local title = tab.tab_title
	if not title or #title <= 0 then
		title = tab.active_pane.title
	end
	-- pad to 6 characters
	if #title < 6 then
		title = title .. string.rep(" ", 6 - #title)
	end
	return {
		{ Text = " " .. title .. " " },
	}
end)

wezterm.on("update-status", function(window)
	local date = wezterm.strftime("%H:%M")
	local leader_text = " "
	if window:leader_is_active() then
		leader_text = " "
	end

	window:set_left_status(wezterm.format({
		{ Foreground = { AnsiColor = "Black" } },
		{ Background = { AnsiColor = "Blue" } },
		{ Text = " " .. leader_text .. " " },
	}))

	window:set_right_status(wezterm.format({
		{ Text = " " .. date .. " " },
	}))
end)

return config
