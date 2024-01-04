local utils = require "utils"

utils.run_setup(
    require "setup",
    require "data"
) {
    "options",
    "keymaps",
    "autocmds",
    "listchars",
    "disable_plugins",
    "commands",
}

utils.plugin_manager {
    name = "lazy", path = "lazy/lazy.nvim",
    git = "https://github.com/folke/lazy.nvim.git",
}.setup "plugins"
