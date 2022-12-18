vim.keymap.set("n", "<leader>gs", function()
  local r, err = pcall(vim.cmd.Git)
  if err then return end
  return r
end)
