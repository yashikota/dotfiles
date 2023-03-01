vim.cmd[[packadd packer.nvim]]

require("packer").startup(function()
    use { "wbthomason/packer.nvim", opt = true }
    use "EdenEast/nightfox.nvim"
    use "lambdalisue/fern.vim"
end)

