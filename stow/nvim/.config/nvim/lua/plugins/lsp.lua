return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"clangd",
					"bashls",
					"html",
					"cssls",
					"jsonls",
					"intelephense",
				},
			})

			vim.lsp.config("clangd", {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--header-insertion=iwyu",
					"--suggest-missing-includes",
					"--all-scopes-completion",
					"--fallback-style=llvm",
					"--log=verbose",
				},
				init_options = {
					clangdFileStatus = true,
				},
			})
		end,
	},
}
