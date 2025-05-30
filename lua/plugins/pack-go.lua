--TODO: https://github.com/golang/go/issues/60903
local set_mappings = require("astrocore").set_mappings

local function preview_stack_trace()
	local current_line = vim.api.nvim_get_current_line()
	local patterns_list = {
		"([^%s]+/[^%s]+%.go):(%d+)", -- 匹配文件路径和行号
	}

	local function try_patterns(patterns, line)
		for _, pattern in ipairs(patterns) do
			local filepath, line_nr = string.match(line, pattern)
			if filepath and line_nr then
				return filepath, tonumber(line_nr), 0
			end
		end
		return nil, nil, nil
	end

	local filepath, line_nr, column_nr = try_patterns(patterns_list, current_line)
	if filepath then
		vim.cmd(":wincmd k")
		vim.cmd("e " .. filepath)
		vim.api.nvim_win_set_cursor(0, { line_nr, column_nr })
	end
end

-- NOTE: gopls commands
-- GoTagAdd add tags
-- GOTagRm remove tags
-- GoCmt add cmt
-- GoFillStruct	auto fill struct
-- GoFillSwitch	fill switch
-- GoIfErr	Add if err
-- GoFixPlurals	change func foo(b int, a int, r int) -> func foo(b, a, r int)

---@type LazySpec
return {
	{
		"AstroNvim/astrocore",
		---@type AstroCoreOpts
		opts = { filetypes = { extension = { api = "goctl" } } },
	},
	{
		"AstroNvim/astrolsp",
		optional = true,
		---@type AstroLSPOpts
		opts = {
			---@diagnostic disable: missing-fields
			config = {
				gopls = {
					on_attach = function(client, _)
						-- 下面这行代码创建了一个自动命令，该自动命令会在终端打开、终端关闭或进入缓冲区时触发。
						vim.api.nvim_create_autocmd({ "TermOpen", "TermClose", "BufEnter" }, {
							-- pattern 匹配所有文件
							pattern = "*",
							desc = "Jump to error line from pack-go",
							-- callback 自动命令的回调函数
							callback = function()
								-- 获取当前缓冲区的名字
								local buf_name = vim.api.nvim_buf_get_name(0)
								if vim.bo.filetype == "dap-repl" and buf_name:match("%[dap%-repl%-%d+%]") then
									set_mappings({
										n = {
											["gd"] = {
												preview_stack_trace,
												desc = "Jump to error line",
											},
										},
									}, { buffer = true })
								end
							end,
						})

						set_mappings({
							n = {
								["<Leader>fi"] = {
									[[<cmd>lua require'telescope'.extensions.goimpl.goimpl{}<CR>]],
									desc = "Find Go interface implementation",
								},
							},
						}, { buffer = true })

						if not client.server_capabilities.semanticTokensProvider then
							local semantic = client.config.capabilities.textDocument.semanticTokens
							client.server_capabilities.semanticTokensProvider = {
								full = true,
								legend = {
									tokenTypes = semantic.tokenTypes,
									tokenModifiers = semantic.tokenModifiers,
								},
								range = true,
							}
						end
					end,
					settings = {
						gopls = {
							analyses = {
								ST1003 = false,
								SA5008 = false,
								fieldalignment = false,
								fillreturns = true,
								nilness = true,
								nonewvars = true,
								shadow = true,
								undeclaredname = true,
								unreachable = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							codelenses = {
								gc_details = false, -- Show a code lens toggling the display of gc's choices.
								generate = true, -- show the `go generate` lens.
								regenerate_cgo = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							completeUnimported = true,
							diagnosticsDelay = "500ms",
							gofumpt = true,
							matcher = "Fuzzy",
							semanticTokens = true,
							staticcheck = true,
							symbolMatcher = "fuzzy",
							usePlaceholders = false,
						},
					},
				},
			},
		},
	},
	-- Golang support
	-- I am tring to config the nvim-treesitter plugin with specific enhancements for Go Development in Neovim.
	{
		"nvim-treesitter/nvim-treesitter",
		-- optional: Plugin won't couse errors if not installed
		optional = true,
		opts = function(_, opts)
			-- Configuration login here
			--
			-- This section ensures that all Go-related parsers are installed:
			-- `go`: Main Go language parser;
			-- `gomod`: Parser for go.mod files;
			-- `gosum`: Parser for go.sum files;
			-- `gowork`: Parser for go.work files;
			if opts.ensure_installed ~= "all" then
				opts.ensure_installed =
					require("astrocore").list_insert_unique(opts.ensure_installed, { "go", "gomod", "gosum", "gowork" })
			end

			-- treesitter indentation Configuration
			-- This:
			-- 1. Ensures the indent table exists;
			-- 2. Enables treesitter indentation globally;
			-- 3. Makes sure Go isn't in the list of languages with disabled indentation.
			opts.indent = opts.indent or {}
			opts.indent.enabled = true
			-- The `vim.tbl_filter` function creates a new table containing only elems where the callback returns true - effectively removing "go" from the disable list if it exists.
			if opts.indent.disable then
				opts.indent.disable = vim.tbl_filter(function(lang)
					return lang ~= "go"
				end, opts.indent.disable)
			end

			-- Auto Bracket Handing for Go
			-- This creates an autocommand that triggers when editing Go files to set up two helpful key mappings:
			-- 1. When you type [ and press Enter in insert mode:
			--		1.1 It will insert [ and ] on separate lines;
			--		1.2 Place your cursor on a new line between the Brackets
			-- 2. When you type { and press Enter in insert mode:
			--		2.1It will insert { and } on separate lines
			--		2.2 Place your cursor on a new line between the braces 
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "go",
				callback = function()
					vim.keymap.set("i", "[<CR>", "[<CR>]<ESC>O", { buffer = true, silent = true })
					vim.keymap.set("i", "{<CR>", "{<CR>}<ESC>O", { buffer = true, silent = true })
				end,
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		optional = true,
		opts = function(_, opts)
			opts.ensure_installed = require("astrocore").list_insert_unique(
				opts.ensure_installed,
				{ "delve", "gopls", "gomodifytags", "gotests", "iferr", "impl", "goimports" }
			)
		end,
	},
	{
		"mfussenegger/nvim-dap",
		optional = true,
		dependencies = {
			{
				"leoluz/nvim-dap-go",
				opts = {},
			},
		},
	},
	{
		"edolphin-ydf/goimpl.nvim",
		ft = "go",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-lua/popup.nvim" },
			{ "nvim-telescope/telescope.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		config = function()
			require("telescope").load_extension("goimpl")
		end,
	},
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		build = function()
			if not require("lazy.core.config").spec.plugins["mason.nvim"] then
				vim.print("Installing go dependencies...")
				vim.cmd.GoInstallDeps()
			end
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{ "williamboman/mason.nvim", optional = true }, -- by default use Mason for go dependencies
		},
		opts = {},
	},
	{
		"nvim-neotest/neotest",
		optional = true,
		dependencies = { "nvim-neotest/neotest-go" },
		opts = function(_, opts)
			if not opts.adapters then
				opts.adapters = {}
			end
			table.insert(opts.adapters, require("neotest-go")(require("astrocore").plugin_opts("neotest-go")))
		end,
	},
	{
		"chaozwn/goctl.nvim",
		ft = "goctl",
		enabled = vim.fn.executable("goctl") == 1,
		opts = function()
			local group = vim.api.nvim_create_augroup("GoctlAutocmd", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = "goctl",
				callback = function()
					-- set up format keymap
					vim.keymap.set(
						"n",
						"<Leader>lf",
						"<Cmd>GoctlApiFormat<CR>",
						{ silent = true, noremap = true, buffer = true, desc = "Format Buffer" }
					)
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				go = { "goimports", lsp_format = "last" },
			},
		},
	},
	{
		"echasnovski/mini.icons",
		optional = true,
		opts = {
			file = {
				[".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
			},
			filetype = {
				gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
			},
		},
	},
}
