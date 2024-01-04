local utils = require "utils"

local colorscheme = function()
    return {
        {
            "RRethy/nvim-base16",
            config = function()
                utils.colorscheme_transparent "base16-gruvbox-dark-pale"
            end,
            lazy = false,
            priority = 1000,
        },
        { "rose-pine/neovim", name = "rose-pine", },
    }

end

local git = function()
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
end

local treesitter = function()
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
        {
            "numToStr/Comment.nvim",
            keys = {
                { "<leader>/", "<Plug>(comment_toggle_linewise_current)" },
                { "<leader>/", "<Plug>(comment_toggle_linewise_visual)", mode = "v" },
            }
        },
    }

end

local telescope = function()
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
end

return {
    unpack(colorscheme()),
    require "plugins.lsp",
    require "plugins.statusline",
    require "plugins.tree",
    unpack(git()),
    unpack(treesitter()),
    unpack(telescope()),
    {
        "mbbill/undotree",
        keys = { { "<leader>u", vim.cmd.UndotreeToggle }, },
    },
}
