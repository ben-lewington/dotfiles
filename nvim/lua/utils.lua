return {
    -- set keymaps by spreading each table in a table of tables
    keymaps = function(tbls)
        for _, tbl in pairs(tbls) do
            vim.keymap.set(unpack(tbl))
        end
    end,

    -- set glyph mapping for listchars
    set_listchars = function(lcs)
        vim.cmd("set listchars=" .. table.concat(lcs, ","))
        vim.cmd("set list")
    end,

    -- Disable builtin plugins
    disable_plugins = function (names)
        for _, plugin in pairs(names) do
          vim.g["loaded_" .. plugin] = 1
        end
    end,

    -- set screenbackground as transparent for a list of components
    set_transparent = function(comps)
        for _, comp in pairs(comps) do
            vim.api.nvim_set_hl(0, comp, { bg = "none" })
        end
    end,

    -- create an augroup with an autocmd
    nvim_create_au = function(grp, cmd, cmd_tbl)
        vim.api.nvim_create_augroup(grp, {})
        vim.api.nvim_create_autocmd(cmd, cmd_tbl)
    end,

    -- bootstrap the plugin manager
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
