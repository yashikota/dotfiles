require "plugins"

local opt = vim.opt
local keymap = vim.keymap

-- helpの日本語化
opt.helplang = "ja,en"

-- 検索時の大文字小文字
opt.ignorecase = true
opt.smartcase = true

-- インデント
opt.autoindent = true
opt.smartindent = true

-- ファイル
opt.autoread = true

-- エンコーディングの指定
vim.scriptencoding = "utf-8"
opt.encoding="utf-8"
opt.fileencoding="utf-8"

-- 行番号
opt.number = true
-- opt.relativenumber = true
opt.signcolumn = "yes"

-- Window
vim.wo.number = true

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

-- 改行時自動でコメントアウトしない
vim.api.nvim_exec([[
  autocmd FileType * setlocal formatoptions-=cro
]], false)

-- jjでEscする
keymap.set('i','jj','<Esc>')

