M = {}

function M.getTemplateNames(tab)
  local names = {}
  local n = 0

  for _, v in pairs(tab) do
    n = n + 1
    names[n] = v.name
  end

  return names
end

function M.getTemplate(ft)
  local templateValue = M.opts.templates[ft]

  if #templateValue == 1 then
    return templateValue[1].template
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

return M
