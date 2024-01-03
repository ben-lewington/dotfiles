local M = {}

-- if true, arrow_keys will be disabled in normal and visual mode
M.DISABLE_KEYS = true

M.keymap_cfg = function(modes, pattern, bind, opts)
  opts = opts or {}
  return { modes = modes, pattern = pattern, bind = bind, opts = opts }
end

M._keymaps = {
  --[[
    Save + Save & Quit shortcuts
  ]]
  M.keymap_cfg({ "n" }, "<C-s>", ":w<cr>"),
  M.keymap_cfg({ "i" }, "<C-s>", "<Esc>:w<cr>i"),
  M.keymap_cfg({ "n" }, "<C-x>", ":wq<cr>"),
  M.keymap_cfg({ "i" }, "jj", "<Esc>"),
  M.keymap_cfg({ "i" }, "jk", "<Esc>"),
  M.keymap_cfg({ "i" }, "kk", "<Esc>"),
}

M._noop_keymap_cfg = function(modes, pattern, opts)
  opts = opts or {}
  return M.keymap_cfg(modes, pattern, "<Nop>", opts)
end


local function disable_arrow_key_conf()
  local directions = { "<Up>", "<Down>", "<Left>", "Right" }
  for _, direction in ipairs(directions) do
    local keymap_conf = M._noop_keymap_cfg({ "n", "v" }, direction)
    table.insert(M._keymaps, keymap_conf)
  end
end

if M.DISABLE_KEYS then
  disable_arrow_key_conf()
end

M.add_keymaps = function(keymaps)
  keymaps = keymaps or {}
  for _, keymap_cfg in ipairs(keymaps) do
    table.insert(M._keymaps, keymap_cfg)
  end
  return M._keymaps
end

M.bind = function(keymaps)
  keymaps = keymaps or {}
  M.add_keymaps(keymaps)
  for _, conf in ipairs(M._keymaps) do
    K.set(conf.modes, conf.pattern, conf.bind, conf.opts)
  end
end

return M
