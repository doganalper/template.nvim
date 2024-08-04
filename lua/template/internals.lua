-- List of file variables to be replaced in templates
local file_variables = { "{F_NAME}", "{F_NAME_NO_EXTENSION}" }

local M = {}
local localOpts = nil

-- Function to jump to the next marker
function M.jump_to_next_marker()
  local marker = vim.fn.search("\\$\\d\\+", "W")
  if marker ~= 0 then
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_win_set_cursor(0, { row, col })

    -- Enter visual mode and extend the selection
    vim.api.nvim_feedkeys('v', 'n', false)
    vim.api.nvim_feedkeys('l', 'n', false)
  end
end

-- Function to jump to the previous marker
function M.jump_to_prev_marker()
  local marker = vim.fn.search("\\$\\d\\+", "bW")
  if marker ~= 0 then
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_win_set_cursor(0, { row, col })

    -- Enter visual mode and extend the selection
    vim.api.nvim_feedkeys('v', 'n', false)
    vim.api.nvim_feedkeys('l', 'n', false)
  end
end

-- Check if the template contains any of the file variables
--- @param template string[]: The template to check
--- @return boolean: True if the template contains any file variables, false otherwise
function M.isContainsVariables(template)
  for _, line in ipairs(template) do
    for _, variable in ipairs(file_variables) do
      if string.find(line, variable) then
        return true
      end
    end
  end
  return false
end

-- Concatenate two tables into a new table
--- @param t1 table: The first table
--- @param t2 table: The second table
--- @return table: The concatenated table
function M.concatTables(t1, t2)
  local result = {}
  for k, v in pairs(t1) do
    if type(v) == "table" and type(t2[k]) == "table" then
      result[k] = M.concatTables(v, t2[k])
    else
      result[k] = v
    end
  end
  for k, v in pairs(t2) do
    if type(v) == "table" and type(t1[k]) == "table" then
      result[k] = M.concatTables(v, t1[k])
    else
      result[k] = v
    end
  end
  return result
end

-- Get the number of lines in the current buffer
--- @return number: The number of lines in the current buffer
function M.getBufferLineCount()
  return vim.api.nvim_buf_line_count(0)
end

-- Check if the current buffer is empty
--- @return boolean: True if the buffer is empty, false otherwise
function M.isBufferEmpty()
  local line_count = M.getBufferLineCount()
  if line_count == 0 then
    return true
  end
  for i = 1, line_count do
    if vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1] ~= "" then
      return false
    end
  end
  return true
end

-- Get the names of all templates
--- @param templates table: The table of templates
--- @return string[]: The names of the templates
function M.getTemplateNames(templates)
  local names = {}
  for _, template in pairs(templates) do
    table.insert(names, template.name)
  end
  return names
end

-- Find an element by its name in a list
--- @param list table: The list to search
--- @param name string: The name to search for
--- @return table|nil: The found element or nil if not found
function M.findElementByName(list, name)
  for _, element in ipairs(list) do
    if element.name == name then
      return element
    end
  end
  return nil
end

-- Print the template to the buffer, replacing variables if necessary
--- @param template string[]: The template to print
--- @param clearBuf boolean: Whether to clear the buffer before printing
function M.printToBuffer(template, clearBuf)
  if M.isContainsVariables(template) then
    local file_name = vim.fn.expand("%:t")
    local file_name_without_extension = vim.fn.fnamemodify(file_name, ":r")
    for i, line in ipairs(template) do
      template[i] = string.gsub(line, "{F_NAME}", file_name)
      template[i] = string.gsub(template[i], "{F_NAME_NO_EXTENSION}", file_name_without_extension)
    end
  end

  if clearBuf then
    M.clearBuffer()
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
end

-- Clear the current buffer
function M.clearBuffer()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
end

-- Get the file type of the current buffer
--- @return string: The file type of the current buffer
function M.getFileType()
  return vim.bo.filetype
end

-- Get the appropriate template for the current file type and print it to the buffer
--- @param filetype string: The file type to get the template for
--- @param clearBuf boolean?: Whether to clear the buffer before printing
function M.getTemplate(filetype, clearBuf)
  if not localOpts then
    return
  end
  clearBuf = clearBuf or false

  local templates = localOpts.templates[filetype]
  if #templates == 1 then
    M.printToBuffer(templates[1].template, clearBuf)
    return
  end

  vim.ui.select(M.getTemplateNames(templates), { prompt = "Choose template" }, function(choice)
    local selectedTemplate = M.findElementByName(templates, choice)
    if selectedTemplate then
      M.printToBuffer(selectedTemplate.template, clearBuf)
    end
  end)
end

-- Check the file type and load the appropriate template if the buffer is empty
--- @param opts table: The options containing templates
function M.checkFileType(opts)
  localOpts = opts
  local filetype = M.getFileType()

  if localOpts.templates and localOpts.templates[filetype] and M.isBufferEmpty() then
    M.getTemplate(filetype)
  end
end

return M
