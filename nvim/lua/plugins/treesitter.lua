return {
    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
        opts = {
            ensure_installed = { "c", "lua", "rust", "python" },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        }

    },
    "nvim-treesitter/playground",
}
