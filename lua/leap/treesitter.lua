local api = vim.api

local function get_nodes()
   if not pcall(vim.treesitter.get_parser) then
      return nil, 'No treesitter parser for this filetype.'
   else
      local node = vim.treesitter.get_node()
      if node then
         local nodes = { node }
         local parent = node:parent()
         while parent do
            table.insert(nodes, parent)
            parent = parent:parent()
         end
         return nodes
      end
   end
end

local function nodes_to_targets(nodes)
   local targets = {}
   local prev_range = {}  -- to skip duplicate ranges
   local is_linewise = vim.fn.mode(1):match('V')

   for _, node in ipairs(nodes) do
      local startline, startcol, endline, endcol = node:range()  -- (0, 0)
      if not (is_linewise and startline == endline) then
         -- Adjust the end position if necessary. (It is exclusive,
         -- so if we are on the very first column, move to the end of
         -- the previous line, to the newline character.)
         if endcol == 0 then
            endline = endline - 1
            endcol = #(vim.fn.getline(endline + 1)) + 1  -- include EOL (+1)
         end

         -- Check duplicates based on the adjusted ranges
         -- (relevant for linewise mode)!
         local range = is_linewise and { startline, endline }
            or { startline, startcol, endline, endcol }
         -- Instead of skipping, keep this (the outer one), and remove
         -- the previous (better for linewise mode).
         if vim.deep_equal(range, prev_range) then
            table.remove(targets)
         end
         prev_range = range

         -- Create target ((0,0) -> (1,1)).
         -- `endcol` is exclusive, but we want to put the inline labels
         -- after it, so still +1.
         table.insert(targets, {
            pos = { startline + 1, startcol + 1 },
            endpos = { endline + 1, endcol + 1 }
         })
      end
   end

   if #targets > 0 then
      return targets
   end
end

local function get_targets()
   local nodes, err = get_nodes()
   if not nodes then
      return nil, err
   else
      return nodes_to_targets(nodes)
   end
end

local function select_range(target)
   -- Enter Visual mode.
   local mode = vim.fn.mode(1)
   if mode:match('no?') then
      vim.cmd('normal! ' .. (mode:match('[V\22]') or 'v'))
   end
   -- Do the rest without leaving Visual mode midway, so that
   -- leap.remote.action() can keep working.

   -- Move the cursor to the start of the Visual area if needed.
   if vim.fn.line('v') ~= vim.fn.line('.') or vim.fn.col('v') ~= vim.fn.col('.') then
      vim.cmd('normal! o')
   end

   vim.fn.cursor(unpack(target.pos))
   vim.cmd('normal! o')
   local endline, endcol = unpack(target.endpos)
   vim.fn.cursor(endline, endcol - 1)

   -- Move to the start. This might be more intuitive for incremental
   -- selection, when the whole range is not visible - nodes are usually
   -- harder to identify at their end.
   vim.cmd('normal! o')

   -- Force redrawing the selection if the text has been scrolled.
   pcall(api.nvim__redraw, { flush = true })  -- EXPERIMENTAL
end

-- Fill the gap left by the cursor (which is down on the command line).
-- Note: redrawing the cursor with nvim__redraw() is not a satisfying
-- solution, since the cursor might still appear in a wrong place
-- (thanks to inline labels).
local function fill_cursor_pos(targets, start_idx)
   local ns = api.nvim_create_namespace('')
   -- Set auto-cleanup.
   api.nvim_create_autocmd('User', {
      pattern = { 'LeapRedraw', 'LeapLeave' },
      once = true,
      callback = function ()
         api.nvim_buf_clear_namespace(0, ns, 0, -1)
      end,
   })

   local line = vim.fn.line('.')
   local col = vim.fn.col('.')
   local line_str = vim.fn.getline(line)
   local ch_at_curpos = vim.fn.strpart(line_str, col - 1, 1, true)
   -- On an empty line, use space.
   local text = (ch_at_curpos == '') and ' ' or ch_at_curpos

   -- Problem: If there is an inline label for the same position, this
   -- extmark will not be shifted.
   local first = targets[start_idx]
   local conflict = first and first.pos[1] == line and first.pos[2] == col
   -- Solution (hack): Shift by the number of labels on the given line.
   -- Note: Getting the cursor's screenpos would not work, as it has not
   -- moved yet.
   -- TODO: What if there are other inline extmarks, besides our ones?
   local shift = 1
   if conflict then
      for idx = start_idx + 1, #targets do
         if targets[idx] and targets[idx].pos[1] == line then
            shift = shift + 1
         else
            break
         end
      end
   end

   api.nvim_buf_set_extmark(0, ns, line - 1, col - 1, {
      virt_text = { { text, 'Visual' } },
      virt_text_pos = 'overlay',
      virt_text_win_col = conflict and (col - 1 + shift) or nil,
      hl_mode = 'combine',
   })
end

local function select(kwargs)
   kwargs = kwargs or {}
   local leap = require('leap')
   local traversal = not vim.fn.mode(1):match('o')

   local ok, context = pcall(require, 'treesitter-context')
   local context_enabled = ok and context.enabled()

   if context_enabled then context.disable() end

   leap.leap {
      windows = { api.nvim_get_current_win() },
      targets = get_targets,
      action = select_range,
      traversal = traversal,
      opts = vim.tbl_extend('keep', kwargs.opts or {}, {
         labels = traversal and '' or nil,
         on_beacons = traversal and fill_cursor_pos or nil,
         virt_text_pos = 'inline',
      })
   }

   if context_enabled then context.enable() end
end

return {
   select = select
}
