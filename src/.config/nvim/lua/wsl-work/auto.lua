vim.api.nvim_create_augroup("RemoveTrailingWhitespace", { clear = true })
vim.api.nvim_create_autocmd(
  { "BufWritePre" },
  {
    pattern = { "*" },
    callback = function()
      vim.cmd(":%s/\\s\\+$//e")
    end,
    group = "RemoveTrailingWhitespace"
  }
)
