local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.setup(config)
    config.keys = {
        -- Shift+↑: 前のプロンプトへ
        { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
        -- Shift+↓: 次のプロンプトへ
        { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
        -- Cmd+W: ペインを閉じる（常に確認）
        {
            key = "w",
            mods = "CMD",
            action = wezterm.action_callback(function(window, pane)
                window:perform_action(
                    act.PromptInputLine({
                        description = "Close this pane? (Enter/y to close, n to cancel)",
                        action = wezterm.action_callback(function(window, pane, line)
                            if line == "" or line == "y" or line == "Y" then
                                window:perform_action(act.CloseCurrentPane({ confirm = false }), pane)
                            end
                        end),
                    }),
                    pane
                )
            end),
        },
        -- Cmd+P: 横にペイン分割
        {
            key = "p",
            mods = "CMD",
            action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
        },
        -- Cmd+Shift+P: 縦にペイン分割
        {
            key = "p",
            mods = "CMD|SHIFT",
            action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
        },
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
    }
end

return M
