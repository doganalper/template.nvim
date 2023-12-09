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

function M.findElementByName(list, name)
  for _, table in ipairs(list) do
    if table["name"] == name then
      return table
    end
  end

  return nil
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
