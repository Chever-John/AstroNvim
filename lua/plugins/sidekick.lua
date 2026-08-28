---@type LazySpec
return {
  "folke/sidekick.nvim",
  cmd = "Sidekick",
  keys = {
    {
      "<Leader>aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Toggle AI CLI",
    },
    {
      "<Leader>as",
      function() require("sidekick.cli").select { filter = { installed = true } } end,
      desc = "Select AI CLI",
    },
    {
      "<Leader>at",
      function() require("sidekick.cli").send { msg = "{this}" } end,
      mode = { "n", "x" },
      desc = "Send context to AI",
    },
    {
      "<Leader>av",
      function() require("sidekick.cli").send { msg = "{selection}" } end,
      mode = "x",
      desc = "Send selection to AI",
    },
    {
      "<Leader>ap",
      function() require("sidekick.cli").prompt() end,
      desc = "Select AI prompt",
    },
  },
  opts = {
    nes = { enabled = false },
  },
}
