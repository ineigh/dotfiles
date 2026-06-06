vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = true })
end)

-- lazy
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

require("config.options")

require("lazy").setup({
	{
		"rktjmp/lush.nvim",
		lazy = false,
	},
	-- oblivion theme
	{
		"cloudUser98/oblivion.nvim",
		dependencies = { "rktjmp/lush.nvim" },
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("oblivion")

			-- transparency overrides
			local transparent = {
				"Normal",
				"NormalFloat",
				"SignColumn",
				"LineNr",
				"CursorLineNr",
				"EndOfBuffer",
			}

			for _, group in ipairs(transparent) do
				vim.api.nvim_set_hl(0, group, { bg = "none" })
			end
		end,
	},

	{
		"williamboman/mason.nvim",
		config = true,
	},
	-- conform formatter
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		opts = {
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},

			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				rust = { "rustfmt" },
				sh = { "shfmt" },
				bash = { "shfmt" },
			},
		},
	},

	{ import = "plugins" },
}) --endoflazy
