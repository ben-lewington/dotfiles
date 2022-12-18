local listchars = {
  'eol:↲',
  'tab:»-',
  -- 'space:␣',
  'trail:…',
  'extends:…',
  'precedes:…',
  'conceal:┊',
  'nbsp:☠',
}

vim.cmd("set listchars=" .. table.concat(listchars, ","))
vim.cmd("set list")
-- Disable builtin plugins
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  "ftplugin",
}
-- disable them all
for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

