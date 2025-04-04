# Comment.lua Plugin

GitHub Repo: https://github.com/numToStr/Comment.nvim

## 问题

我对于这个插件的配置，只有一个文件夹

```shell
~/.config/nvim  tree lua      
lua
├── community.lua
├── lazy_setup.lua
├── mapping.lua
├── plugins
│   ├── ............
│   ├── comment.lua
│   ├── ............
│   └── user.lua
├── polish.lua
├── ui.lua
└── utils.lua

2 directories, 60 files

```

代码很简单如下：

```lua
---@type LazySpec
return {
  "numToStr/Comment.nvim",
  opts = function()
    local ft = require "Comment.ft"
    ft.thrift = { "//%s", "/*%s*/" }
    ft.goctl = { "//%s", "/*%s*/" }
  end,
  specs = {
    {
      "AstroNvim/astrocore",
      ---@param opts AstroCoreOpts
      opts = function(_, opts)
        local maps = require("astrocore").empty_map_table()
        maps.n["<C-_>"] = opts.mappings.n["<Leader>/"]
        maps.x["<C-_>"] = opts.mappings.x["<Leader>/"]
        -- end
        maps.n["<Leader>/"] = false
        maps.x["<Leader>/"] = false

        opts.mappings = require("astrocore").extend_tbl(opts.mappings, maps)
      end,
    },
  },
}
```

但是需要结合 alacritty 的 keybinding 配置，如下：

```toml
# Comment.Nvim plugin
[[keyboard.bindings]]
key = "Slash"
mods = "Control"
chars = "\u001f"
```

然后我只需要在我的 macos 电脑上使用 "control + /" 就可以实现单行 comment 了。