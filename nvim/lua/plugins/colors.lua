return {
    {
        "RRethy/nvim-base16",
        config = function()
            require "utils".colorscheme_transparent "base16-monokai"
        end,
        lazy = false,
        priority = 1000,
    },
    { "rose-pine/neovim", name = "rose-pine", },
}
