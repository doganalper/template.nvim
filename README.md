# Filetype Based Template Plugin For Neovim

### Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'doganalper/template.nvim', 
}
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
-- init.lua:
{
  'doganalper/template.nvim', 
}
```

### Defaults

```lua
{
  mappings = {
    switch_template = "<leader>st",
  },
  templates = {
    [file_type] = {
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
    -- this will override any existing templates from default options
    -- it takes a list of key-value pair where value can be either list
    -- which is a template or a list that contains one or more tables for
    -- multiple template support
    templates = {}
})
```

## Default Mappings

| Mappings       | Action                                               |
|----------------|------------------------------------------------------|
| `<leader>st` |  [S]witch [T]emplate                                           |

## TODO List
[] Add switching places with <Tab> and <S-Tab>.
