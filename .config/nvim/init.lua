require "plugins"

local opt = vim.opt

-- エンコーディングの指定
vim.criptencoding = "utf-8"

-- 行番号の表示
opt.number = true

-- タブの設定
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4

-- マウス有効化
opt.mouse = "a"

-- スワップファイルを作成しない
opt.swapfile = false

