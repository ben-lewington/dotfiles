local M = {}

local function get_default_colorscheme()
  local try, cs = pcall(require, 'base16-colorscheme')
  M.base16 = try
  local value
  if not try then
    value = "desert"
  else
    value = "gruvbox-dark-pale"
    M.base16_colors = cs.colorschemes[value]
    value = "base16-" .. value
  end
  return value
end

M.default_colorscheme = get_default_colorscheme()

vim.g.colorscheme = M.default_colorscheme
vim.cmd("colorscheme " .. M.default_colorscheme)

M.colors = {
  bg = "#202328",
  fg = "#bbc2cf",
  yellow = "#ECBE7B",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#98be65",
  orange = "#FF8800",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  purple = "#c678dd",
  blue = "#51afef",
  red = "#ec5f67",
}

return M
