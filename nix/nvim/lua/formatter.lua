require("conform").setup({
	formatters_by_ft = {
		c = { "clang_format" },
		cpp = { "clang_format" },

		html = { "prettierd" },
		css = { "prettierd" },
		json = { "prettierd" },

		sh = { "shfmt" },

		nix = { "nixfmt" },

		lua = { "stylua" },
	},

	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
})
