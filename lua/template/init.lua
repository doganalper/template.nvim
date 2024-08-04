local default_opts = require("template.defaults")
local internals = require("template.internals")

local M = {}

function M.switch_template()
  local filetype = internals.getFileType()
  local templates = M.opts.templates[filetype]

  if templates and #templates > 1 then
    internals.getTemplate(filetype, true)
  end
end

-- Function to set up the plugin with user options
function M.setup(opts)
  opts = opts or {}
  M.opts = internals.concatTables(default_opts, opts)

  -- Create an autocommand for BufWinEnter event
  vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("EnteredBufForTemplate", { clear = true }),
    callback = function()
      internals.checkFileType(M.opts)
    end,
  })

  -- Set up key mapping for switching templates
  vim.keymap.set("n", M.opts.mappings.switch_template, M.switch_template, { desc = "Change current file template" })

  vim.keymap.set(
    { "n", "v" },
    M.opts.mappings.jump_to_next_marker,
    internals.jump_to_next_marker,
    { noremap = true, silent = true }
  )

  vim.keymap.set(
    { "n", "v" },
    M.opts.mappings.jump_to_prev_marker,
    internals.jump_to_prev_marker,
    { noremap = true, silent = true }
  )
end

-- Initialize the plugin with default setup
M.setup()

return M
