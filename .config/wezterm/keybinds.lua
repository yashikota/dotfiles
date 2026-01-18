local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.setup(config)
    -- Leader key: Cmd+z (タイムアウト1秒)
    config.leader = { key = "z", mods = "CMD", timeout_milliseconds = 1000 }

    config.keys = {
        -- Cmd+W: ペインを閉じる
        {
            key = "w",
            mods = "CMD",
            action = act.CloseCurrentPane({ confirm = false }),
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
        -- Leader + c: 直前のコマンドと出力をコピー
        {
            key = "c",
            mods = "LEADER",
            action = wezterm.action_callback(function(window, pane)
                -- コピーモードに入る
                window:perform_action(act.ActivateCopyMode, pane)

                -- 直前のInputゾーン（最後のコマンド）に移動
                window:perform_action(act.CopyMode({ MoveBackwardZoneOfType = "Input" }), pane)

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

                -- ステータスバーに一時的なステータスを表示
                window:set_right_status("📋 Copied!")
                -- 3秒後にクリア
                wezterm.time.call_after(3, function()
                    window:set_right_status("")
                end)
            end),
        },
        -- Leader + r: 画面内検索
        {
            key = "r",
            mods = "LEADER",
            action = act.Search({ CaseInSensitiveString = "" }),
        },
    }
end

return M
