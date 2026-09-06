local set_mappings = require("astrocore").set_mappings
local utils = require "utils"

local function create_buf_config_file()
  local source_file = vim.fn.stdpath "config" .. "/buf.yaml"
  local target_file = vim.fn.getcwd() .. "/buf.yaml"
  utils.copy_file(source_file, target_file)
end

local function create_buf_gen_config_file()
  local source_file = vim.fn.stdpath "config" .. "/buf.gen.yaml"
  local target_file = vim.fn.getcwd() .. "/buf.gen.yaml"
  utils.copy_file(source_file, target_file)
end

local function formatting()
  local system_config = vim.fn.stdpath "config" .. "/buf.yaml"
  local project_config = vim.fn.getcwd() .. "/buf.yaml"

  local format_args = { "--config" }
  if vim.fn.filereadable(project_config) == 1 then
    table.insert(format_args, project_config)
  else
    table.insert(format_args, system_config)
  end
  return format_args
end

-- 以函数形式定义 linter：nvim-lint 每次运行前都会调用求值，
-- --config 跟随当前 cwd 动态解析，且只在配置文件真实存在时才传入
local function buf_lint()
  local linter = vim.deepcopy(require "lint.linters.buf_lint")
  local project_config = vim.fn.getcwd() .. "/buf.yaml"
  local system_config = vim.fn.stdpath "config" .. "/buf.yaml"
  local config = vim.fn.filereadable(project_config) == 1 and project_config or system_config
  if vim.fn.filereadable(config) == 1 then vim.list_extend(linter.args, { "--config", config }) end
  return linter
end

---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      ---@diagnostic disable: missing-fields
      config = {
        -- lspconfig 已将 bufls 改名为 buf_ls（由 buf CLI 的 buf beta lsp 提供）
        buf_ls = {
          filetypes = { "proto" },
          single_file_support = true,
          on_attach = function()
            set_mappings({
              n = {
                ["<Leader>lc"] = {
                  function()
                    local buf_path = vim.fn.getcwd() .. "/buf.yaml"
                    local buf_gen_path = vim.fn.getcwd() .. "/buf.gen.yaml"
                    if not utils.file_exists(buf_path) then
                      local confirm =
                        vim.fn.confirm("File `buf.yaml` Not Exist, Create it?", "&Yes\n&No", 1, "Question")
                      if confirm == 1 then create_buf_config_file() end
                    end

                    if not utils.file_exists(buf_gen_path) then
                      local confirm =
                        vim.fn.confirm("File `buf.gen.yaml` Not Exist, Create it?", "&Yes\n&No", 1, "Question")
                      if confirm == 1 then create_buf_gen_config_file() end
                    end
                  end,
                  desc = "Create Buf Config File",
                },
              },
            }, { buffer = true })
          end,
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      -- Ensure that opts.ensure_installed exists and is a table or string "all".
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "proto" })
      end
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      -- buf-language-server 已被上游归档并从 mason registry 移除，
      -- LSP 能力并入 buf CLI 本体（buf beta lsp），只装 buf 即可
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "buf" })
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        buf = {
          prepend_args = formatting(),
        },
      },
      formatters_by_ft = {
        proto = { "buf" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        buf_lint = buf_lint,
      },
      linters_by_ft = {
        proto = { "buf_lint" },
      },
    },
  },
}

