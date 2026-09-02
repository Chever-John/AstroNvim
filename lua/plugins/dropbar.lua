local leetcode_root = vim.fs.normalize(vim.fn.stdpath("data") .. "/leetcode") .. "/"

local function is_leetcode_buffer(buf)
  local path = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
  return vim.startswith(path, leetcode_root)
end

local function leetcode_sources()
  local sources = require "dropbar.sources"
  return {
    require("dropbar.utils").source.fallback {
      sources.lsp,
      sources.treesitter,
    },
  }
end

return {
  "Bekaboo/dropbar.nvim",
  event = "UIEnter",
  opts = function(_, opts)
    local default_sources = vim.tbl_get(opts, "bar", "sources") or require("dropbar.configs").opts.bar.sources
    opts.bar = opts.bar or {}
    opts.bar.sources = function(buf, win)
      if is_leetcode_buffer(buf) then return leetcode_sources() end
      return default_sources(buf, win)
    end
  end,
  specs = {
    {
      "rebelot/heirline.nvim",
      optional = true,
      opts = function(_, opts)
        opts.winbar = nil
      end,
    },
  },
}
