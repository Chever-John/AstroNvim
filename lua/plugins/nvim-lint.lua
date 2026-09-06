local lint -- cache for the nvim-lint package
---@type LazySpec
return {
  "mfussenegger/nvim-lint",
  --- The event = "User AstroFile" ensures `nvim-lint` loads only after the AstroNvim file is loaded, optimizing startup time.
  event = "User AstroFile",
  --- specifies mason.nvim as a dependency for managing LSP servers and linters.
  dependencies = { "williamboman/mason.nvim" },
  specs = {
    {
      -- `nvim-lint` just check code and does not know when can be called in the AstroNvim.
      -- astrocore acts as bridge between nvim-lint and NeoVim.
      -- we use the autocmds mechanism.
      "AstroNvim/astrocore",
      ---@param opts AstroCoreOpts
      opts = function(_, opts)
        local timer = (vim.uv or vim.loop).new_timer()

        if not opts.autocmds then opts.autocmds = {} end

        -- The code sets up autocommands to trigger linting on various events: BufWritePost, BufWritePost, InsertLeave and TextChanged.
        -- A timer is used to slightly delay the linting process, preventing excessive calls.
        opts.autocmds.auto_lint = {
          {
            event = { "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" },
            desc = "Automatically lint with nvim-lint",
            callback = function()
              -- only run autocommand when nvim-lint is loaded
              if lint then
                timer:start(100, 0, function()
                  timer:stop()
                  vim.schedule(lint.try_lint)
                end)
              end
            end,
          },
        }
      end,
    },
  },
  opts = {},
  config = function(_, opts)
    local astrocore = require "astrocore"
    lint = require "lint"
    lint.linters_by_ft = opts.linters_by_ft or {}
    for name, linter in pairs(opts.linters or {}) do
      local base = lint.linters[name]
      lint.linters[name] = (type(linter) == "table" and type(base) == "table")
          and vim.tbl_deep_extend("force", base, linter)
        or linter
    end

    local valid_linters = function(ctx, linters)
      if not linters then return {} end
      return vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        -- nvim-lint 支持把 linter 定义为返回配置表的函数，运行前先求值
        if type(linter) == "function" then
          local ok, resolved = pcall(linter)
          if not ok then return false end
          linter = resolved
        end
        if type(linter) ~= "table" then return false end
        -- 支持自定义 condition 字段（如 selene 仅在有 selene.toml 时启用）
        if linter.condition and not linter.condition(ctx) then return false end
        local cmd = type(linter.cmd) == "function" and linter.cmd() or linter.cmd
        return type(cmd) ~= "string" or vim.fn.executable(cmd) == 1
      end, linters)
    end

    -- rewrite the _resolve_linter_by_ft func to redefine the linter search preffer level.
    lint._resolve_linter_by_ft = astrocore.patch_func(lint._resolve_linter_by_ft, function(orig, ...)
      local ctx = { filename = vim.api.nvim_buf_get_name(0) }
      ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")

      local linters = valid_linters(ctx, orig(...))
      if not linters[1] then linters = valid_linters(ctx, lint.linters_by_ft["_"]) end -- fallback
      astrocore.list_insert_unique(linters, valid_linters(ctx, lint.linters_by_ft["*"])) -- global

      return linters
    end)

    lint.try_lint()
  end,
}

