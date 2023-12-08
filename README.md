# Filetype Based Template Plugin For Neovim

### Installation
Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
-- init.lua:
{
  'doganalper/template.nvim', 
  config = function()
    require("template").setup({
      -- custom config
    })
  end
}
```

### Defaults
```lua
{
  mappings = {
    switch_template = "<leader>st",
  },
  templates = {
    [filetype] = {
      name = "<name of the template to be displayed on selector>",
      template = {
        "template lines"
      }
    }
  },
}
```


### Customization
```lua
require('doganalper/template.nvim').setup({
    -- configuration for mappings
    mappings = {
        -- this will call a function for switching templates
        -- if filetype has multiple template
        switch_template = "<leader>st"
    },
    templates = {}
})
```

## Default Mappings
| Mappings       | Action                                               |
|----------------|------------------------------------------------------|
| `<leader>st` |  [S]witch [T]emplate                                           |

## TODO List
- [ ] Add switching places with <Tab> and <S-Tab>.
