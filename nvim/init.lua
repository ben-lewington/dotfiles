local setup = require "setup"

setup.plugin_manager {
    name = "lazy", path = "lazy/lazy.nvim",
    git = "https://github.com/folke/lazy.nvim.git",
}.setup(require "plugins")

require "utils".run_setup(setup, require "data") {
    "options",
    "keymaps",
    "autocmds",
    "listchars",
    "disable_plugins",
    "commands",
}
