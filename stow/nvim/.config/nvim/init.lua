vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = true })
end)

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

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

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "buffer" },
				}),
			})
		end,
	},

	{ import = "plugins" },
}) --endoflazy
