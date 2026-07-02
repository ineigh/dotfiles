vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.linebreak = true

vim.diagnostic.config({
	virtual_text = {
		spacing = 2,
		-- prefix = "●",
		prefix = "⇇",
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always", -- show which tool produced the warning
	},
})
