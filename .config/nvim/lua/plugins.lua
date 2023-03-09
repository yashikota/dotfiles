vim.cmd[[packadd packer.nvim]]

require("packer").startup(function()
    use { "wbthomason/packer.nvim", opt = true }
    use "EdenEast/nightfox.nvim"
    use "lambdalisue/fern.vim"
    use {
        "nvim-treesitter/nvim-treesitter",
        run = function()
            local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
            ts_update()
        end,
    }
    use {
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true }
    }
    use "lewis6991/gitsigns.nvim"
end)

-- nvim-treesitter
require("nvim-treesitter.configs").setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
}

-- fern
vim.g["fern#replace_netrw"] = 1
vim.g["fern#drawer_width"] = 30
vim.g["fern#renderer"] = "nerdfont"
vim.g["fern#default_hidden"] = 1

vim.g.mapleader = " "
vim.api.nvim_set_keymap("n", "<Leader>e", ":Fern . -reveal=%<CR>", {noremap=true, silent=true})

-- nightfox
vim.cmd([[colorscheme duskfox]])

-- lualine
require("lualine").setup()

--gitsigns
require("gitsigns").setup()
