-- Completion setup
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-f>"] = function() luasnip.jump(1) end,
    ["<C-b>"] = function() luasnip.jump(-1) end,
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<CR>"]  = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources({
      { name = "nvim_lsp", keyword_length = 2 },
      { name = "luasnip", keyword_length = 2 },
      { name = "nvim_lua", keyword_length = 2 },
      { name = "path", keyword_length = 2 },
      { name = "buffer", keyword_length = 3 },
  })
})

-- LSP keymaps and capabilities
local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    local keymaps = {
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
        { "<C-b>",       "<cmd>LspStop<CR><cmd>LspStart<CR>" },
        { "<C-h>",       vim.lsp.buf.signature_help, "i" },
    }

    for _, k in ipairs(keymaps) do
        vim.keymap.set(k[3] or "n", k[1], k[2], opts)
    end
end

-- LSP servers setup
local lspconfig = require("lspconfig")
local servers = {
  "pyright",
  "lua_ls",
  "rust_analyzer",
  "zls",
  "nil_ls",
  "astro",
  "ts_ls",
  "tailwindcss",
  "terraformls",
  "emmet_language_server",
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()
for _, server in ipairs(servers) do
  lspconfig[server].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end
