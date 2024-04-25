vim.g.mapleader = " "

-- HACK (BL): wsl support
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

vim.paste = (function(lines, _)
    vim.cmd [[set paste]]
    vim.api.nvim_put(lines, 'c', true, true)
    vim.cmd [[set nopaste]]
end)

return {
    options = function(opts)
        vim.opt.isfname:append("@-@")
        for opt, v in pairs(opts) do
            vim.opt[opt] = v
        end
    end,

    keymaps = function(tbls)
        for _, tbl in pairs(tbls) do
            vim.keymap.set(unpack(tbl))
        end
    end,

    autocmds = function(cmds)
        for _, cmd in ipairs(cmds) do
            require "utils".nvim_create_au(unpack(cmd))
        end
    end,

    listchars = function(lcs)
        vim.cmd("set listchars=" .. table.concat(lcs, ","))
        vim.cmd("set list")
    end,

    disable_plugins = function(names)
        for _, plugin in pairs(names) do
          vim.g["loaded_" .. plugin] = 1
        end
    end,

    commands = function(cmds)
        for _, cmd in pairs(cmds) do
            vim.api.nvim_create_user_command(unpack(cmd))
        end
    end,
}
