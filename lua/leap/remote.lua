local api = vim.api

local function action(kwargs)
   kwargs = kwargs or {}
   local jumper = kwargs.jumper
   local input = kwargs.input
   local use_count = kwargs.count ~= false

   local state = {
      args = kwargs,
      -- `jumper` can mess with these below.
      mode = vim.fn.mode(1),
      count = vim.v.count,
      register = vim.v.register
   }

   local src_win = vim.fn.win_getid()
   local saved_view = vim.fn.winsaveview()
   -- Set an extmark as an anchor, so that we can execute remote delete
   -- commands in the backward direction, and move together with the text.
   local anch_ns = api.nvim_create_namespace('')
   local anch_id = api.nvim_buf_set_extmark(
      0, anch_ns, saved_view.lnum - 1, saved_view.col, {}
   )

   jumper = jumper or function()
      -- We are back in Normal mode when this call is executed, so _we_
      -- should tell Leap whether it is OK to autojump.
      -- If `input` is given, all bets are off - before moving on to a
      -- labeled target, we would have to undo whatever action was taken
      -- (practically impossible).
      -- Visual and Operator-pending mode are also problematic, because
      -- we could only re-trigger them inside the `leap()` call, with a
      -- custom action, and that would prevent users from customizing
      -- the jumper.
      local no_autojump = (input and #input > 0) or state.mode ~= 'n'
      require('leap').leap {
         windows = require('leap.user').get_focusable_windows(),
         opts = no_autojump and { safe_labels = '' } or nil,
      }
   end

   local function to_normal_mode()
      if state.mode:match('^[vV\22]') then
         api.nvim_feedkeys(state.mode, 'n', false)
      elseif state.mode:match('o') then
         -- I'm just cargo-culting this TBH, but the combination of
         -- the two indeed seems to work reliably.
         api.nvim_feedkeys(vim.keycode('<C-\\><C-N>'), 'nx', false)
         api.nvim_feedkeys(vim.keycode('<esc>'), 'n', false)
      end
   end

   local function back_to_pending_action()
      if state.mode:match('^[vV\22]') then
         api.nvim_feedkeys(state.mode, 'n', false)
      elseif state.mode:match('o') then
         local count = (use_count and state.count > 0) and state.count or ''
         local register = '"' .. state.register
         local op = vim.v.operator
         local force = state.mode:sub(3)
         api.nvim_feedkeys(count .. register .. op .. force, 'n', false)
      end
   end

   local function cursor_moved()
      return vim.fn.win_getid() ~= src_win
         or vim.fn.line('.') ~= saved_view.lnum
         or vim.fn.col('.') ~= saved_view.col + 1
   end

   local function restore_cursor()
      if vim.fn.win_getid() ~= src_win then
         api.nvim_set_current_win(src_win)
      end
      vim.fn.winrestview(saved_view)
      local anch_pos = api.nvim_buf_get_extmark_by_id(0, anch_ns, anch_id, {})
      api.nvim_win_set_cursor(0, { anch_pos[1] + 1, anch_pos[2] })
      api.nvim_buf_clear_namespace(0, anch_ns, 0, -1)
   end

   local function register_followup_actions()
      local action_canceled = false
      -- Register "cancel" keys.
      local listener_id = vim.on_key(function(key, _)
         if key == vim.keycode('<esc>') or key == vim.keycode('<c-c>') then
            action_canceled = true
         end
      end)
      api.nvim_create_autocmd('ModeChanged', {
         pattern = '*:*',
         once = true,
         callback = function ()
            local is_change_op = vim.fn.mode(1):match('o') and (vim.v.operator == 'c')
            api.nvim_create_autocmd('ModeChanged', {
               pattern = is_change_op and 'i:n' or '*:n',
               once = true,
               callback = vim.schedule_wrap(function()
                  restore_cursor()
                  vim.on_key(nil, listener_id)  -- remove listener
                  if not action_canceled then
                     api.nvim_exec_autocmds('User', {
                        pattern = 'RemoteOperationDone',
                        data = state
                     })
                  end
               end)
            })
         end
      })
   end

   local function after_jump()
      if not cursor_moved() then return end
      -- Add target postion to jumplist.
      vim.cmd('norm! m`')
      back_to_pending_action()  -- (feedkeys...)
      -- No 'n' flag, custom mappings should work here.
      if input then api.nvim_feedkeys(input, '', false) end
      -- Wait for `feedkeys`.
      vim.schedule(register_followup_actions)
   end

   -- Execute "spooky" action: jump - operate - restore.

   to_normal_mode()  -- (feedkeys...)
   -- Wait for `feedkeys`.
   vim.schedule(function()
      if type(jumper) == 'function' then
         jumper()
         -- Wait for `jumper` to finish its business.
         vim.schedule(function() after_jump() end)
      elseif type(jumper) == 'string' then
         -- API note: `jumper` could of course call `feedkeys` itself,
         -- but then we would need an independent parameter that tells
         -- whether to wait for `CmdlineLeave`.
         api.nvim_feedkeys(jumper, 'n', false)
         vim.schedule(function()
            -- Wait for finishing the search command (autocmd), and then
            -- for actually leaving the command line (schedule wrap).
            api.nvim_create_autocmd('CmdlineLeave', {
               once = true,
               callback = vim.schedule_wrap(after_jump)
            })
         end)
      end
   end)
end

return {
   action = action
}
