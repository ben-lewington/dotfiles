{ config, lib, pkgs, ... }:
{
    programs.neovim = {
        enable = true;
        extraPackages = with pkgs; [
            emmet-ls
            pyright
            rust-analyzer
            typescript-language-server
            nil
            zls
            lua-language-server
            nodePackages.vscode-json-languageserver
            yaml-language-server
            lua
            stylua
            ripgrep
            unixtools.xxd
        ];

        plugins = with pkgs.vimPlugins; [ lazy-nvim ];

        extraLuaConfig =
            let plugins = with pkgs.vimPlugins; [
                undotree
                comment-nvim
                align-nvim
                hex-nvim
                base16-nvim
                gitsigns-nvim
                vim-fugitive
                lsp-zero-nvim
                nvim-lspconfig
                luasnip
                neodev-nvim
                nvim-cmp
                cmp-buffer
                cmp-path
                cmp-nvim-lsp
                cmp-nvim-lua
                nvim-navic
                nvim-web-devicons
                lualine-nvim
                plenary-nvim
                telescope-fzf-native-nvim
                telescope-nvim
                nvim-tree-lua
                nvim-treesitter
                nvim-treesitter-context
                nvim-treesitter-textobjects
                nvim-ts-autotag
                nvim-ts-context-commentstring

                { name = "mini.ai"; path = mini-nvim; }
                { name = "mini.bufremove"; path = mini-nvim; }
                { name = "mini.comment"; path = mini-nvim; }
                { name = "mini.indentscope"; path = mini-nvim; }
                { name = "mini.pairs"; path = mini-nvim; }
                { name = "mini.surround"; path = mini-nvim; }
            ];
            mkEntryFromDrv = drv:
              if lib.isDerivation drv then
                { name = "${lib.getName drv}"; path = drv; }
              else
                drv;
            lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
            in ''
        local ns = { noremap = true, silent = true }

        local align = function(method_name, args)
            return function()
                require("align")[method_name](args)
            end
        end

        local hex_view = function(method_name)
            local hex = nil
            return function()
                if (hex == nil) then
                    hex = require('hex')
                    hex.setup()
                end
                hex[method_name]()
            end
        end

        local set_transparent = function(comps)
            for _, comp in pairs(comps) do
                vim.api.nvim_set_hl(0, comp, { bg = "none" })
            end
        end

        local colorscheme_transparent = function(name)
            vim.cmd.colorscheme(name)
            set_transparent {
                "Normal",
                "NormalFloat",
                "LineNr",
                "SignColumn",
                "NormalNC",
            }
        end

        local nvim_create_au = function(grp, cmd, cmd_tbl)
            vim.api.nvim_create_augroup(grp, {})
            vim.api.nvim_create_autocmd(cmd, cmd_tbl)
        end

        local leaf = function(fq_path)
            local c = fq_path:reverse():match("([^/]+)/")
            if c == nil then return nil end
            return c:reverse()
        end

        local custom_theme = function()
            local thm = require"lualine.themes.gruvbox"
            local blue = "#83a598"

            thm.normal.a.bg = blue
            return thm
        end

        local setup_lsp = function(lsp)
            local lsp_keymaps = function(kms, opts)
                for _, k in pairs(kms) do
                    vim.keymap.set(k[3] or "n", k[1], k[2], opts)
                end
            end

            lsp.on_attach(function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }
                lsp_keymaps(
                    {
                        { "gd",          vim.lsp.buf.definition },
                        { "gr",          vim.lsp.buf.references },
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
        end

        local setup_completion = function(lsp)
            local cmp = require("cmp")
            local cmp_action = lsp.cmp_action()
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            require('luasnip.loaders.from_vscode').lazy_load()

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
                formatting = lsp.cmp_format(),
            }
        end

        local setup_lspconfig = function()
            local lspconf = require("lspconfig")

            lspconf.pyright.setup{}
            lspconf.lua_ls.setup{}
            lspconf.rust_analyzer.setup{}
            lspconf.zls.setup{}
            lspconf.nil_ls.setup{}
        end

        local run_setup = function(s, d)
            return function(keys)
                for _, key in pairs(keys) do
                    s[key](d[key])
                end
            end
        end

        local setup = {
            options = function(opts)
                vim.g.mapleader = " "
                vim.opt.isfname:append("@-@")
                for opt, v in pairs(opts) do
                    vim.opt[opt] = v
                end
            end,

            keymaps = function(tbls)
                for _, tbl in pairs(tbls) do
                    vim.keymap.set(unpack(tbl))
                end
            end,

            autocmds = function(cmds)
                for _, cmd in ipairs(cmds) do
                    nvim_create_au(unpack(cmd))
                end
            end,

            listchars = function(lcs)
                vim.cmd("set listchars=" .. table.concat(lcs, ","))
                vim.cmd("set list")
            end,

            disable_plugins = function(names)
                for _, plugin in pairs(names) do
                  vim.g["loaded_" .. plugin] = 1
                end
            end,

            commands = function(cmds)
                for _, cmd in pairs(cmds) do
                    vim.api.nvim_create_user_command(unpack(cmd))
                end
            end,
        }
        local data = {
            options = {
                guicursor = "",
                mouse = "a",
                nu = true,
                relativenumber = true,
                tabstop = 4,
                softtabstop = 4,
                shiftwidth = 4,
                expandtab = true,
                smartindent = true,
                wrap = false,
                hlsearch = false,
                incsearch = true,
                termguicolors = true,
                swapfile = false,
                backup = false,
                undodir = os.getenv("HOME") .. "/.vim/undodir",
                undofile = true,
                scrolloff = 8,
                signcolumn = "yes",
                updatetime = 50,
                colorcolumn = "100",
                filetype = "on",
            },
            keymaps = {
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
                -- TODO: fix this up
                -- { "n", "<leader>r", function()
                --     local cur = vim.api.nvim_win()
                --     local lines = vim.api.nvim_buf_line_count(cur)
                --     vim.cmd("resize " ..  lines)
                -- end },
            },
            autocmds = {
                {
                    "RemoveTrailingWhitespace",
                    "BufWritePre",
                    {
                        pattern = { "*" },
                        callback = function()
                            vim.cmd(":%s/\\s\\+$//e")
                        end,
                        group = "RemoveTrailingWhitespace"
                    }
                },
            },
            disable_plugins = {
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
            },
            listchars = {
                "eol:↲",
                "tab:»-",
                -- "space:␣",
                "trail:…",
                "extends:…",
                "precedes:…",
                "conceal:┊",
                "nbsp:☠",
            },
            commands = {
                {
                    "ColorsTrans",
                    function(opts)
                        colorscheme_transparent(opts.fargs[1])
                    end,
                    { nargs = 1 }
                },
            }
        }

        run_setup(
            setup,
            data
        ) {
            "options",
            "keymaps",
            "autocmds",
            "listchars",
            "disable_plugins",
            "commands",
        }

        local lazy_conf = {
            defaults = { lazy = true },
            dev = {
              -- reuse files from pkgs.vimPlugins.*
              path = "${lazyPath}",
              patterns = { "" },
              -- fallback to download
              fallback = true,
            },
            spec = {
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
                        { "<leader>la",  align("align_to_char", { length = 1 }), mode = "x", ns },
                        { "<leader>ld",  align("align_to_char", { preview = true, length = 2 }), mode = "x", ns },
                        { "<leader>lw",  align("align_to_string", { preview = true, regex = false }), mode = "x", ns },
                        { "<leader>lr",  align("align_to_string", { preview = true, regex = true }), mode = "x", ns },
                    }
                },
                {
                    'RaafatTurki/hex.nvim',
                    keys = {
                        { "<leader>ht",  hex_view("toggle"), mode = "x", ns },
                    },
                    lazy = false,
                },
                {
                    "RRethy/nvim-base16",
                    config = function()
                        colorscheme_transparent "base16-monokai"
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
                {
                    "VonHeikemen/lsp-zero.nvim",
                    lazy = false,
                    dependencies = {
                        -- LSP Support
                        { "neovim/nvim-lspconfig", lazy = false },
                        -- Autocompletion
                        { "hrsh7th/nvim-cmp" },
                        { "hrsh7th/cmp-buffer" },
                        { "hrsh7th/cmp-path" },
                        { "hrsh7th/cmp-nvim-lsp" },
                        { "hrsh7th/cmp-nvim-lua" },
                        { "saadparwaiz1/cmp_luasnip" },
                        -- Snippets
                        {
                            "L3MON4D3/LuaSnip",
                            dependencies = {
                                "rafamadriz/friendly-snippets"
                            },
                        },
                        -- Nvim API LSP support
                        { "folke/neodev.nvim" },
                        -- Navic
                        {
                            "SmiteshP/nvim-navic",
                            dependencies = "neovim/nvim-lspconfig"
                        },
                    },
                    config = function()
                        local lsp = require "lsp-zero"
                        setup_lsp(lsp)
                        setup_completion(lsp)
                        setup_lspconfig()
                    end
                },
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
                        local l = require("lualine")
                        opts.theme = custom_theme()
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
                                    if err == nil then
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

                        nvim_create_au(
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
                }
            }
        }

        require('lazy').setup(lazy_conf)
        '';
    };

    # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
    xdg.configFile."nvim/parser".source = let parsers =
        pkgs.symlinkJoin {
            name = "treesitter-parsers";
            paths = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
                c
                lua
                python
                rust
                nix
                zig
            ])).dependencies;
        };
    in "${parsers}/parser";
}
