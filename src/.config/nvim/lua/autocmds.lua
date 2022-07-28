-- Autocommands (https://neovim.io/doc/user/autocmd.html)
vim.api.nvim_create_augroup("LookAndFeel", { clear = true })
vim.api.nvim_create_autocmd(
  { "ColorScheme" },
  {
    pattern = { "*" },
    -- enable wrap mode for json files only
    callback = function()
      vim.api.nvim_set_hl(0, "Normal", { ctermbg = "none" })
      vim.api.nvim_set_hl(0, "NonText", { ctermbg = "none" })
      vim.api.nvim_set_hl(0, "LineNr", { ctermbg = "none" })
    end,
    group = "LookAndFeel"
  }
)
vim.api.nvim_create_augroup("RemoveTrailingWhitespace", { clear = true })
vim.api.nvim_create_autocmd(
  { "BufWritePre" },
  {
    pattern = { "*" },
    -- enable wrap mode for json files only
    callback = function()
      vim.cmd(":%s/\\s\\+$//e")
    end,
    group = "RemoveTrailingWhitespace"
  }
)
