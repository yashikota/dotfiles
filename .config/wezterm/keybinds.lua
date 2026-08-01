local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.setup(config)
    config.keys = {
        -- WezTerm tab navigation.
        {
            key = "Tab",
            mods = "CTRL",
            action = act.ActivateTabRelative(1),
        },
        {
            key = "Tab",
            mods = "CTRL|SHIFT",
            action = act.ActivateTabRelative(-1),
        },
        -- Do not let WezTerm's default pane navigation consume arrow keys.
        {
            key = "LeftArrow",
            mods = "CTRL|SHIFT",
            action = act.DisableDefaultAssignment,
        },
        {
            key = "RightArrow",
            mods = "CTRL|SHIFT",
            action = act.DisableDefaultAssignment,
        },
        {
            key = "UpArrow",
            mods = "CTRL|SHIFT",
            action = act.DisableDefaultAssignment,
        },
        {
            key = "DownArrow",
            mods = "CTRL|SHIFT",
            action = act.DisableDefaultAssignment,
        },
        -- Shift+↑: 前のプロンプトへ
        { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
        -- Shift+↓: 次のプロンプトへ
        { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
        -- Cmd+←: 前の単語へ
        {
            key = "LeftArrow",
            mods = "CMD",
            action = act.SendString("\x1bb"),
        },
        -- Cmd+→: 次の単語へ
        {
            key = "RightArrow",
            mods = "CMD",
            action = act.SendString("\x1bf"),
        },
        -- Cmd+Shift+c: 直前のコマンドと出力をコピー
        {
            key = "c",
            mods = "CMD|SHIFT",
            action = wezterm.action_callback(function(window, pane)
                -- コピーモードに入る
                window:perform_action(act.ActivateCopyMode, pane)

                -- 直前のInputゾーン（最後のコマンド）に移動
                window:perform_action(act.CopyMode({ MoveBackwardZoneOfType = "Input" }), pane)

                -- 1行上に移動してstarshipプロンプト行を含める
                window:perform_action(act.CopyMode("MoveUp"), pane)
                window:perform_action(act.CopyMode("MoveToStartOfLine"), pane)

                -- セル選択モードを開始
                window:perform_action(act.CopyMode({ SetSelectionMode = "Cell" }), pane)

                -- 次のPromptゾーンまで選択（コマンドと出力を含む）
                window:perform_action(act.CopyMode({ MoveForwardZoneOfType = "Prompt" }), pane)

                -- 1行上に移動して行末へ（現在のプロンプト行を除外）
                window:perform_action(act.CopyMode("MoveUp"), pane)
                window:perform_action(act.CopyMode("MoveToEndOfLineContent"), pane)

                -- クリップボードにコピー
                window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)

                -- スクロールを戻してコピーモードを終了
                window:perform_action(act.ScrollToBottom, pane)
                window:perform_action(act.CopyMode("Close"), pane)
            end),
        },
        -- Cmd+f: 画面内検索
        {
            key = "f",
            mods = "CMD",
            action = act.Search({ CaseInSensitiveString = "" }),
        },
        -- Cmd+z: アンドゥ
        {
            key = "z",
            mods = "CMD",
            action = act.SendString("\x1f"),
        },
        -- Cmd+y: リドゥ
        {
            key = "y",
            mods = "CMD",
            action = act.SendString("\x18\x1f"),
        },
        -- Shift+Enter: 改行を送信
        {
            key = "Enter",
            mods = "SHIFT",
            action = wezterm.action.SendString("\n")
        },
    }
end

return M
