local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- モジュール読み込み
require("tab").setup()
require("keybinds").setup(config)

-- Shell
config.default_prog = { "/bin/zsh", "-l" }

-- Font
config.font_size = 14
config.font = wezterm.font_with_fallback({
    { family = "UDEV Gothic 35NF", weight = "Regular" },
})
config.font_rules = {
    {
        italic = true,
        font = wezterm.font({ family = "UDEV Gothic 35NF", style = "Italic" }),
    },
    {
        intensity = "Bold",
        font = wezterm.font({ family = "UDEV Gothic 35NF", weight = "Bold" }),
    },
    {
        intensity = "Bold",
        italic = true,
        font = wezterm.font({ family = "UDEV Gothic 35NF", weight = "Bold", style = "Italic" }),
    },
}
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0", "dlig=0" }

-- IME
config.use_ime = true

-- Window
config.color_scheme = "midnight-in-mojave"
config.window_decorations = "TITLE | RESIZE"
config.native_macos_fullscreen_mode = true
-- 背景の非透過率（1なら完全に透過させない）
config.window_background_opacity = 0.80
-- 背景をぼかす
config.macos_window_background_blur = 20

-- タブが一つの時は非表示
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 50

config.colors = {
  tab_bar = {
    background = "none",
  },
}

-- タブバーを背景色に合わせる
config.window_background_gradient = {
  colors = { "#000000" },
}

-- Pane
-- 非アクティブなペインを暗くする
config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.6,
}
-- アクティブなペインのボーダー色
config.colors.split = "#aacf53"

config.show_new_tab_button_in_tab_bar = false

-- Clipboard
config.selection_word_boundary = " \t\n{}[]()\"'`,;:"

-- Behavior
config.quit_when_all_windows_are_closed = true
config.check_for_updates = true
config.window_close_confirmation = "AlwaysPrompt"

return config
