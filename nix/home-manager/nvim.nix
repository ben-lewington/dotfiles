{ config, lib, pkgs, ... }:
{
    programs.neovim = {
        enable = true;
        extraPackages = with pkgs; [
            pyright
            rust-analyzer
            astro-language-server
            typescript-language-server
            nil
            zls
            lua-language-server
            tailwindcss-language-server
            emmet-language-server
            nodePackages.vscode-json-languageserver
            yaml-language-server
            terraform-ls
            lua
            stylua
            ripgrep
            unixtools.xxd
        ];

        plugins = with pkgs.vimPlugins; [ lazy-nvim ];

        extraLuaConfig =
            let plugins = with pkgs.vimPlugins; [
                avante-nvim
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
                tailwindcss-colors-nvim
                tailwind-tools-nvim

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
                require('_start')

                require('lazy').setup({
                    defaults = { lazy = true },
                    dev = {
                      -- reuse files from pkgs.vimPlugins.*
                      path = "${lazyPath}",
                      patterns = { "" },
                      -- fallback to download
                      fallback = true,
                    },
                    spec = require('plugins')
                })

                require('lsp')
            '';
    };

    xdg.configFile."nvim/lua".source = ./nvim;
    # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
    xdg.configFile."nvim/parser".source = let parsers =
        pkgs.symlinkJoin {
            name = "treesitter-parsers";
            paths = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
                astro
                c
                lua
                python
                rust
                nix
                terraform
                zig
                css
                javascript
            ])).dependencies;
        };
    in "${parsers}/parser";
}
