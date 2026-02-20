local utils = require('utils')

local align = function(method_name, args)
    return function()
        require("align")[method_name](args)
    end
end

local hex = nil

return {
    -- The following configs are needed for fixing lazyvim on nix
    -- force enable telescope-fzf-native.nvim
    { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
    -- disable mason.nvim, use programs.neovim.extraPackages
    { "williamboman/mason-lspconfig.nvim", enabled = false },
    { "williamboman/mason.nvim", enabled = false },
    -- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
        opts = {
            ensure_installed = {},
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        }
    },
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
    },
    {
        'Vonr/align.nvim',
        keys = {
            { "<leader>la",  align("align_to_char", { length = 1 }), mode = "x", utils.ns },
            { "<leader>ld",  align("align_to_char", { preview = true, length = 2 }), mode = "x", utils.ns },
            { "<leader>lw",  align("align_to_string", { preview = true, regex = false }), mode = "x", utils.ns },
            { "<leader>lr",  align("align_to_string", { preview = true, regex = true }), mode = "x", utils.ns },
        }
    },
    {
        'RaafatTurki/hex.nvim',
        keys = {
            { "<leader>hh", function()
                if (hex == nil) then
                    hex = require('hex')
                    hex.setup()
                end
                hex.toggle()
            end, mode = "x", utils.ns },
        },
        lazy = false,
    },
    {
        "RRethy/nvim-base16",
        config = function()
            utils.colorscheme_transparent "base16-monokai"
        end,
        lazy = false,
        priority = 1000,
    },
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
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
    { "neovim/nvim-lspconfig", lazy = false },
    -- Autocompletion
    { "hrsh7th/nvim-cmp", lazy = false },
    { "hrsh7th/cmp-buffer", lazy = false },
    { "hrsh7th/cmp-path", lazy = false },
    { "hrsh7th/cmp-nvim-lsp", lazy = false },
    { "hrsh7th/cmp-nvim-lua", lazy = false },
    { "saadparwaiz1/cmp_luasnip", lazy = false },
    { "themaxmarchuk/tailwindcss-colors.nvim", lazy = false },
    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets"
        },
    },
    {
        "luckasRanarison/tailwind-tools.nvim",
        name = "tailwind-tools",
        build = ":UpdateRemotePlugins",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim", -- optional
        },
        opts = {} -- your configuration
    },
    { "SmiteshP/nvim-navic" },
    {
        "jake-stewart/multicursor.nvim",
        lazy = false,
        config = function()
            local mc = require("multicursor-nvim")

            mc.setup()

            local set = vim.keymap.set

            -- Add or skip cursor above/below the main cursor.
            set({"n", "x"}, "<up>",
                function() mc.lineAddCursor(-1) end)
            set({"n", "x"}, "<down>",
                function() mc.lineAddCursor(1) end)
            set({"n", "x"}, "<leader><up>",
                function() mc.lineSkipCursor(-1) end)
            set({"n", "x"}, "<leader><down>",
                function() mc.lineSkipCursor(1) end)

            -- Add or skip adding a new cursor by matching word/selection
            set({"n", "x"}, "<leader>n",
                function() mc.matchAddCursor(1) end)
            set({"n", "x"}, "<leader>g",
                function() mc.matchSkipCursor(1) end)
            set({"n", "x"}, "<leader>N",
                function() mc.matchAddCursor(-1) end)
            set({"n", "x"}, "<leader>S",
                function() mc.matchSkipCursor(-1) end)

            -- In normal/visual mode, press `mwap` will create a cursor in every match of
            -- the word captured by `iw` (or visually selected range) inside the bigger
            -- range specified by `ap`. Useful to replace a word inside a function, e.g. mwif.
            set({"n", "x"}, "mw", function()
                mc.operator({ motion = "iw", visual = true })
                -- Or you can pass a pattern, press `mwi{` will select every \w,
                -- basically every char in a `{ a, b, c, d }`.
                -- mc.operator({ pattern = [[\<\w]] })
            end)

            -- Press `mWi"ap` will create a cursor in every match of string captured by `i"` inside range `ap`.
            set("n", "mW", mc.operator)

            -- Add all matches in the document
            set({"n", "x"}, "<leader>A", mc.matchAllAddCursors)

            -- You can also add cursors with any motion you prefer:
            -- set("n", "<right>", function()
            --     mc.addCursor("w")
            -- end)
            -- set("n", "<leader><right>", function()
            --     mc.skipCursor("w")
            -- end)

            -- Rotate the main cursor.
            set({"n", "x"}, "<left>", mc.nextCursor)
            set({"n", "x"}, "<right>", mc.prevCursor)

            -- Delete the main cursor.
            set({"n", "x"}, "<leader>x", mc.deleteCursor)

            -- Add and remove cursors with control + left click.
            set("n", "<c-leftmouse>", mc.handleMouse)
            set("n", "<c-leftdrag>", mc.handleMouseDrag)
            set("n", "<c-leftrelease>", mc.handleMouseRelease)

            -- Easy way to add and remove cursors using the main cursor.
            set({"n", "x"}, "<c-q>", mc.toggleCursor)

            -- Clone every cursor and disable the originals.
            set({"n", "x"}, "<leader><c-q>", mc.duplicateCursors)

            set("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                elseif mc.hasCursors() then
                    mc.clearCursors()
                else
                    -- Default <esc> handler.
                end
            end)

            -- bring back cursors if you accidentally clear them
            set("n", "<leader>gv", mc.restoreCursors)

            -- Align cursor columns.
            set("n", "<leader>a", mc.alignCursors)

            -- Split visual selections by regex.
            set("x", "S", mc.splitCursors)

            -- Append/insert for each line of visual selections.
            set("x", "I", mc.insertVisual)
            set("x", "A", mc.appendVisual)

            -- match new cursors within visual selections by regex.
            set("x", "M", mc.matchCursors)

            -- Rotate visual selection contents.
            set("x", "<leader>t",
                function() mc.transposeCursors(1) end)
            set("x", "<leader>T",
                function() mc.transposeCursors(-1) end)

            -- Jumplist support
            set({"x", "n"}, "<c-i>", mc.jumpForward)
            set({"x", "n"}, "<c-o>", mc.jumpBackward)

            -- Customize how cursors look.
            local hl = vim.api.nvim_set_hl
            hl(0, "MultiCursorCursor", { link = "Cursor" })
            hl(0, "MultiCursorVisual", { link = "Visual" })
            hl(0, "MultiCursorSign", { link = "SignColumn"})
            hl(0, "MultiCursorMatchPreview", { link = "Search" })
            hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
            hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
            hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = {
            "kyazdani42/nvim-web-devicons",
            {
                "SmiteshP/nvim-navic",
                dependencies = "neovim/nvim-lspconfig"
            },
        },
        config = function(_, opts)
            local custom_theme = function()
                local thm = require"lualine.themes.gruvbox"
                local blue = "#83a598"
                thm.normal.a.bg = blue
                return thm
            end

            local l = require("lualine")

            opts.options.theme = custom_theme()
            l.setup(opts)
            vim.cmd [[ set laststatus=3 ]]
            vim.cmd [[ highlight WinSeparator guibg=None ]]
        end,
        opts = {
            options = {
                icons_enabled = true,
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
                        if err ~= nil then
                            return ""
                        end
                        return navic.get_location()
                    end,
                },
            },
        }
    },
    {
        "nvim-telescope/telescope.nvim",
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
        lazy = false,
        config = function(_, opts)
            require("nvim-tree").setup(opts)
            vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

            utils.nvim_create_au(
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
                vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("closedir"))

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
                },
            }
        }
    },
    {
      "sourcegraph/amp.nvim",
      branch = "main",
      lazy = false,
      opts = { auto_start = true, log_level = "info" },
    }
}