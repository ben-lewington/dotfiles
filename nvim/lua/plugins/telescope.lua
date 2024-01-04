return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            {
                "<leader>ff",
                function()
                    require("telescope.builtin").find_files()
                end,
            },
            {
                "<leader>fb",
                function()
                    require("telescope.builtin").buffers()
                end,
            },
            {
                "<C-p>",
                function()
                    local output, err = pcall(require("telescope.builtin").git_files)
                    if err then return end
                    return output
                end,
            },
            {
                "<leader>ps",
                function()
                    require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
                end,
            },
        },
    },
}
