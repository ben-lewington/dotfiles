local M = {}

local function augroup_exists(augroup)

end

M._default_autocmds = {
  {}
}

vim.api.nvim_create_autocmd({ "ColorScheme" }, function() print("a") end)
