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

-- LSP keymaps on attach (gd, K, grn, gra, grr are now nvim 0.11 defaults)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf, remap = false }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  end,
})

-- Enable LSP servers (configs provided by nvim-lspconfig plugin)
vim.lsp.config('*', {
  root_markers = { '.git' },
})

vim.lsp.enable({
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
})
