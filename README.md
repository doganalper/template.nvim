# Filetype Based Template Plugin For Neovim

![template-plugin](https://github.com/doganalper/template.nvim/assets/48688801/62fb11f0-3d36-4b09-a71c-d862eaef7cf9)

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
        switch_template = "<leader>st",
        jump_to_next_marker = "]m",
        jump_to_prev_marker = "[m",
    },
    templates = {}
})
```

### Example Templates
```lua
templates = {
  vue = {
    {
      name = "Vue 2 JS",
      template = {
        "<template>",
        "<div>",
        "</div>",
        "<template>",
        "",
        "<script>",
        "export default {}",
        "</script>",
      },
    },
    {
      name = "Vue 2 Ts",
      template = {
        "<template>",
        "<div>",
        "</div>",
        "</template>",
        "",
        '<script lang="ts">',
        "import Vue from 'vue';",
        "export default Vue.extend({})",
        "</script>",
      },
    },
    {
      name = "Vue 3",
      template = {
        '<script lang="ts" setup></script>',
        "",
        "<template></template>",
      },
    },
  },
},
```

## Default Mappings
| Mappings       | Action                                               |
|----------------|------------------------------------------------------|
| `<leader>st` |  [S]witch [T]emplate                                           |
| `]m` |  Jump To Next Marker                                           |
| `[m` |  Jump To Prev Marker                                           |

## File Variables
Currently you can use `{F_NAME}` to insert filename and `{F_NAME_NO_EXTENSION}` to insert filename without file extensions to your templates. More variables will be implemented depending on usage/request.

## Jump Markers
You can place pipe `|` to mark a place on template to jump to that location with default or user given mapping.

## TODO List
- [ ] Add switching places with `<Tab>` and `<S-Tab>`.
- [ ] Find a way to easily add indents to templates.
