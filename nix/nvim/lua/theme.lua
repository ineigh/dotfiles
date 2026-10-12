vim.cmd.colorscheme("oblivion")

local transparent = {
	"Normal",
	"NormalFloat",
	"SignColumn",
	"LineNr",
	"CursorLineNr",
	"EndOfBuffer",
}

for _, group in ipairs(transparent) do
	vim.api.nvim_set_hl(0, group, {
		bg = "none",
	})
end
