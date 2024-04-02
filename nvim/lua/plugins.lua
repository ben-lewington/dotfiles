local align = function(method_name, args)
    return function()
        require("align")[method_name](args)
    end
end

local ns = { noremap = true, silent = true }

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
    {
        'Vonr/align.nvim',
        branch = "v2",
        lazy = true,
        keys = {
            { "<leader>la",  align("align_to_char", { length = 1 }), mode = "x", ns },
            { "<leader>ld",  align("align_to_char", { preview = true, length = 2 }), mode = "x", ns },
            { "<leader>lw",  align("align_to_string", { preview = true, regex = false }), mode = "x", ns },
            { "<leader>lr",  align("align_to_string", { preview = true, regex = true }), mode = "x", ns },
        }
    },
    { 'RaafatTurki/hex.nvim' }
}
