vim.g.mapleader = " "

if os.getenv('WSL_DISTRO_NAME') ~= nil then
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

vim.paste = (function(lines, _)
    vim.cmd [[set paste]]
    vim.api.nvim_put(lines, 'c', true, true)
    vim.cmd [[set nopaste]]
end)

return {
    keymaps = function(tbls)
        for _, tbl in pairs(tbls) do
            vim.keymap.set(unpack(tbl))
        end
    end,

    set_listchars = function(lcs)
        vim.cmd("set listchars=" .. table.concat(lcs, ","))
        vim.cmd("set list")
    end,

    disable_plugins = function (names)
        for _, plugin in pairs(names) do
          vim.g["loaded_" .. plugin] = 1
        end
    end,

    set_transparent = function(comps)
        for _, comp in pairs(comps) do
            vim.api.nvim_set_hl(0, comp, { bg = "none" })
        end
    end,

    nvim_create_au = function(grp, cmd, cmd_tbl)
        vim.api.nvim_create_augroup(grp, {})
        vim.api.nvim_create_autocmd(cmd, cmd_tbl)
    end,

    plugin_manager = function(opts)
        local fn = vim.fn
        local data_path = vim.fn.stdpath("data") .. "/" .. opts.path

        vim.opt.rtp:prepend(data_path)

        if fn.empty(fn.glob(data_path)) > 0 then
            vim.fn.system({
                "git", "clone",
                "--depth", "1",
                "--filter=blob:none",
                opts.git,
                data_path,
            })
        end

        return require(opts.name)
    end,
}
