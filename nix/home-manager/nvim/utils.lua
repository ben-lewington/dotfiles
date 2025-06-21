return {
    ns = { noremap = true, silent = true },
    nvim_create_au = function(grp, cmd, cmd_tbl)
        vim.api.nvim_create_augroup(grp, {})
        vim.api.nvim_create_autocmd(cmd, cmd_tbl)
    end,
    colorscheme_transparent = function(name)
        vim.cmd.colorscheme(name)
        for _, comp in pairs({
            "Normal",
            "NormalFloat",
            "LineNr",
            "SignColumn",
            "NormalNC",
        }) do
            vim.api.nvim_set_hl(0, comp, { bg = "none" })
        end
    end,
}
