require("theme")
require("formatter")
require("lsp")
require("blink")
require("treesitter")
require("nvim-tree").setup({
	sort = {
		sorter = "name",
		folders_first = true,
	},
	git = {
		enable = false,
	},
	renderer = {
		highlight_git = "none",
		highlight_diagnostics = "none",
		highlight_opened_files = "none",
		highlight_modified = "none",
	},
})

local function set_tree_colors()
	local highlights = {
		-- Background and text
		NvimTreeNormal = {
			fg = "#eeeeec",
			bg = "#303030",
		},
		NvimTreeNormalNC = {
			fg = "#eeeeec",
			bg = "#303030",
		},

		-- Folders
		NvimTreeFolderName = {
			fg = "#4a78b4",
		},
		NvimTreeOpenedFolderName = {
			fg = "#5c8bc5",
			bold = true,
		},
		NvimTreeRootFolder = {
			fg = "#82afd8",
			bold = true,
		},

		-- Files
		NvimTreeExecFile = {
			fg = "#73d216",
		},
		NvimTreeSpecialFile = {
			fg = "#edd400",
		},

		-- Structure
		NvimTreeEndOfBuffer = {
			fg = "#303030",
		},
		NvimTreeIndentMarker = {
			fg = "#555753",
		},
		NvimTreeCursorLine = {
			bg = "#3d3d3d",
		},
		NvimTreeWinSeparator = {
			fg = "#555753",
			bg = "#303030",
		},

		-- Symlinks
		NvimTreeSymlink = {
			fg = "#82afd8",
		},
	}

	for group, colors in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, colors)
	end
end

set_tree_colors()

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
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = true })
end)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
