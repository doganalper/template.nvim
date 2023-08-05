# Lightweight Template Plugin For Neovim

## Why do we need this plugin?

This was created based on my personal needs. That explains why currently it has very limited template support but contributions are welcomed.

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
		switch_template = "<leader>st"
	},
	templates = {
		vue = {
			{
				name = "Vue 2",
				template = {
					"<template>",
					"<div>",
					"</div>",
					"<template>",
					"",
					"<script>",
					"export default {}",
					"</script>",
				}
			},
			{
				name = "Vue 3",
				template = {
					"<script lang=\"ts\" setup></script>",
					"",
					"<template></template>"
				}
			}
		},
		typescriptreact = {
			{
				name = "React",
				template = {
					"type Props = {}",
					"function Name({}: Props) {}",
					"",
					"export default Name"
				}
			},
			{
				name = "React Native",
				template = {
					"import { View, StyleSheet } from 'react-native'",
					"",
					"type Props = {}",
					"function Name({}: Props) {}",
					"",
					"export default Name",
					"",
					"const styles = StyleSheet.create({})"
				}
			}
		},
		javascriptreact = {
			"function Name({}) {}",
			"",
			"export default Name"
		},
		markdown = {
			"---",
			"---"
		}
	}
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
