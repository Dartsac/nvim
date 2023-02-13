local M = {} -- Define a table M to store the functions and variables related to the code

-- Attempt to load the 'cmp_nvim_lsp' module, and store the result in 'status_cmp_ok'
local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
-- If the module cannot be loaded, return without doing anything
if not status_cmp_ok then
	return
end

-- Initialize the 'capabilities' table with a new client capabilities table generated by 'make_client_capabilities'
M.capabilities = vim.lsp.protocol.make_client_capabilities()
-- Enable snippet support in completion items
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
-- Call the 'default_capabilities' function from the 'cmp_nvim_lsp' module and update 'M.capabilities' with the result
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

-- Define the 'setup' function to set up various components of the code
M.setup = function()
	-- Define a table of signs for different diagnostic messages
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	-- Define each sign in the 'signs' table
	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	-- Define a table of configuration options for diagnostics
	local config = {
		virtual_text = false, -- Disable virtual text, which adds the diagnostic text given using gd, inline
		signs = {
			active = signs, -- Show signs for diagnostics
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	-- Call the 'config' function from the 'vim.diagnostic' module to set the diagnostics configuration options
	vim.diagnostic.config(config)

	-- Set the 'hover' handler for 'textDocument/hover' LSP request to a new handler that includes a border option
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})
	-- Set the 'signature_help' handler for 'textDocument/signatureHelp' LSP request to a new handler that includes a border option
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

-- local function to define keymaps for LSP features in Vim
local function lsp_keymaps(bufnr, isTsserver)
	-- table to store options for key mappings
	local opts = { noremap = true, silent = true }
	-- shorthand for setting key maps
	local keymap = vim.api.nvim_buf_set_keymap

	-- noremap and silent options are passed in opts table to each key mapping
	-- gD maps to jump to declaration
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	-- gd maps to jump to definition
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	-- K maps to show hover information
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	-- gI maps to jump to implementation
	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	-- gr maps to show references
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	-- gl maps to open diagnostics in floating window
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	-- <leader>lf maps to format the buffer asynchronously
	keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
	-- <leader>li maps to show information of the current symbol
	keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
	-- <leader>lI maps to show information of the package to install
	keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<cr>", opts)
	-- <leader>la maps to show code actions
	keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	-- <leader>lj maps to navigate to next diagnostic
	keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
	-- <leader>lk maps to navigate to previous diagnostic
	keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
	-- <leader>lr maps to trigger renaming of a symbol
	keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	-- <leader>ls maps to show signature help
	keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	-- <leader>lq maps to set location list for diagnostincs
	keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	if isTsserver == true then
		keymap(bufnr, "n", "<leader>o", "<cmd>TypescriptAddMissingImports<CR>", opts)
		keymap(bufnr, "n", "<leader>r", "<cmd>TypescriptRemoveUnused<CR>", opts)
	end

	-- Format on save
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
		buffer = bufnr,
		callback = function()
			if isTsserver == true then
				-- I might want to remove the removeUnused function because this deletes entire functions before I have the chance to call them
				-- require("typescript").actions.removeUnused({ sync = true })
				require("typescript").actions.organizeImports({ sync = true })
			end
			vim.lsp.buf.format({ async = false }, function()
				vim.api.nvim_command("w")
			end)
		end,
	})
end

M.on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.name == "sumneko_lua" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.name ~= "tsserver" then
		lsp_keymaps(bufnr, false)
	else
		lsp_keymaps(bufnr, true)
	end

	local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
		return
	end
	illuminate.on_attach(client)
end

return M
