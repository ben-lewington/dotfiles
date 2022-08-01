-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
K.set('n', '<space>v', vim.diagnostic.open_float, opts)
K.set('n', '[d', vim.diagnostic.goto_prev, opts)
K.set('n', ']d', vim.diagnostic.goto_next, opts)
K.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  K.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  K.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  K.set('n', 'K', vim.lsp.buf.hover, bufopts)
  K.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  K.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  K.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  K.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  K.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  K.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  K.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  K.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  K.set('n', 'gr', vim.lsp.buf.references, bufopts)
  K.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

require('lspconfig')['sumneko_lua'].setup {
  on_attach = on_attach,
  flags = lsp_flags,
}
-- require('lspconfig')['pyright'].setup {
--   on_attach = on_attach,
--   flags = lsp_flags,
-- }
-- require('lspconfig')['tsserver'].setup {
--   on_attach = on_attach,
--   flags = lsp_flags,
-- }
-- require('lspconfig')['rust_analyzer'].setup {
--   on_attach = on_attach,
--   flags = lsp_flags,
--   -- Server-specific settings...
--   settings = {
--     ["rust-analyzer"] = {}
--   }
-- }
