require "plugins"

local opt = vim.opt

-- helpの日本語化
opt.helplang = "ja,en"

-- 検索時の大文字小文字
opt.ignorecase = true
opt.smartcase = true

-- インデント
opt.smartindent = true

-- ファイル
opt.autoread = true

-- エンコーディングの指定
vim.criptencoding = "utf-8"

-- 行番号
opt.number = true
-- opt.relativenumber = true
opt.signcolumn = "yes"

-- カーソル
opt.cursorline = true

-- タブの設定
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4

-- マウス有効化
opt.mouse = "a"

-- スワップファイルを作成しない
opt.swapfile = false

