vim.opt.guicursor = ""
vim.opt.mouse = "a"
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "100"

vim.g.mapleader = " "

if os.getenv('WSL_DISTRO_NAME') ~= nil then
    -- clipboard on WSL
    vim.g.clipboard = {
        name = "WslClipboard",
        copy = {
            ["+"] = "clip.exe" ,
            ["*"] = "clip.exe",
        },
        paste = {
            ["+"] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace(\"`r\", \"\"))",
            ["*"] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace(\"`r\", \"\"))",
        },
        cache_enabled = 0,
    }
end

vim.paste = (function(lines, _)
    vim.cmd [[set paste]]
    vim.api.nvim_put(lines, 'c', true, true)
    vim.cmd [[set nopaste]]
end)
