local utils = require "utils"

utils.keymaps {
    { "v", "J",         ":m \">+1<CR>gv=gv" },
    { "v", "K",         ":m \"<-2<CR>gv=gv" },
    { "n", "J",         "mzJ`z" },
    { "n", "<C-d>",     "<C-d>zz" },
    { "n", "<C-u>",     "<C-u>J`z" },
    { "n", "n",         "nzzzv" },
    { "n", "N",         "Nzzzv" },
    { "x", "<leader>p", "\"_dP" },
    { "n", "<leader>y", "\"+y" },
    { "v", "<leader>p", "\"+y" },
    { "n", "<leader>Y", "\"+Y" },
    { "n", "<leader>f", vim.lsp.buf.format },
    { "n", "<C-k>",     "<cmd>cnext<Cr>zz" },
    { "n", "<C-j>",     "<cmd>cprev<Cr>zz" },
    { "n", "<leader>k", "<cmd>lnextCr>zz" },
    { "n", "<leader>j", "<cmd>lprev<Cr>zz" },
    { "n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>" },
    { "n", "<C-s>",     ":w!<cr>" },
    { "i", "<C-s>",     "<Esc>:w!<cr>i" },
    { "n", "<C-x>",     ":wqall!<cr>" },
    { "i", "jj",        "<Esc>" },
    { "i", "jk",        "<Esc>" },
    { "i", "kj",        "<Esc>" },
}

utils.nvim_create_au(
    "RemoveTrailingWhitespace",
    "BufWritePre",
    {
        pattern = { "*" },
        callback = function()
            vim.cmd(":%s/\\s\\+$//e")
        end,
        group = "RemoveTrailingWhitespace"
    }
)

local colorscheme_transparent = function(name)
    vim.cmd.colorscheme(name)
    utils.set_transparent {
        "Normal",
        "NormalFloat",
        "LineNr",
        "SignColumn",
        "NormalNC",
    }
end

vim.api.nvim_create_user_command(
    "ColorsTrans",
    function(opts)
        colorscheme_transparent(opts.fargs[1])
    end,
    { nargs = 1 }
)

utils.set_listchars {
    "eol:↲",
    "tab:»-",
    -- "space:␣",
    "trail:…",
    "extends:…",
    "precedes:…",
    "conceal:┊",
    "nbsp:☠",
}

utils.disable_plugins {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
    "tutor",
    "rplugin",
    "synmenu",
    "optwin",
    "compiler",
    "bugreport",
    "ftplugin",
}

utils.plugin_manager {
    name = "lazy",
    path = "lazy/lazy.nvim",
    git = "https://github.com/folke/lazy.nvim.git",
}.setup {
    { "lewis6991/gitsigns.nvim" },
    {
        "RRethy/nvim-base16",
        config = function()
            colorscheme_transparent "base16-gruvbox-dark-pale"
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
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        tag = "nightly",
        lazy = false,
        config = function(_, opts)
            require("nvim-tree").setup(opts)
            vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

            utils.nvim_create_au(
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
            git = {
                ignore = false
            },
            update_focused_file = {
                enable = true,
            },
            renderer = {
                icons = {
                    webdev_colors = true,
                    git_placement = "before",
                    padding = " ",
                    symlink_arrow = " ➛ ",
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                    },
                    glyphs = {
                        default = "",
                        symlink = "",
                        bookmark = "",
                        folder = {
                            arrow_closed = "",
                            arrow_open = "",
                            default = "",
                            open = "",
                            empty = "",
                            empty_open = "",
                            symlink = "",
                            symlink_open = "",
                        },
                        git = {
                            unstaged = "",
                            staged = "✓",
                            unmerged = "",
                            renamed = "➜",
                            untracked = "★",
                            deleted = "",
                            ignored = "◌",
                        },
                    },
                },
                special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
                symlink_destination = true,
            },
        }
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
    {
        "VonHeikemen/lsp-zero.nvim",
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
            -- Nvim API autocompletions
            { "folke/neodev.nvim" },
            -- Navic
            {
                "SmiteshP/nvim-navic",
                dependencies = "neovim/nvim-lspconfig"
            },

        },
        config = function()
            local lsp_zero = require("lsp-zero")

            local lsp_keymaps = function(kms, opts)
                for _, k in pairs(kms) do
                    vim.keymap.set(k[3] or "n", k[1], k[2], opts)
                end
            end

            lsp_zero.on_attach(function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }
                lsp_keymaps(
                    {
                        { "gd",          vim.lsp.buf.definition },
                        { "K",           vim.lsp.buf.hover },
                        { "<leader>vws", vim.lsp.buf.workspace_symbol },
                        { "<leader>vd",  vim.diagnostic.open_float },
                        { "[d",          vim.diagnostic.goto_next },
                        { "]d",          vim.diagnostic.goto_prev },
                        { "<leader>vca", vim.lsp.buf.code_action },
                        { "<leader>vrr", vim.lsp.buf.references },
                        { "<leader>vrn", vim.lsp.buf.rename },
                        { "<C-b>",       ":LspStop<CR>:LspStart<CR>" },
                        { "<C-h>",       vim.lsp.buf.signature_help,  "i" },
                    },
                    opts
                )
                pcall(require("nvim-navic").attach, client, bufnr)
            end)

            require("mason").setup({})
            require("mason-lspconfig").setup({
                ensure_installed = { "rust_analyzer" },
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require("lspconfig").lua_ls.setup(lua_opts)
                    end,
                }
            })

            local cmp = require("cmp")
            local cmp_action = lsp_zero.cmp_action()
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup {
                sources = {
                    { name = "path" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "luasnip", keyword_length = 2 },
                    { name = "buffer",  keyword_length = 3 },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-f>"] = cmp_action.luasnip_jump_forward(),
                    ["<C-b>"] = cmp_action.luasnip_jump_backward(),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                }),
                formatting = lsp_zero.cmp_format(),
            }
        end
    },
    {
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
                        local leaf = function(fq_path)
                            local c = fq_path:reverse():match("([^/]+)/")
                            if c == nil then return nil end
                            return c:reverse()
                        end

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

                        local cur_line = ""

                        return vim.api.nvim_buf_line_count(buf) .. "L"
                    end
                },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" }
            },
            winbar = {
                lualine_a = { "filename" },
                lualine_b = { function() return require("nvim-navic").get_location() end },
            },
        }
    },
}
