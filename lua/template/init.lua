local M = {}

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

local function has_value(tab, val)
	for _, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
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
	local status, template = pcall(require, "template.templates." .. ft)

	if status then
		local len = #template
		vim.api.nvim_buf_set_lines(0, 0, len - 1, false, template)
	end
end

local fts = { "vue", "typescriptreact", "javascriptreact", "markdown" }
local function checkFileType()
	local ft = vim.bo.filetype
	print(ft)

	if has_value(fts, ft) and checkIfBufferEmpty() then
		printToBuffer(ft)
	elseif M.opts.silence == false then
		print("There is no default template for this file, you can add it from options")
	end
end

local default_opts = {
	silence = false
}

function M.setup(opts)
	M.opts = concatTables(default_opts, opts)
	vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter" }, {
		group = vim.api.nvim_create_augroup("AAA", { clear = true }),
		callback = checkFileType,
	})
end

return M
