local sql_ft = { "sql", "mysql", "plsql" }

local utils = require "utils"
local astrocore = require "astrocore"
local set_mappings = astrocore.set_mappings

local function create_sqlfluff_config_file()
  local source_file = vim.fn.stdpath "config" .. "/.sqlfluff"
  local target_file = vim.fn.getcwd() .. "/.sqlfluff"
  utils.copy_file(source_file, target_file)
end

local function formatting() return { "--dialect", "polyglot" } end

-- 以函数形式定义 linter：nvim-lint 每次运行前都会调用求值，
-- --config 跟随当前 cwd 动态解析，且只在配置文件真实存在时才传入。
-- 有 config 时替换掉默认 --dialect=ansi（dialect 交由配置文件决定）。
local function sqlfluff()
  local linter = vim.deepcopy(require "lint.linters.sqlfluff")
  local project_config = vim.fn.getcwd() .. "/.sqlfluff"
  local system_config = vim.fn.stdpath "config" .. "/.sqlfluff"
  local config = vim.fn.filereadable(project_config) == 1 and project_config or system_config
  if vim.fn.filereadable(config) == 1 then
    linter.args = { "lint", "--format=json", "--config", config }
  end
  return linter
end

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        auto_create_sqlfluff_config_file = {
          {
            event = "FileType",
            desc = "create completion",
            pattern = sql_ft,
            callback = function()
              set_mappings({
                n = {
                  ["<Leader>lc"] = {
                    create_sqlfluff_config_file,
                    desc = "Create sqlfluff config file",
                  },
                },
              }, { buffer = true })
            end,
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = astrocore.list_insert_unique(opts.ensure_installed, { "sql" })
      end
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "sqlfluff", "sqlfmt" })
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        sqlfmt = {
          prepend_args = formatting(),
        },
      },
      formatters_by_ft = {
        sql = { "sqlfmt" },
        dbt = { "sqlfmt" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        sqlfluff = sqlfluff,
      },
      linters_by_ft = {
        sql = { "sqlfluff" },
        dbt = { "sqlfluff" },
      },
    },
  },
}

