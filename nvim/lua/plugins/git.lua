return  {
    {
        "lewis6991/gitsigns.nvim",
        opts = {}
    },
    {
        "tpope/vim-fugitive",
        keys = { {
            "<leader>gs",
            function()
                local r, err = pcall(vim.cmd.Git)
                if err then return end
                return r
            end
        }, },
    },
}
