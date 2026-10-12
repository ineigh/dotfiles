require("theme")
require("formatter")
require("lsp")
require("blink")
require("treesitter")

vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("$HOME/dotfiles/.nvimhis/")
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.linebreak = true

vim.diagnostic.config({
	-- virtual_text = {
	-- spacing = 2,
	-- prefix = "⇇",
	-- },
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
	},
})

vim.o.background = "dark"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = true })
end)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
