local setup_completion = function(lsp)
    local cmp = require("cmp")
    local cmp_action = lsp.cmp_action()
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
        formatting = lsp.cmp_format(),
    }
end

local setup_mason = function(lsp)
    require("mason").setup {}
    require("mason-lspconfig").setup {
        ensure_installed = { "rust_analyzer" },
        handlers = {
            lsp.default_setup,
            lua_ls = function()
                local lua_opts = lsp.nvim_lua_ls()
                require("lspconfig").lua_ls.setup(lua_opts)
            end,
        }
    }
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

return {
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
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "saadparwaiz1/cmp_luasnip" },
        -- Snippets
        { "L3MON4D3/LuaSnip" },
        { "rafamadriz/friendly-snippets" },
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
        setup_mason(lsp)
        setup_completion(lsp)
    end
}
