return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    -- tag = "nightly",
    lazy = false,
    config = function(_, opts)
        require("nvim-tree").setup(opts)
        vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

        require "utils".nvim_create_au(
            "OpenNvimTreeOnStartup",
            "VimEnter",
            {
                callback = function(tbl)
                    local file = tbl.file
                    if file == "" then
                        require("nvim-tree.api").tree.open { current_window = true }
                    elseif file == vim.loop.cwd()  then
                        require("nvim-tree.api").tree.open()
                    end
                end
            }
        )
    end,
    opts = {
        on_attach = function(bufnr)
            local api = require"nvim-tree.api"

            local opts = function(desc)
                return  { desc = "nvim-tree" .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end


            api.config.mappings.default_on_attach(bufnr)
            vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("cd .."))
            vim.keymap.set("n", "<CR>", api.node.open.edit, opts("bufedit"))
            vim.keymap.set("n", "l", api.node.open.edit, opts("bufedit"))
            vim.keymap.set("n", "o", api.node.open.edit, opts("bufedit"))
            vim.keymap.set("n", "h", api.tree.close, opts("closedir"))

        end,
        sort_by = "case_sensitive",
        sync_root_with_cwd = true,
        hijack_unnamed_buffer_when_opening = true,
        view = {
            adaptive_size = true,
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
