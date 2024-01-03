local leaf = function(fq_path)
    local c = fq_path:reverse():match("([^/]+)/")
    if c == nil then return nil end
    return c:reverse()
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "kyazdani42/nvim-web-devicons",
        {
            "SmiteshP/nvim-navic",
            dependencies = "neovim/nvim-lspconfig"
        },
    },
    config = function(_, opts)
        require("lualine").setup(opts)
        vim.cmd [[ set laststatus=3 ]]
        vim.cmd [[ highlight WinSeparator guibg=None ]]
    end,
    opts = {
        options = {
            icons_enabled = true,
            theme = "gruvbox",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = {
                statusline = { "NvimTree" },
                winbar = { "NvimTree" },
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            }
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = {
                function()
                    local buf = vim.api.nvim_buf_get_name(0)
                    local cwd = io.popen("pwd"):read("*a")
                    cwd = cwd:sub(1, cwd:len() - 1) .. "/"

                    local _, end_idx = string.find(buf, cwd, 1, true)

                    if end_idx == nil then
                        return leaf(buf) or "[No Name]"
                    end

                    return buf:sub(end_idx + 1)
                end,
                function()
                    local buf = vim.api.nvim_get_current_buf()

                    -- local cur_line = ""

                    return vim.api.nvim_buf_line_count(buf) .. "L"
                end
            },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" }
        },
        winbar = {
            lualine_a = { "filename" },
            lualine_b = {
                function()
                    local err, navic = pcall(require, "nvim-navic")
                    if err == nil then
                        return ""
                    end
                    return navic.get_location()
                end,
            },
        },
    }
}
