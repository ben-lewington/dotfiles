return {
    {
        "mbbill/undotree",
        keys = { { "<leader>u", vim.cmd.UndotreeToggle }, },
    },
    {
        "numToStr/Comment.nvim",
        keys = {
            { "<leader>/", "<Plug>(comment_toggle_linewise_current)" },
            { "<leader>/", "<Plug>(comment_toggle_linewise_visual)", mode = "v" },
        },
        lazy = false,
    },
}
