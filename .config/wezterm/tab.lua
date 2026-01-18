local wezterm = require("wezterm")

local M = {}

-- 各タブの「ディレクトリ名」を記憶しておくテーブル
local title_cache = {}

-- git rootを取得する関数
local function get_git_root(cwd)
    local handle = io.popen("git -C '" .. cwd .. "' rev-parse --show-toplevel 2>/dev/null")
    if handle then
        local result = handle:read("*a")
        handle:close()
        if result and result ~= "" then
            return result:gsub("%s+$", ""):match("([^/]+)$")
        end
    end
    return nil
end

-- cwdからディレクトリ名を取得
local function get_dir_name(cwd)
    return cwd:match("([^/]+)/?$") or cwd
end

-- タブの装飾（Nerdfonts）
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

function M.setup()
    -- 作業ディレクトリをキャッシュ
    wezterm.on("update-status", function(window, pane)
        local pane_id = pane:pane_id()
        local cwd = pane:get_current_working_dir()
        if cwd then
            local path = cwd.file_path or cwd.path or tostring(cwd)
            -- git rootを取得、なければディレクトリ名
            local root = get_git_root(path)
            title_cache[pane_id] = root or get_dir_name(path)
        else
            title_cache[pane_id] = "-"
        end
    end)

    -- タブタイトル: git root名
    wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
        local background = "#5c6d74"
        local foreground = "#FFFFFF"
        local edge_background = "none"
        if tab.is_active then
            background = "#aacf53"
            foreground = "#000000"
        end
        local edge_foreground = background

        local pane = tab.active_pane
        local pane_id = pane.pane_id
        local cwd = title_cache[pane_id] or "-"

        local title = " " .. cwd .. " "

        return {
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = SOLID_LEFT_ARROW },
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Text = title },
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = SOLID_RIGHT_ARROW },
        }
    end)
end

return M
