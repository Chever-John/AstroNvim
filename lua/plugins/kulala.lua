---@type LazySpec
return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  keys = {
    {
      "<Leader>Rs",
      function() require("kulala").run() end,
      ft = { "http", "rest" },
      desc = "Send request",
    },
    {
      "<Leader>Ra",
      function() require("kulala").run_all() end,
      ft = { "http", "rest" },
      desc = "Send all requests",
    },
    {
      "<Leader>Rr",
      function() require("kulala").replay() end,
      ft = { "http", "rest" },
      desc = "Replay last request",
    },
  },
  opts = {},
}
