local wezterm = require("wezterm")

local M = {}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

function M.setup()
    wezterm.on("format-tab-title", function(tab)
        local background = tab.is_active and "#aacf53" or "#5c6d74"
        local foreground = tab.is_active and "#000000" or "#FFFFFF"

        -- 未読出力があるかチェック（常に出力があるプロセスは除外）
        local has_unseen_output = false
        local ignore_processes = { "claude", "lazygit" }
        for _, pane in ipairs(tab.panes) do
            if pane.has_unseen_output then
                local process = pane.foreground_process_name or ""
                local should_ignore = false
                for _, ignore in ipairs(ignore_processes) do
                    if string.match(process, ignore) then
                        should_ignore = true
                        break
                    end
                end
                if not should_ignore then
                    has_unseen_output = true
                    break
                end
            end
        end

        local title = tab.active_pane.title
        if title == "" then title = "-" end
        if has_unseen_output and not tab.is_active then
            title = title .. " 💡"
        end

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
