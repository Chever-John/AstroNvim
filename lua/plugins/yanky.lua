---@type LazySpec
return {
  "gbprod/yanky.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-telescope/telescope.nvim" },
  keys = {
    {
      "<Leader>fy",
      function() require("telescope").extensions.yank_history.yank_history() end,
      mode = { "n", "x" },
      desc = "Find yank history",
    },
  },
  opts = {
    ring = {
      history_length = 100,
      storage = "shada",
    },
  },
  config = function(_, opts)
    require("yanky").setup(opts)
    require("telescope").load_extension "yank_history"
  end,
}
