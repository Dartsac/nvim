local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
	return
end

require("user.miniicons")

local tree_cb = nvim_tree_config.nvim_tree_callback

local icons = require("user.icons")

nvim_tree.setup({
	update_focused_file = {
		enable = true,
		update_cwd = true,
	},
	actions = {
		open_file = { quit_on_open = true },
	},
	renderer = {
		root_folder_modifier = ":t",
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				folder = {
					arrow_open = "",
					arrow_closed = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					untracked = "U",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
			hint = icons.diagnostics.BoldHint,
			info = icons.diagnostics.BoldInformation,
			warning = icons.diagnostics.BoldWarning,
			error = icons.diagnostics.BoldError,
		},
	},
	view = {
		width = 30,
		side = "left",
		mappings = {
			list = {
				{ key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
				{ key = "h", cb = tree_cb("close_node") },
				{ key = "v", cb = tree_cb("vsplit") },
			},
		},
	},
})

vim.api.nvim_set_keymap(
	"n", -- Normal mode
	"+", -- Increase size
	[[:lua if require("nvim-tree.view").is_visible() then vim.cmd("NvimTreeResize +5") end<CR>]],
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	"n", -- Normal mode
	"=", -- Decrease size
	[[:lua if require("nvim-tree.view").is_visible() then vim.cmd("NvimTreeResize -5") end<CR>]],
	{ noremap = true, silent = true }
)
