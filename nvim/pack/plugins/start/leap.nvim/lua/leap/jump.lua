local api = vim.api

local function is_cursor_before_eol()
   return vim.fn.virtcol('.') == (vim.fn.virtcol('$') - 1)
end

local function is_cursor_before_eof()
   return is_cursor_before_eol and vim.fn.line('.') == vim.fn.line('$')
end

--- Pushes cursor 1 character forward or backward, possibly beyond EOL.
local function push_cursor(dir)
   vim.fn.search('\\_.', (dir == 'fwd') and 'W' or (dir == 'bwd') and 'bW')
end

local function push_beyond_eol()
   local saved = vim.o.virtualedit
   vim.o.virtualedit = 'onemore'
   -- Note: No need to undo this afterwards, the cursor will be moved to
   -- the end of the operated area anyway.
   vim.cmd('norm! l')
   api.nvim_create_autocmd({
      'CursorMoved', 'WinLeave', 'BufLeave',
      'InsertEnter', 'CmdlineEnter', 'CmdwinEnter',
   }, {
      once = true,
      callback = function() vim.o.virtualedit = saved end,
   })
end

local function add_offset(offset)
   if offset < 0 then
      push_cursor('bwd')
   elseif offset > 0 then
      if is_cursor_before_eol() then
         push_beyond_eol()
      else
         push_cursor('fwd')
      end
      -- deprecated
      if offset > 1 then
         if is_cursor_before_eol() then
            push_beyond_eol()
         else
            push_cursor('fwd')
         end
      end
   end
end

--- When applied after an exclusive motion (like setting the cursor via
--- the API), makes the motion appear to behave as an inclusive one.
local function simulate_inclusive_op(mode)
   local force = vim.fn.matchstr(mode, '^no\\zs.')
   if force == '' then
      -- In the charwise case, we should push the cursor forward.
      if is_cursor_before_eof() then
         push_beyond_eol()
      else
         push_cursor('fwd')
      end
   elseif force == 'v' then
      -- We also want the `v` modifier to behave in the native way, that
      -- is, as inclusive/exclusive toggle on charwise motions (:h o_v).
      -- As `v` will change our (technically) exclusive motion to
      -- inclusive, we should push the cursor back to undo that.
      push_cursor('bwd')
   else
      -- Blockwise (<c-v>) itself makes the motion inclusive.
   end
end

local function force_matchparen_refresh()
   -- HACK: :DoMatchParen turns matchparen on simply by triggering
   -- CursorMoved events (see matchparen.vim). We can do the same, which
   -- is cleaner for us than calling :DoMatchParen directly, since that
   -- would wrap this in a `windo`, and might visit another buffer,
   -- breaking our visual selection (and thus also dot-repeat,
   -- apparently). (See :h visual-start, and lightspeed#38.)
   -- Programming against the API would be more robust of course, but in
   -- the unlikely case that the implementation details would change,
   -- this still cannot do any damage on our side if called with pcall
   -- (the feature just ceases to work then).
   pcall(api.nvim_exec_autocmds, 'CursorMoved', { group = 'matchparen' })
   pcall(api.nvim_exec_autocmds, 'CursorMoved', { group = 'matchup_matchparen' })
end

local function jump_to(pos, kwargs)
   local lnum, col = unpack(pos)
   local win = kwargs.win
   local mode = kwargs.mode
   local offset = kwargs.offset
   local is_backward = kwargs.is_backward
   local is_inclusive = kwargs.is_inclusive
   local add_to_jumplist = kwargs.add_to_jumplist
   local is_op_mode = mode:match('o')

   if add_to_jumplist then
      -- Note: <C-o> will ignore this on the same line (neovim#9874).
      vim.cmd('norm! m`')
   end

   -- Move.
   if win ~= api.nvim_get_current_win() then
      api.nvim_set_current_win(win)
   end
   api.nvim_win_set_cursor(0, { lnum, col - 1 })
   if offset then
      add_offset(offset)
   end
   if is_op_mode and is_inclusive and not is_backward then
      -- Since Vim interprets our jump as exclusive (:h exclusive), we
      -- need custom tweaks to behave as inclusive. (This is only
      -- relevant in the forward direction, as inclusiveness applies to
      -- the end of the selection.)
      simulate_inclusive_op(mode)
   end

   -- Refresh view.
   if not is_op_mode then
      force_matchparen_refresh()
   end
end

return {
   jump_to = jump_to
}
