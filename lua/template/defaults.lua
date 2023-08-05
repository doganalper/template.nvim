return {
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
