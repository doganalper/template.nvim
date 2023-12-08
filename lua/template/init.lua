local default_opts = require("template.defaults")
local internals = require("template.internals")

local M = {}

function M.switch_template()
  local ft = internals.getFt()

  local templates = M.opts.templates[ft]
  if templates ~= nil and #templates > 1 then
    internals.printToBuffer(ft, true)
  end
end

function M.setup(opts)
  opts = opts or {}
  M.opts = internals.concatTables(default_opts, opts)

  -- TODO: check these events, they might not what I want
  vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("Entered Buf For Template", { clear = true }),
    callback = function()
      internals.checkFileType(M.opts)
    end,
  })

  vim.keymap.set("n", M.opts.mappings.switch_template, function()
    M.switch_template()
  end, {})
end

return M
