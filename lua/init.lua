local M = {}

local default_opts = {
	templates = {
		vue = {
			"<script lang=\"ts\" setup></script>",
			"",
			"<template></template>"
		},
		typescriptreact = {
			"type Props = {}",
			"function Name({}: Props) {}",
			"",
			"export default Name"
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

local function printToBuffer(ft)
	local template = M.opts.templates[ft]

	local len = #template
	vim.api.nvim_buf_set_lines(0, 0, len - 1, false, template)
end

local function checkFileType()
	local ft = vim.bo.filetype

	if M.opts.templates[ft] ~= nil and checkIfBufferEmpty() then
		printToBuffer(ft)
	end
end


function M.setup(opts)
	M.opts = concatTables(default_opts, opts)
	-- TODO: check these events, they might not what I want
	vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter" }, {
		group = vim.api.nvim_create_augroup("AAA", { clear = true }),
		callback = checkFileType,
	})
end

return M
