M = {}

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

function M.getTemplate(ft)
  local templateValue = M.opts.templates[ft]
  if type(templateValue[1]) == "string" then
    return templateValue
  end

  local c
  local co = coroutine.create(function()
    vim.ui.select(M.getTemplateNames(templateValue), {
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

  local foundTemplate = M.findElementByName(templateValue, c)

  if foundTemplate == nil then
    return
  end

  return foundTemplate.template
end

function M.clearBuffer()
  local line_count = M.getBufferLineCount()

  vim.api.nvim_buf_set_lines(0, 0, line_count, false, { "" })
end

function M.printToBuffer(ft, clearBuf)
  local template = M.getTemplate(ft)

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
  M.opts = opts
  local ft = M.getFt()

  if M.opts.templates[ft] ~= nil and M.checkIfBufferEmpty() then
    M.printToBuffer(ft)
  end
end

return M
