local utils = require "utils"

utils.plugin_manager {
    name = "lazy", path = "lazy/lazy.nvim",
    git = "https://github.com/folke/lazy.nvim.git",
}.setup(require "plugins")

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
