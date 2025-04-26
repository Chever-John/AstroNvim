---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {
			"lua",
			"vim",
			"go",
			"python",
			-- add more arguments for adding more treesitter parsers
		},
		auto_install = true,
		highligh = { enable = true },
		indent = { enable = true },
		ignore_install = { "latex" },
	},
}
