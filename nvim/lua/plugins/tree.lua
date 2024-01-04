return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    tag = "nightly",
    lazy = false,
    config = function(_, opts)
        require("nvim-tree").setup(opts)
        vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

        require "utils".nvim_create_au(
            "OpenNvimTreeOnStartup",
            "VimEnter",
            {
                callback = function()
                    require("nvim-tree.api").tree.open()
                end
            }
        )
    end,
    opts = {
        sort_by = "case_sensitive",
        sync_root_with_cwd = true,
        hijack_unnamed_buffer_when_opening = true,
        view = {
            adaptive_size = true,
            mappings = {
                list = {
                    { key = "u",                  action = "dir_up" },
                    { key = { "<CR>", "o", "l" }, action = "edit",      mode = "n" },
                    { key = "h",                  action = "close_node" },
                },
            },
        },
        git = { ignore = false },
        update_focused_file = { enable = true, },
        renderer = {
            special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
            symlink_destination = true,
            icons = {
                glyphs = {
                    git = {
                        unstaged = "",
                        staged = "✓",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "★",
                        deleted = "",
                        ignored = "◌",
                    },
                }
            }
        },
    }
}
