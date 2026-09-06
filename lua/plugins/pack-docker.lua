local utils = require "astrocore"

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      filetypes = {
        filename = { ["docker-compose.yaml"] = "yaml.docker-compose", ["docker-compose.yml"] = "yaml.docker-compose" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "dockerfile" })
      end
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(
        opts.ensure_installed,
        { "docker-compose-language-service", "dockerfile-language-server", "hadolint" }
      )
    end,
  },
  {
    "stevearc/conform.nvim", 
    optional = true,
    opts = {
      formatters_by_ft = {
        ["yaml.docker-compose"] = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        -- hadolint 是 Dockerfile linter；原先挂在 "docker-compose" 上既与实际
        -- filetype（yaml.docker-compose）不匹配，语义上也不对
        dockerfile = { "hadolint" },
      },
    },
  },
}

