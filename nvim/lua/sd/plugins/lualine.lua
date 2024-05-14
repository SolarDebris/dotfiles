local status, lualine = pcall(require, "lualine")
if not status then
	return
end

local lualine_dracula = require("lualine.themes.dracula")

lualine.setup({
	options = {
        icons_enabled = true,
		theme = lualine_dracula,
        component_separators = { left = '|', right = '|'},
        section_separators = { left = ' ', right = ' '},
	},
})
