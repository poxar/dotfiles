-- We use operator pending mode (opm) instead of flat mappings.
-- This fixes guicursor functionality for all opm operations.
vim.g.nvim_surround_no_normal_mappings = true

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
