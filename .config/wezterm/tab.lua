local wezterm = require("wezterm")

local M = {}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

function M.setup()
    wezterm.on("format-tab-title", function(tab)
        local background = tab.is_active and "#aacf53" or "#5c6d74"
        local foreground = tab.is_active and "#000000" or "#FFFFFF"

        local title = tab.active_pane.title
        if title == "" then title = "-" end

        return {
            { Background = { Color = "none" } },
            { Foreground = { Color = background } },
            { Text = SOLID_LEFT_ARROW },
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Text = " " .. title .. " " },
            { Background = { Color = "none" } },
            { Foreground = { Color = background } },
            { Text = SOLID_RIGHT_ARROW },
        }
    end)
end

return M
