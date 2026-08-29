-- TM_SELECTED_TEXT The currently selected text or the empty string
-- TM_CURRENT_LINE The contents of the current line
-- TM_CURRENT_WORD The contents of the word under cursor or the empty string
-- TM_LINE_INDEX The zero-index based line number
-- TM_LINE_NUMBER The one-index based line number
-- TM_FILENAME The filename of the current document
-- TM_FILENAME_BASE The filename of the current document without its extensions
-- TM_DIRECTORY The directory of the current document
-- TM_FILEPATH The full file path of the current document

---@type LazySpec
return {
  -- Luasnip use following address to 
  "L3MON4D3/LuaSnip",
  config = function(plugin, opts)
    local luasnip = require "luasnip"

    local function remove_broken_forr()
      local removed = false

      for _, snippet in ipairs(luasnip.get_snippets "go") do
        if snippet.trigger == "forr" and snippet.name == "for range statement" then
          snippet:invalidate()
          removed = true
        end
      end

      if removed then luasnip.clean_invalidated { inv_limit = 0 } end
    end

    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("user_go_snippet_overrides", { clear = true }),
      pattern = "LuasnipSnippetsAdded",
      callback = remove_broken_forr,
    })

    require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
    -- load snippets paths
    require("luasnip.loaders.from_vscode").lazy_load {
      paths = { vim.fn.stdpath "config" .. "/snippets" },
      -- User snippets must win over snippets with the same trigger from friendly-snippets.
      override_priority = 2000,
    }

    remove_broken_forr()
  end,
}
