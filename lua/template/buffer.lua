local template_utils = require("template.template")

M = {}

function M.getBufferLineCount()
  return vim.api.nvim_buf_line_count(0)
end

function M.checkIfBufferEmpty()
  local line_count = M.getBufferLineCount()
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

function M.clearBuffer()
  local line_count = M.getBufferLineCount()

  vim.api.nvim_buf_set_lines(0, 0, line_count, false, { "" })
end

function M.printToBuffer(ft, clearBuf)
  local template = template_utils.getTemplate(ft)

  if template ~= nil then
    if clearBuf then
      M.clearBuffer() -- clear buffer first for any content, useful for switching templates
    end
    local len = #template
    vim.api.nvim_buf_set_lines(0, 0, len - 1, false, template)
  end
end

return M
