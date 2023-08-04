local M = {}

local default_opts = {
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
					"import {View} from 'react-native'",
					"",
					"type Props = {}",
					"function Name({}: Props) {}",
					"",
					"export default Name"
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

local function concatTables(t1, t2)
	local T = {}

	for k, v in pairs(t1) do
		T[k] = v
	end

	for k, v in pairs(t2) do
		T[k] = v
	end

	return T
end

local function checkIfBufferEmpty()
	local line_count = vim.api.nvim_buf_line_count(0)
	if line_count == 0 then
		return true
	end
	for i = 1, line_count do
		local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
		if line ~= "" then
			return false
		end
	end
	return true
end

local function getTemplateNames(tab)
	local names = {}
	local n = 0

	for _, v in pairs(tab) do
		n = n + 1
		names[n] = v.name
	end

	return names
end

local function findElementByName(list, name)
	for _, table in ipairs(list) do
		if table["name"] == name then
			return table
		end
	end

	return nil
end

local function getTemplate(ft)
	local templateValue = M.opts.templates[ft]
	if type(templateValue[1]) == 'string' then
		return templateValue
	end

	local c
	local co = coroutine.create(function()
		vim.ui.select(getTemplateNames(templateValue), {
			prompt = "Choose template",
		}, function(choice)
			c = choice
			coroutine.yield()
		end)
	end)

	local resume = nil
	while true do
		resume = coroutine.resume(co)
		if resume ~= nil then
			break
		end
	end

	local foundTemplate = findElementByName(templateValue, c)

	if foundTemplate == nil then return end

	return foundTemplate.template
end

local function printToBuffer(ft)
	local template = getTemplate(ft)

	if template ~= nil then
		local len = #template
		vim.api.nvim_buf_set_lines(0, 0, len - 1, false, template)
	end
end

local function checkFileType()
	local ft = vim.bo.filetype

	if M.opts.templates[ft] ~= nil and checkIfBufferEmpty() then
		printToBuffer(ft)
	end
end


function M.setup(opts)
	opts = opts or {}
	M.opts = concatTables(default_opts, opts)
	-- TODO: check these events, they might not what I want
	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		group = vim.api.nvim_create_augroup("Entered Buf For Template", { clear = true }),
		callback = checkFileType,
	})
end

return M
