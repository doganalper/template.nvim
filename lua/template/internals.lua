M = {}

local localOpts = nil

function M.concatTables(t1, t2)
  T = {}

  for k, v in pairs(t1) do
    T[k] = v
  end

  for k, v in pairs(t2) do
    T[k] = v
  end

  return T
end

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

function M.getTemplateNames(tab)
  local names = {}
  local n = 0

  for _, v in pairs(tab) do
    n = n + 1
    names[n] = v.name
  end

  return names
end

function M.findElementByName(list, name)
  for _, table in ipairs(list) do
    if table["name"] == name then
      return table
    end
  end

  return nil
end

function M.getTemplate(ft, clearBuf)
  if localOpts == nil then
    return
  end

  local templateValue = localOpts.templates[ft]

  if #templateValue == 1 then
    M.printToBuffer(templateValue[1].template, clearBuf)
    return
  end

  vim.ui.select(M.getTemplateNames(templateValue), {
    prompt = "Choose template",
  }, function(choice)
      local foundTemplate = M.findElementByName(templateValue, choice)

      if foundTemplate == nil then
        return
      end

      M.printToBuffer(foundTemplate.template, clearBuf)

    end)
end

function M.clearBuffer()
  local line_count = M.getBufferLineCount()

  vim.api.nvim_buf_set_lines(0, 0, line_count, false, { "" })
end

function M.printToBuffer(template, clearBuf)
  if template ~= nil then
    if clearBuf then
      M.clearBuffer() -- clear buffer first for any content, useful for switching templates
    end
    local len = #template
    vim.api.nvim_buf_set_lines(0, 0, len - 1, false, template)
  end
end

function M.getFt()
  return vim.bo.filetype
end

function M.checkFileType(opts)
  localOpts = opts
  local ft = M.getFt()

  if localOpts.templates and localOpts.templates[ft] ~= nil and M.checkIfBufferEmpty() then
    M.getTemplate(ft)
  end
end

return M
