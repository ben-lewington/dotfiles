require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
        mappings = {
            list = {
                { key = "u", action = "dir_up" },
            },
        },
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
    view = {
        mappings = {
            list = {
                { key = {"<CR>", "o", "l"}, action = "edit", mode = "n" },
                { key = "h", action = "close_node" },
            }
        }
    }
})

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
