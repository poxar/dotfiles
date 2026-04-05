-- User-space convenience functions that rely only on the public API.

--- Returns a table that can be used as or merged with `opts`,
--- with `keys.next_target` and `keys.prev_target` set appropriately.
local function with_traversal_keys(fwd_key, bwd_key, opts)
   local function with(key, t)
      return { type(t) == 'table' and t[1] or t, key }
   end

   local function without(key, t)  -- `t` must be a table now
      -- Iterate backwards so that we can safely remove the item while looping.
      for i = #t, 1, -1 do
         if vim.keycode(t[i]) == vim.keycode(key) then
            table.remove(t, i)
         end
      end
      return t
   end

   local keys = vim.deepcopy(require('leap').opts.keys)

   return vim.tbl_deep_extend('error', opts or {}, {
      keys = {
         next_target = without(bwd_key, with(fwd_key, keys.next_target)),
         prev_target = without(fwd_key, with(bwd_key, keys.prev_target)),
      }
   })
end

--- @deprecated
local function set_repeat_keys(fwd_key, bwd_key, kwargs)
   kwargs = kwargs or {}
   local modes = kwargs.modes or { 'n', 'x', 'o' }
   local relative_dir = kwargs.relative_directions

   local function leap_repeat(backward_invoc)
      local leap = require('leap')
      local backward = backward_invoc
      if relative_dir then
         if backward_invoc then
            backward = not leap.state['repeat'].backward
         else
            backward = leap.state['repeat'].backward
         end
      end
      local opts = {
         -- Just overwrite the fields, one wouldn't want to switch to
         -- another key after starting with one.
         keys = vim.tbl_extend('force', leap.opts.keys, {
            next_target = backward_invoc and bwd_key or fwd_key,
            prev_target = backward_invoc and fwd_key or bwd_key,
         })
      }
      leap.leap { ['repeat'] = true, backward = backward, opts = opts }
   end

   vim.keymap.set(modes, fwd_key, function() leap_repeat(false) end, {
      silent = true,
      desc = 'Repeat leap '
         .. (relative_dir and 'in the previous direction' or 'forward')
   })
   vim.keymap.set(modes, bwd_key, function() leap_repeat(true) end, {
      silent = true,
      desc = 'Repeat leap '
         .. (relative_dir and 'in the opposite direction' or 'backward')
   })
end

local function get_enterable_windows()
   return vim.iter(vim.api.nvim_tabpage_list_wins(0))
      :filter(function(win)
         local config = vim.api.nvim_win_get_config(win)
         return config.focusable
            -- Exclude auto-closing hover popups, e.g. diagnostics (#137).
            and config.relative == ""
            and win ~= vim.api.nvim_get_current_win()
      end):totable()
end

local function get_focusable_windows()
   return { vim.api.nvim_get_current_win(), unpack(get_enterable_windows()) }
end

local set_backdrop_highlight
do
   local function highlight_ranges_for_redraw_cycle(hl_group, ranges)
      local ns = vim.api.nvim_create_namespace('')

      for buf, range in pairs(ranges) do
         vim.hl.range(buf, ns, hl_group, range[1], range[2])
      end

      -- Set auto-cleanup.
      vim.api.nvim_create_autocmd('User', {
         pattern = { 'LeapRedraw', 'LeapLeave' },
         once = true,
         callback = function()
            for buf, range in pairs(ranges) do
               if vim.api.nvim_buf_is_valid(buf) then
                  vim.api.nvim_buf_clear_namespace(buf, ns, range[1][1], range[2][1])
               end
               -- Safety measure for scrolloff > 0: we always clean up
               -- the current view too.
               vim.api.nvim_buf_clear_namespace(
                  0, ns, vim.fn.line('w0') - 1, vim.fn.line('w$')
               )
            end
         end,
      })
      -- When used as an autocmd callback, a truthy return value would
      -- remove the autocommand (:h nvim_create_autocmd).
      return nil
   end

   local function get_search_ranges()
      local ranges = {}
      local args = require('leap').state.args
      local windows = args.windows or args.target_windows  -- deprecated

      if windows then
         for _, win in ipairs(windows) do
            local wininfo = vim.fn.getwininfo(win)[1]
            local buf = wininfo.bufnr
            ranges[buf] = { { wininfo.topline - 1, 0 }, { wininfo.botline - 1, -1 } }
         end
      else
         local wininfo = vim.fn.getwininfo(vim.fn.win_getid())[1]
         local buf = wininfo.bufnr
         local curline = vim.fn.line('.') - 1
         local curcol = vim.fn.col('.') - 1
         if args.backward then
            ranges[buf] = { { wininfo.topline - 1, 0 }, { curline, curcol } }
         else
            ranges[buf] = { { curline, curcol + 1 }, { wininfo.botline - 1, -1 } }
         end
      end

      return ranges
   end

   --- Applies `hl_group` to all search ranges. Disabled on color scheme change.
   set_backdrop_highlight = function(hl_group)
      local group = vim.api.nvim_create_augroup('LeapBackdrop', {})
      local id = vim.api.nvim_create_autocmd('User', {
         pattern = 'LeapRedraw',
         group = group,
         callback = function()
            highlight_ranges_for_redraw_cycle(hl_group, get_search_ranges())
         end,
      })
      vim.api.nvim_create_autocmd('ColorScheme', {
         once = true,
         group = group,
         callback = function() vim.api.nvim_del_autocmd(id) end,
      })
   end
end

--- @deprecated
local function add_default_mappings(force)
   for _, t in ipairs {
      { { 'n', 'x', 'o' }, 's',  '<Plug>(leap-forward-to)',    'Leap forward to' },
      { { 'n', 'x', 'o' }, 'S',  '<Plug>(leap-backward-to)',   'Leap backward to' },
      { { 'x', 'o' },      'x',  '<Plug>(leap-forward-till)',  'Leap forward till' },
      { { 'x', 'o' },      'X',  '<Plug>(leap-backward-till)', 'Leap backward till' },
      { { 'n', 'x', 'o' }, 'gs', '<Plug>(leap-from-window)',   'Leap from window' },
      { { 'n', 'x', 'o' }, 'gs', '<Plug>(leap-cross-window)',  'Leap from window' },
   } do
      local modes, lhs, rhs, desc = unpack(t)
      for _, mode in ipairs(modes) do
         -- If not forced, only set the keymaps if:
         -- 1. A keyseq starting with `lhs` is not already mapped to
         --    something else.
         -- 2. There is no existing mapping to the <Plug> key.
         if force or (
            vim.fn.mapcheck(lhs, mode) == '' and vim.fn.hasmapto(rhs, mode) == 0
         ) then
            vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
         end
      end
   end
end

local function setup(user_opts)
   local opts = require('leap.opts').default
   for k, v in pairs(user_opts) do
      opts[k] = v
   end
end

return {
   with_traversal_keys = with_traversal_keys,
   get_enterable_windows = get_enterable_windows,
   get_focusable_windows = get_focusable_windows,
   set_backdrop_highlight = set_backdrop_highlight,
   -- deprecated --
   set_repeat_keys = set_repeat_keys,
   add_repeat_mappings = set_repeat_keys,
   add_default_mappings = add_default_mappings,
   setup = setup,
}
