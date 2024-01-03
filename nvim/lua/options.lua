O.laststatus = 3 -- set global statusline
O.number = true
O.relativenumber = true
C("set colorcolumn=100")

local listchars = {
  'eol:↲',
  'tab:»-',
  -- 'space:␣',
  'trail:𝁢',
  'extends:…',
  'precedes:…',
  'conceal:┊',
  'nbsp:☠',
}

C("set listchars=" .. table.concat(listchars, ","))
C("set list")
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
  G["loaded_" .. plugin] = 1
end
