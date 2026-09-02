---@type LazySpec
return {
	"kawre/leetcode.nvim",
	cmd = "Leet",
	dependencies = {
		{ "nvim-telescope/telescope.nvim" },
		{ "nvim-lua/plenary.nvim" }, -- required by telescope
		{ "MunifTanjim/nui.nvim" },

		-- optional
		{ "rcarriga/nvim-notify", optional = true },
		{ "nvim-tree/nvim-web-devicons", optional = true },
		{
			"nvim-treesitter/nvim-treesitter",
			optional = true,
			opts = function(_, opts)
				if opts.ensure_installed ~= "all" then
					opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "html" })
				end
			end,
		},
		{
			"AstroNvim/astrocore",
			---@type AstroCoreOpts
			opts = {
				autocmds = {
					leetcode_autostart = {
						{
							event = "VimEnter",
							desc = "Start leetcode.nvim on startup",
							nested = true,
							callback = function()
								if vim.fn.argc() ~= 1 then
									return
								end -- return if more than one argument given
								local arg = vim.tbl_get(require("astrocore").plugin_opts("leetcode.nvim"), "arg")
									or "leetcode.nvim"
								if vim.fn.argv()[1] ~= arg then
									return
								end -- return if argument doesn't match trigger
								local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
								if #lines > 1 or (#lines == 1 and lines[1]:len() > 0) then
									return
								end -- return if buffer is non-empty
								require("leetcode").start(true)
							end,
						},
					},
				},
			},
		},
	},
	opts = function(_, opts)
		return {
			---@type lc.lang
			lang = "golang",

			-- leetcode.nvim 默认用 Conceal 渲染正文，oldworld 下几乎与背景同色。
			theme = {
				normal = { fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg },
			},

			cn = {
				enabled = true,
				translator = true,
				translate_problems = true,
			},

			---@type table<lc.lang, lc.inject>
			injector = {
				["golang"] = {
					-- //go:build ignore 让 gopls 把每道题当独立单文件处理
					-- （gopls 默认 standaloneTags 含 ignore），避免多道题
					-- 同属 package main 时互报 redeclared。
					-- build tag 与 package 之间必须留空行。
					before = { "//go:build ignore", "", "package main" },
					after = {
						"type ListNode struct {",
						"\tVal  int",
						"\tNext *ListNode",
						"}",
						"",
						"// Hello, Chever",
					},
				},
			},
		}
	end,
}
