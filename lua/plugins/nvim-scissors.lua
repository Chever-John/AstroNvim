---@type LazySpec
return {
  "chrisgrieser/nvim-scissors",
  dependencies = { "nvim-telescope/telescope.nvim" },
  cmd = { "ScissorsAddNewSnippet", "ScissorsEditSnippet" },
  keys = {
    {
      "<Leader>sa",
      function() require("scissors").addNewSnippet() end,
      mode = { "n", "x" },
      desc = "Snippet: Add",
    },
    {
      "<Leader>se",
      function() require("scissors").editSnippet() end,
      desc = "Snippet: Edit",
    },
  },
  opts = {
    snippetDir = vim.fn.stdpath "config" .. "/snippets",
    snippetSelection = {
      picker = "telescope",
      telescope = { alsoSearchSnippetBody = true },
    },
  },
}
