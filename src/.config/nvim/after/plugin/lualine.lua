local devicons = require('nvim-web-devicons')

local navic = require('nvim-navic')
--
-- local is_empty = function (s)
--     return s == nil or s == ''
-- end
--
-- local winbar_file_components = function ()
--     local value = ' '
--     local file_name = vim.fn.expand('%:t')
--
--     if is_empty(file_name) then return end
--     local file_type = vim.fn.expand('%:e')
--     local file_path = vim.fn.expand('%:~:.:h')
--     print(file_path)
--
--     local file_path_list = {}
--
--     local _ = string.gsub(file_path, '[^/]+', function(w)
--         table.insert(file_path_list, w)
--     end)
--
--     for i = 1, #file_path_list do
--         print(file_path_list[i])
--         print(string.sub(file_path_list[i], 1, 1))
--         value = value .. string.sub(file_path_list[i], 1, 1) .. '/'
--     end
--
--     value = ' %#WinBarPath#' .. value
--
--     local file_icon = devicons.get_icon(file_name, file_type, { default = false })
--
--     if not is_empty(file_icon) then
--         file_icon = "%#DevIcon" .. '#' .. file_icon .. ' %*'
--     else
--         file_icon = ''
--     end
--
--     for i = 1, #file_path_list do
--         value = value .. string.sub(file_path_list[i], 1, 1) .. '/'
--     end
--
--     file_name = "%#DevIcon" .. '#' .. file_icon .. ' %*%#WinBarFile#' .. file_name .. '%*'
--
--     print(value)
--     print(file_name)
--     print(file_icon)
--     return {
--         lualine_a = {},
--         lualine_b = {},
--         lualine_c = { value },
--         lualine_x = { file_name },
--         lualine_y = { navic.get_location, navic.is_available},
--         lualine_z = {},
--     }
-- end

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'gruvbox',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {'NVimTree'},
            winbar = {'NVimTree'},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    }, inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {
        lualine_a = {'filename'},
        lualine_b = { navic.get_location },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    extensions = {}
}

vim.cmd('set laststatus=3') -- set global statusline
vim.cmd('highlight WinSeparator guibg=None') -- set global statusline
