local utils = require "utils"

return {
    require "plugins.lsp",
    require "plugins.statusline",
    require "plugins.tree",
    { "lewis6991/gitsigns.nvim" },
    {
        "RRethy/nvim-base16",
        config = function()
            utils.colorscheme_transparent "base16-gruvbox-dark-pale"
        end,
        lazy = false,
        priority = 1000,
    },
    { "rose-pine/neovim", name = "rose-pine", },
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
    {
        "numToStr/Comment.nvim",
        keys = {
            { "<leader>/", "<Plug>(comment_toggle_linewise_current)" },
            { "<leader>/", "<Plug>(comment_toggle_linewise_visual)", mode = "v" },
        }
    },
    {
        "mbbill/undotree",
        keys = { { "<leader>u", vim.cmd.UndotreeToggle }, },
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
