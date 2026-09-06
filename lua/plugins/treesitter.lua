-- Neovim 0.12 移除了 query predicate/directive 注册时 `all = false` 的兼容层，
-- 而 nvim-treesitter master 分支（已归档，无后续修复）注册的 handler 仍假设
-- match[capture_id] 是单个 TSNode。0.12 实际传入 TSNode 列表，导致打开 markdown
-- 等带注入查询的文件时报 "attempt to call method 'range' (a nil value)"。
-- 下面在插件加载完成后用 force 重新注册受影响的 handler，同时兼容两种格式。
-- 迁移到 nvim-treesitter main 分支后应删除本 shim。
local function patch_treesitter_query_handlers()
	local query = vim.treesitter.query

	---@param entry TSNode|TSNode[]|nil
	---@return TSNode|nil
	local function to_node(entry)
		if type(entry) == "table" then
			return entry[#entry]
		end
		return entry
	end

	local html_script_type_languages = {
		["importmap"] = "json",
		["module"] = "javascript",
		["application/ecmascript"] = "javascript",
		["text/ecmascript"] = "javascript",
	}

	local injection_aliases = {
		ex = "elixir",
		pl = "perl",
		sh = "bash",
		uxn = "uxntal",
		ts = "typescript",
	}

	local opts = { force = true }

	query.add_predicate("nth?", function(match, _, _, pred)
		local node = to_node(match[pred[2]])
		local n = tonumber(pred[3])
		if node and n and node:parent() and node:parent():named_child_count() > n then
			return node:parent():named_child(n) == node
		end
		return false
	end, opts)

	query.add_predicate("is?", function(match, _, bufnr, pred)
		local locals = require("nvim-treesitter.locals")
		local node = to_node(match[pred[2]])
		if not node then
			return true
		end
		local _, _, kind = locals.find_definition(node, bufnr)
		return vim.tbl_contains({ unpack(pred, 3) }, kind)
	end, opts)

	query.add_predicate("kind-eq?", function(match, _, _, pred)
		local node = to_node(match[pred[2]])
		if not node then
			return true
		end
		return vim.tbl_contains({ unpack(pred, 3) }, node:type())
	end, opts)

	query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
		local node = to_node(match[pred[2]])
		if not node then
			return
		end
		local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
		local configured = html_script_type_languages[type_attr_value]
		if configured then
			metadata["injection.language"] = configured
		else
			local parts = vim.split(type_attr_value, "/", {})
			metadata["injection.language"] = parts[#parts]
		end
	end, opts)

	query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
		local node = to_node(match[pred[2]])
		if not node then
			return
		end
		local alias = vim.treesitter.get_node_text(node, bufnr):lower()
		metadata["injection.language"] = vim.filetype.match({ filename = "a." .. alias })
			or injection_aliases[alias]
			or alias
	end, opts)

	query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
		local id = pred[2]
		local node = to_node(match[id])
		if not node then
			return
		end
		local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
		if not metadata[id] then
			metadata[id] = {}
		end
		metadata[id].text = string.lower(text)
	end, opts)
end

if vim.fn.has("nvim-0.12") == 1 then
	-- AstroNvim 在启动 init 阶段就会 require query_predicates（原版注册），
	-- 这里主动先 require 让原版注册完成，随后立即用 force 覆盖。
	-- 之后任何 require 都命中缓存，不会再把原版 handler 覆盖回来。
	pcall(require, "nvim-treesitter.query_predicates")
	pcall(patch_treesitter_query_handlers)
end

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
		highlight = { enable = true },
		indent = { enable = true },
		ignore_install = { "latex" },
	},
}
