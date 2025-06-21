local utils = require('utils')

vim.g.mapleader = " "
vim.opt.isfname:append("@-@")
for opt, v in pairs({
    guicursor = "",
    mouse = "a",
    nu = true,
    relativenumber = true,
    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    smartindent = true,
    wrap = false,
    hlsearch = false,
    incsearch = true,
    termguicolors = true,
    swapfile = false,
    backup = false,
    undodir = os.getenv("HOME") .. "/.vim/undodir",
    undofile = true,
    scrolloff = 8,
    signcolumn = "yes",
    updatetime = 50,
    colorcolumn = "100",
    filetype = "on",
}) do
    vim.opt[opt] = v
end
for _, tbl in pairs({
    { "v", "J",         ":m \">+1<CR>gv=gv" },
    { "v", "K",         ":m \"<-2<CR>gv=gv" }, { "n", "J",         "mzJ`z" },
    { "n", "<C-d>",     "<C-d>zz" },
    { "n", "<C-u>",     "<C-u>J`z" },
    { "n", "n",         "nzzzv" },
    { "n", "N",         "Nzzzv" },
    { "x", "<leader>p", "\"_dP" },
    { "n", "<leader>y", "\"+y" },
    { "v", "<leader>p", "\"+y" },
    { "n", "<leader>Y", "\"+Y" },
    { "n", "<leader>f", vim.lsp.buf.format },
    { "n", "<C-k>",     "<cmd>cnext<Cr>zz" },
    { "n", "<C-j>",     "<cmd>cprev<Cr>zz" },
    { "n", "<leader>k", "<cmd>lnextCr>zz" },
    { "n", "<leader>j", "<cmd>lprev<Cr>zz" },
    { "n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>" },
    { "n", "<C-s>",     ":w!<cr>" },
    { "i", "<C-s>",     "<Esc>:w!<cr>i" },
    { "n", "<C-x>",     ":wqall!<cr>" },
    { "i", "jj",        "<Esc>" },
    { "i", "jk",        "<Esc>" },
    { "i", "kj",        "<Esc>" },
    -- TODO: fix this up
    -- { "n", "<leader>r", function()
    --     local cur = vim.api.nvim_win()
    --     local lines = vim.api.nvim_buf_line_count(cur)
    --     vim.cmd("resize " ..  lines)
    -- end },
}) do
    vim.keymap.set(unpack(tbl))
end

for _, cmd in ipairs({
    {
        "RemoveTrailingWhitespace",
        "BufWritePre",
        {
            pattern = { "*" },
            callback = function()
                vim.cmd(":%s/\\s\\+$//e")
            end,
            group = "RemoveTrailingWhitespace"
        }
    },
}) do
    utils.nvim_create_au(unpack(cmd))
end

vim.cmd("set listchars=" .. table.concat({
    "eol:↲",
    "tab:»-",
    -- "space:␣",
    "trail:…",
    "extends:…",
    "precedes:…",
    "conceal:┊",
    "nbsp:☠",
}, ","))
vim.cmd("set list")

for _, plugin in pairs({
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
}) do
  vim.g["loaded_" .. plugin] = 1
end

for _, cmd in pairs({
    {
        "ColorsTrans",
        function(opts)
            utils.colorscheme_transparent(opts.fargs[1])
        end,
        { nargs = 1 }
    },
}) do
    vim.api.nvim_create_user_command(unpack(cmd))
end
