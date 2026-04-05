local opts = require('leap.opts')

local api = vim.api
local abs = math.abs
local max = math.max
local pow = math.pow

local function get_cursor_pos()
   return { vim.fn.line('.'), vim.fn.col('.') }
end

--- Returns the first and last visible virtual column of the editable
--- window area.
---
---   +----------------------+
---   |XXXX                  |
---   |XXXX     C            |
---   |XXXX                  |
---   +----------------------+
---    [--------------------]   window-width
---    [--]                     textoff (e.g. foldcolumn)
---    (--------]               offset-in-win
---        (----]               offset-in-editable-win
---
local function get_horizontal_bounds()
   local window_width = api.nvim_win_get_width(0)
   local textoff = vim.fn.getwininfo(api.nvim_get_current_win())[1].textoff
   local offset_in_win = vim.fn.wincol() - 1
   local offset_in_editable_win = offset_in_win - textoff
   -- Screen column of the first visible column in the editable area.
   local left_bound = vim.fn.virtcol('.') - offset_in_editable_win
   local right_bound = left_bound + (window_width - textoff - 1)
   return { left_bound, right_bound }
end

local function get_match_positions(pattern, bounds, kwargs)
   local is_backward = kwargs.is_backward
   local in_whole_window = kwargs.in_whole_window
   local left_bound, right_bound = unpack(bounds)
   local use_bounds = in_whole_window and not vim.wo.wrap
   local bounds_pat = use_bounds
      and '\\(\\%>' .. (left_bound - 1) .. 'v\\%<' .. (right_bound + 1) .. 'v\\)'
      or ''
   pattern = bounds_pat .. pattern

   local flags = is_backward and 'bW' or 'W'
   local stopline = vim.fn.line(is_backward and 'w0' or 'w$')
   local saved_view = vim.fn.winsaveview()
   local saved_cpo = vim.o.cpo
   local should_match_at_curpos = in_whole_window

   vim.opt.cpo:remove('c')  -- do not skip overlapping matches
   if in_whole_window then
      vim.fn.cursor({ vim.fn.line('w0'), 1 })
   end

   local positions = {}
   local is_at_win_edge = {}  -- set of indexes in `positions`
   local is_offscreen = {}  -- likewise
   local idx = 0  -- ~ match count
   while true do
      local c = should_match_at_curpos and 'c' or ''
      should_match_at_curpos = false
      local pos = vim.fn.searchpos(pattern, flags .. c, stopline)
      local line = pos[1]
      if line == 0 then
         -- No match.
         vim.fn.winrestview(saved_view)
         vim.o.cpo = saved_cpo
         break
      elseif vim.fn.foldclosed(line) ~= -1 then
         -- In a closed fold.
         if is_backward then
            vim.fn.cursor(vim.fn.foldclosed(line), 1)
         else
            vim.fn.cursor(vim.fn.foldclosedend(line), 0)
            vim.fn.cursor(0, vim.fn.col('$'))
         end
      else
         table.insert(positions, pos)
         idx = idx + 1
         local vcol = vim.fn.virtcol('.')
         if vcol == right_bound then
            is_at_win_edge[idx] = true
         elseif not vim.wo.wrap and (right_bound < vcol or vcol < left_bound) then
            is_offscreen[idx] = true
         end
      end
   end

   return positions, is_at_win_edge, is_offscreen
end

local function get_targets_in_current_window(pattern, targets, kwargs)
   local is_backward = kwargs.is_backward
   local offset = kwargs.offset or 0
   local inputlen = kwargs.inputlen
   local in_whole_window = kwargs.in_whole_window
   local skip_curpos = kwargs.skip_curpos
   local wininfo = vim.fn.getwininfo(api.nvim_get_current_win())[1]
   local curline, curcol = unpack(get_cursor_pos())
   local bounds = get_horizontal_bounds()
   if inputlen then
      -- The whole match should be visible.
      bounds[2] = bounds[2] - max(0, inputlen - 1)
   end

   local match_positions, is_at_win_edge, is_offscreen =
      get_match_positions(pattern, bounds, {
         is_backward = is_backward,
         in_whole_window = in_whole_window
      })

   local prev_line
   local line_str
   for i, pos in ipairs(match_positions) do
      local line, col = unpack(pos)
      if not (skip_curpos and line == curline and (col + offset) == curcol) then
         if line ~= prev_line then
            line_str = vim.fn.getline(line)
            prev_line = line
         end
         -- Extracting the characters at the match position.
         -- (Note: No matter how we change the implementation, at some
         -- point we will have to know at least the second character, by
         -- design, for grouping the matches into sublists.)
         local ch1 = vim.fn.strpart(line_str, col - 1, 1, true)
         local ch2 = (ch1 == '' or inputlen < 2) and ''
            or vim.fn.strpart(line_str, col - 1 + ch1:len(), 1, true)

         -- .preview_fiter is deprecated
         local preview = opts.preview_filter or opts.preview
         local is_previewable =
            inputlen < 2
            or opts.preview == true
            or (
               type(preview) == 'function'
               and preview(vim.fn.strpart(line_str, col - 2, 1, true), ch1, ch2)
            )

         table.insert(targets, {
            wininfo = wininfo,
            pos = pos,
            chars = { ch1, ch2 },
            is_at_win_edge = is_at_win_edge[i],
            is_offscreen = is_offscreen[i],
            is_previewable = is_previewable,
         })
      end
   end
end

local function add_directional_indexes(targets, curpos)
   local curline, curcol = unpack(curpos)
   local first_idx_after --[[curpos]] = #targets + 1
   local stop = false
   for i, target in ipairs(targets) do
      if stop then break end
      local line, col = unpack(target.pos)
      if line > curline or (line == curline and col >= curcol) then
         first_idx_after = i
         stop = true
      end
   end
   for i = 1, (first_idx_after - 1) do
      targets[i].idx = i - first_idx_after
   end
   for i = first_idx_after, #targets do
      targets[i].idx = i - (first_idx_after - 1)
   end
end

local function euclidean_distance(pos1, pos2)
   local editor_grid_aspect_ratio = 0.3  -- arbitrary, should be good enough usually
   local dy = abs(pos1[1] - pos2[1])
   local dx = abs(pos1[2] - pos2[2]) * editor_grid_aspect_ratio
   return pow((dx * dx) + (dy * dy), 0.5)
end

local function rank(targets, cursor_positions, src_win)
   for _, target in ipairs(targets) do
      local win = target.wininfo.winid
      local pos = target.pos
      local curpos = cursor_positions[win]

      local distance = curpos and euclidean_distance(pos, curpos) or 99999 -- #287
      local curr_win_bonus = (win == src_win) and 30
      local curr_line_bonus = curr_win_bonus and (pos[1] == curpos[1]) and 999
      local curr_line_fwd_bonus = curr_line_bonus and (pos[2] > curpos[2]) and 999

      target.rank = distance
         - (curr_win_bonus or 0)
         - (curr_line_bonus or 0)
         - (curr_line_fwd_bonus or 0)
   end
end

local function get_targets(pattern, kwargs)
   local is_backward = kwargs.is_backward
   local windows = kwargs.windows
   local offset = kwargs.offset
   local is_op_mode = kwargs.is_op_mode
   local inputlen = kwargs.inputlen
   local in_whole_window = windows
   local src_win = api.nvim_get_current_win()
   windows = windows or { src_win }
   local curr_win_only = (windows[1] == src_win) and not windows[2]
   local cursor_positions = { [src_win] = get_cursor_pos() }

   local targets = {}
   for _, win in ipairs(windows) do
      if not curr_win_only then
         api.nvim_set_current_win(win)
      end
      if in_whole_window then
         cursor_positions[win] = get_cursor_pos()
      end
      -- Fill up the provided `targets`, instead of returning a new table.
      get_targets_in_current_window(pattern, targets, {
         is_backward = is_backward,
         offset = offset,
         in_whole_window = in_whole_window,
         inputlen = inputlen,
         skip_curpos = (win == src_win)
      })
   end
   if not curr_win_only then
      api.nvim_set_current_win(src_win)
   end

   if #targets > 0 then
      if in_whole_window then  -- = bidirectional
         if is_op_mode and curr_win_only then
            -- Preserve the original (byte) order for dot-repeat, before sorting.
            add_directional_indexes(targets, cursor_positions[src_win])
         end
         rank(targets, cursor_positions, src_win)
         table.sort(targets, function(x, y) return x.rank < y.rank end)
      end
      return targets
   end
end

return {
   get_targets = get_targets
}
