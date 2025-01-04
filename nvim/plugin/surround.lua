-- We use operator pending mode (opm) instead of flat mappings.
-- This fixes guicursor functionality for all opm operations.

require('nvim-surround').setup {
  keymaps = {
    -- Disable normal mode mappings
    normal = false,
    delete = false,
    change = false,

    -- Disable cur and line mappings, they are not replaced currently since I don't use them
    normal_cur = false,
    normal_line = false,
    normal_cur_line = false,
    change_line = false,
  },
}

local function op(operation)
  local map = '<esc><Plug>(nvim-surround-'.. operation .. ')'
  local key = vim.api.nvim_replace_termcodes(map, true, true, true)
  vim.api.nvim_feedkeys(key, 'm', false)
end

vim.keymap.set('o', 's', function()
  local operator = vim.v.operator
  if operator == 'd' then
    op('delete')
  elseif operator == 'c' then
    op('change')
  elseif operator == 'y' then
    op('normal')
  end
end, { expr = true })
