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
end)

require("nvim-treesitter.configs").setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
  indent = {
      enable = true
  },
}

