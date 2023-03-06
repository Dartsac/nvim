local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local actions = require("telescope.actions")
local cwd = vim.fn.getcwd()

telescope.setup({
	defaults = {
		-- prompt_prefix = " ",
		-- selection_caret = " ",
		-- path_display = { "smart" },

		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<Tab>"] = actions.move_selection_worse,
				["<S-Tab>"] = actions.move_selection_better,

				["<esc>"] = actions.close,
				["<CR>"] = actions.select_default,
			},
		},
	},
	pickers = {
		-- Default configuration for builtin pickers goes here:
		-- picker_name = {
		--   picker_config_key = value,
		--   ...
		-- }
		-- Now the picker_config_key will be applied every time you call this
		-- builtin picker
	},
	extensions = {
		-- Your extension configuration goes here:
		-- extension_name = {
		--   extension_config_key = value,
		-- }
		-- please take a look at the readme of the extension you want to configure
	},
})

vim.api.nvim_set_keymap("n", "<C-f>", ":Telescope find_files cwd=" .. cwd .. "<CR>", { noremap = true, silent = true })
