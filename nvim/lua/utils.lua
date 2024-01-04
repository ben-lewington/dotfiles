local set_transparent = function(comps)
    for _, comp in pairs(comps) do
        vim.api.nvim_set_hl(0, comp, { bg = "none" })
    end
end

return {
    colorscheme_transparent = function(name)
        vim.cmd.colorscheme(name)
        set_transparent {
            "Normal",
            "NormalFloat",
            "LineNr",
            "SignColumn",
            "NormalNC",
        }
    end,

    nvim_create_au = function(grp, cmd, cmd_tbl)
        vim.api.nvim_create_augroup(grp, {})
        vim.api.nvim_create_autocmd(cmd, cmd_tbl)
    end,

    run_setup = function(s, d)
        return function(keys)
            for _, key in pairs(keys) do
                s[key](d[key])
            end
        end
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
