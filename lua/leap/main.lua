-- Imports & aliases ///1

local hl = require('leap.highlight')
local opts = require('leap.opts')

local set_beacons = require('leap.beacons').set_beacons
local resolve_conflicts = require('leap.beacons').resolve_conflicts
local light_up_beacons = require('leap.beacons').light_up_beacons

local get_char = require('leap.input').get_char
local get_char_keymapped = require('leap.input').get_char_keymapped

local api = vim.api
local keycode = vim.keycode
-- Use these to handle multibyte characters.
local split = vim.fn.split
local lower = vim.fn.tolower
local upper = vim.fn.toupper

local abs = math.abs
local ceil = math.ceil
local floor = math.floor
local min = math.min


-- Utils ///1

local function clamp(x, minval, maxval)
   return (x < minval) and minval
      or (x > maxval) and maxval
      or x
end

local function echo(msg)
   return api.nvim_echo({ { msg } }, false, {})
end

-- Returns to Normal mode and restores the cursor position.
local function handle_interrupted_change_op()
   -- |:help CTRL-\_CTRL-N|
   local seq = keycode('<C-\\><C-N>' .. (vim.fn.col('.') > 1 and '<RIGHT>' or ''))
   api.nvim_feedkeys(seq, 'n', true)
end

-- repeat.vim support (see the docs in the script:
-- https://github.com/tpope/vim-repeat/blob/master/autoload/repeat.vim)
local function set_dot_repeat_()
   -- Note: We're not checking here whether the operation should be
   -- repeated (see `set_dot_repeat()` in `leap()`).
   local op = vim.v.operator
   local force = vim.fn.mode(true):sub(3)  -- v/V/ctrl-v
   local leap = keycode('<cmd>lua require"leap".leap { dot_repeat = true }<cr>')
   local seq = op .. force .. leap
   if op == 'c' then
      -- The (not-yet-inserted) replacement text will be available in
      -- the '.' register once we're done (|:help quote.|).
      seq = seq .. keycode('<c-r>.<esc>')
   end
   -- Using pcall, since vim-repeat might not be installed.
   pcall(vim.fn['repeat#setreg'], seq, vim.v.register)
   -- Note: we could feed [count] here, but instead we're saving
   -- the value in our `state` table (`target_idx`).
   pcall(vim.fn['repeat#set'], seq, -1)
end

-- Equivalence classes

-- Return a char->equivalence-class lookup table.
local function to_membership_lookup(eqv_classes)
   local res = {}
   for _, class in ipairs(eqv_classes) do
      local class_tbl = (type(class) == 'string') and split(class, '\\zs') or class
      for _, char in ipairs(class_tbl) do
         res[char] = class_tbl
      end
   end
   return res
end

-- We use this helper fn both for the search pattern and for the sublist
-- keys, but 'smartcase' should only be considered in the search phase
-- (see |:help leap-wildcard-problem|).
local function get_equivalence_class(ch, consider_smartcase)
   if
      not vim.go.ignorecase
      or (consider_smartcase and vim.go.smartcase and lower(ch) ~= ch)
   then
      return opts.eqv_class_of[ch]
   else
      -- For collections in the search pattern, either is fine, since
      -- 'ignorecase' applies here. With sublists, the contract is that
      -- lowercase will be the representative character.
      return opts.eqv_class_of[lower(ch)] or opts.eqv_class_of[upper(ch)]
   end
end

local function get_representative_char(ch)
   -- Choosing the first one from an equivalence class (arbitrary).
   local eqclass = get_equivalence_class(ch)
   ch = eqclass and eqclass[1] or ch
   return vim.go.ignorecase and lower(ch) or ch
end


-- Search pattern ///1

local function char_list_to_collection_str(chars)
   local prepared = {
      -- lua escape seqs (|:help lua-literal|)
      ['\a'] = '\\a',
      ['\b'] = '\\b',
      ['\f'] = '\\f',
      ['\n'] = '\\n',
      ['\r'] = '\\r',
      ['\t'] = '\\t',
      ['\v'] = '\\v',
      ['\\'] = '\\\\',
      -- vim collection magic chars (|:help /collection|)
      [']'] = '\\]',
      ['^'] = '\\^',
      ['-'] = '\\-',
   }
   return table.concat(vim.tbl_map(function(ch)
      return prepared[ch] or ch
   end, chars))
end

local function expand(char)                                   -- <= 'a'
   local lst = get_equivalence_class(char, true) or { char }  -- => {'a','á','ä'}
   return char_list_to_collection_str(lst)                    -- => 'aáä'
end

--- Transforms user input to the appropriate search pattern.
---
--- NOTE: If preview (two-step processing) is enabled, for any kind of
--- input mapping (case-insensitivity, character classes, etc.) we need
--- to tweak things in two different places:
--- 1. For the first input, we can modify the search pattern itself.
--- 2. The second input is only acquired once the search is done; for
--- that, we need to play with the sublist keys
---
---@see populate_sublists
---@param in1 string
---@param in2? string
---@param inputlen integer
---
local function prepare_pattern(in1, in2, inputlen)
   local prefix = '\\V'
   if vim.fn.mode(1):match('V') then
      -- Skip the current line in linewise modes. (Hardcode the number,
      -- we might set the cursor before starting the search.)
      local lnum = vim.fn.line('.')
      prefix = prefix .. '\\(\\%<' .. lnum .. 'l\\|\\%>' .. lnum .. 'l\\)'
   end

   -- Two other convenience features:
   -- 1. Same-character pairs (==) match longer sequences (=====) only
   -- at the beginning.
   -- 2. EOL can be matched by typing a newline alias twice. (See also
   -- `populate_sublists()`.)

   -- (Mind the order, format() interpolates nil without complaint.)
   local in1_ = expand(in1)  -- 'a'=>'aáä'
   local p1 = ('\\[%s]'):format(in1_)
   local notp1 = ('\\[^%s]'):format(in1_)
   local p2 = in2 and ('\\[%s]'):format(expand(in2))
   local notp1_or_eol = ([[\(%s\|\$\)]]):format(notp1)
   local first_p1 = ([[\(\^\|%s\)\zs%s]]):format(notp1, p1)

   local pattern
   if p2 and (p1 ~= p2) then
      pattern = p1 .. p2
   elseif p2 and (p1 == p2) then
      -- To implement [2], add `$` as another branch if `p1` might
      -- represent newline.
      pattern = first_p1 .. p1 .. (p1:match('\\n') and '\\|\\$' or '')
   elseif inputlen == 2 then
      -- Preview; now [2] will be handled by `populate_sublists()`, but
      -- first we need to match `p1$` here.
      pattern = first_p1 .. p1 .. '\\|' .. p1 .. notp1_or_eol
   elseif inputlen == 1 then
      pattern = first_p1       .. '\\|' .. p1 .. '\\ze' .. notp1_or_eol
   end

   return prefix .. '\\(' .. pattern .. '\\)'
end


-- Processing targets ///1

--- Populates a sub-table in `targets` containing lists that allow for
--- easy iteration through each subset of targets with a given successor
--- char.
---
--- from:
---   { T1, T2, T3, T4 }
---     xa  xb  xa  xc
--- to:
---   {
---     T1, T2, T3, T4,
---     sublists = {
---       a = { T1, T3 },
---       b = { T2 },
---       c = { T4 },
---     }
---   }
---
---@see prepare_pattern
local function populate_sublists(targets)
   -- Setting a metatable to handle case insensitivity and equivalence
   -- classes (in both cases: multiple keys -> one value).
   -- If `ch` is not found, try to get a sublist belonging to some
   -- common key: the equivalence class that `ch` belongs to (if there
   -- is one), or, if case insensivity is set, the lowercased verison of
   -- `ch`. (And in the above cases, `ch` will not be found, since we
   -- also redirect to the common keys when inserting a new sublist.)
   targets.sublists = setmetatable({}, {
      __index = function(self, ch)
         return rawget(self, get_representative_char(ch))
      end,
      __newindex = function(self, ch, sublist)
         rawset(self, get_representative_char(ch), sublist)
      end,
   })
   -- Filling the sublists.
   for _, target in ipairs(targets) do
      local ch1, ch2 = unpack(target.chars)
      -- Handle newline matches. (See `prepare_pattern()` too.)
      local key = (ch1 == '' or ch2 == '') and '\n' or ch2
      if not targets.sublists[key] then
         targets.sublists[key] = {}
      end
      table.insert(targets.sublists[key], target)
   end
end

--- Returns a modified copy of the provided label list, that allows
--- safe traversal.
local function as_traversable(labels, prepend_next_key)
   if #labels == 0 then return labels end

   local keys = opts.keys

   -- Remove the traversal keys if they appear on the label list.
   local bad_keys = ''
   for _, key in ipairs { keys.next_target, keys.prev_target } do
      bad_keys = bad_keys .. (
         type(key) == 'table'
         and table.concat(vim.tbl_map(keycode, key))
         or keycode(key)
      )
   end
   local traversable = labels:gsub('[' .. bad_keys .. ']', '')

   if prepend_next_key then
      -- Use the "unsafe" next-key (|:help leap-clever-repeat|) as the
      -- first label, if adequate, since its effect is equivalent.
      local key_next = (type(keys.next_target) == 'table') and keys.next_target[2]
      -- Prepend if actually displayable.
      if key_next and keycode(key_next) == key_next and key_next:match('%S') then
         traversable = key_next .. traversable
      end
   end

   return traversable
end

local function all_in_the_same_window(targets)
   if not targets[1].wininfo then return true end
   local win = targets[1].wininfo.winid
   -- Iterate backwards to get at least a negative answer in O(1), in
   -- case the targets are ordered by window (which is almost certainly
   -- true, but let's not enforce it as a contract by checking only the
   -- last item here).
   for i = #targets, 1, -1 do
      if targets[i].wininfo.winid ~= win then
         return false
      end
   end
   return true
end

-- Problem:
--     xy   target #1
--   xyL    target #2 (labeled)
--     ^    auto-jump would move the cursor here (covering the label)
--
-- Note: The situation implies backward search, and may arise in phase
-- two, when only the chosen sublist remained.
--
-- Caveat: this case in fact depends on the label position, for which
-- the `beacons` module is responsible (e.g. the label is on top of the
-- match when repeating), but we're not considering that, and just err
-- on the safe side instead of complicating the code.
local function cursor_would_cover_the_first_label_on_autojump(targets)
   local t1, t2 = targets[1], targets[2]
   if t2 and t2.chars and not t2.is_offscreen then
      local line1, col1 = unpack(t1.pos)
      local line2, col2 = unpack(t2.pos)
      return line1 == line2 and col1 == (col2 + #table.concat(t2.chars))
   end
end

local function count_onscreen(targets)
   local count = 0
   for _, target in ipairs(targets) do
      if not target.is_offscreen then count = count + 1 end
   end
   return count
end

---@param targets table
---@param kwargs table
local function prepare_labeled_targets(targets, kwargs)
   local can_traverse = kwargs.can_traverse
   local force_noautojump = kwargs.force_noautojump
   local multi_windows = kwargs.multi_windows

   local labels, safe_labels = opts.labels, opts.safe_labels
   if can_traverse then
      -- Stricter than necessary, for the sake of simplicity
      -- (we haven't decided about autojump yet).
      local prepend_next_key = not (
         targets[1].is_offscreen
         or targets[2] and targets[2].is_offscreen
      )
      labels, safe_labels =
         as_traversable(opts.labels, prepend_next_key),
         as_traversable(opts.safe_labels, prepend_next_key)
   end

   -- Sets a flag indicating whether we can automatically jump to the
   -- first target, without having to select a label.
   local function set_autojump()
      if not (
         force_noautojump
         or #safe_labels == 0
         -- Prevent shifting the viewport (we might want to select a label).
         or targets[1].is_offscreen and #targets > 1
         -- Problem: We are autojumping to some position in window A, but
         -- our chosen labeled target happens to be in window B - in that
         -- case we do not actually want to reposition the cursor in window
         -- A. Restoring it afterwards would be overcomplicated, not to
         -- mention that the jump itself is disorienting, especially
         -- A->B->C (autojumping to B, before moving to C).
         or multi_windows and not all_in_the_same_window(targets)
         or cursor_would_cover_the_first_label_on_autojump(targets)
      ) then
         -- Forced or "smart" autojump, respectively.
         targets.autojump = (#labels == 0)
            or count_onscreen(targets) <= #safe_labels + 1
      end
   end

   local function attach_label_set()
      -- Note that `labels` => no `autojump`, and `autojump` =>
      -- `safe_labels`, but the converse statmenets do not hold.
      targets.label_set =
         #labels == 0 and safe_labels
         or #safe_labels == 0 and labels
         or targets.autojump and safe_labels
         or labels
   end

   -- Assigns a label to each target, by repeating the label set
   -- indefinitely, and registers the number of the label group the
   -- target is part of.
   -- Note that these are once-and-for-all fixed attributes, regardless
   -- of the actual UI state ('beacons').
   local function set_labels()
      -- We need to handle multibyte chars anyway, it's better to create
      -- a table than calling `strcharpart()` for each access.
      local labelset = split(targets.label_set, '\\zs')
      local len_labelset = #labelset
      local skipped = targets.autojump and 1 or 0
      for i = (skipped + 1), #targets do
         local target = targets[i]
         if target then
            local ii = i - skipped
            if target.is_offscreen then
               skipped = skipped + 1
            else
               local mod = ii % len_labelset
               if mod == 0 then
                  target.label = labelset[len_labelset]
                  target.group = floor(ii / len_labelset)
               else
                  target.label = labelset[mod]
                  target.group = floor(ii / len_labelset) + 1
               end
            end
         end
      end
   end

   -- Note: The three depend on each other, in this order.
   set_autojump()
   attach_label_set()
   set_labels()
end

local function normalize_directional_indexes(targets)
   -- Like: -7 -4 -2 | 1  3  7
   --    => -3 -2 -1 | 1  2  3
   local backward, forward = {}, {}
   for _, t in ipairs(targets) do
      table.insert(t.idx < 0 and backward or forward, t.idx)
   end
   table.sort(backward, function(x, y) return x > y end)  -- {-2,-4,-7}
   table.sort(forward)  -- {1,3,7}

   local new_idx = {}
   for i, idx in ipairs(backward) do new_idx[idx] = -i end
   for i, idx in ipairs(forward) do new_idx[idx] = i end

   for _, t in ipairs(targets) do
      t.idx = new_idx[t.idx]
   end
end


-- Leap ///1

local function notify_user_about_removed_opts()
   if opts.highlight_unlabeled_phase_one_targets == true then
      vim.notify(
         [[
leap.nvim: the option `highlight_unlabeled_phase_one_targets` has been removed.

If really necessary, the following workaround can be used:

   require('leap').opts.on_beacons = function(targets)
     for _, t in ipairs(targets) do
       if not t.label and not t.beacon and t.chars and t.is_previewable ~= false then
         t.beacon = { 0, { virt_text = { { table.concat(t.chars), 'LeapMatch' } } }, }
       end
     end
   end

To view this message again, type `:messages` and navigate to the bottom.
]],
         vim.log.levels.WARN
      )
   elseif opts.case_sensitive == true then
      vim.notify(
            [[
leap.nvim: the option `case_sensitive` has been removed.

Instead, you can set `ignorecase` for leap() calls:
   require('leap').opts.vim_opts['go.ignorecase'] = false

See `:help leap-features`, `:help leap.opts.vim_opts`.

To view this message again, type `:messages` and navigate to the bottom.
]],
         vim.log.levels.WARN
      )
   end
end

-- State persisted between invocations.
local state = {
   ['repeat'] = {
      in1 = nil,
      in2 = nil,
      pattern = nil,
      -- For when wanting to repeat in relative direction
      -- (for outside use only).
      backward = nil,
      inclusive = nil,
      offset = nil,
      inputlen = nil,
      opts = nil
   },
   dot_repeat = {
      targets = nil,
      pattern = nil,
      in1 = nil,
      in2 = nil,
      target_idx = nil,
      backward = nil,
      inclusive = nil,
      offset = nil,
      inputlen = nil,
      opts = nil
   },
   -- We also use this table to make the argumens passed to `leap()`
   -- accessible for autocommands (using event data would be cleaner,
   -- but it is far too problematic, as it cannot handle tables with
   -- mixed keys, metatables, function values, etc.).
   args = nil,
}

--- Entry point for Leap motions.
local function leap(kwargs)
   -- Handling deprecated field names.
   -- Note: Keep the legacy fields too, do not break user autocommands.
   if kwargs.target_windows then kwargs.windows = kwargs.target_windows end
   if kwargs.inclusive_op then kwargs.inclusive = kwargs.inclusive_op end

   state.args = kwargs

   local invoked_repeat = kwargs['repeat']
   local invoked_dot_repeat = kwargs.dot_repeat
   local windows = kwargs.windows
   local user_given_opts = kwargs.opts
   local user_given_targets = kwargs.targets
   local user_given_action = kwargs.action
   local action_can_traverse = kwargs.traversal

   local dot_repeatable =
      invoked_dot_repeat and state.dot_repeat
      or kwargs

   local is_backward = dot_repeatable.backward

   local repeatable =
      invoked_dot_repeat and state.dot_repeat
      or invoked_repeat and state['repeat']
      or kwargs

   local is_inclusive = repeatable.inclusive
   local offset = repeatable.offset
   local user_given_inputlen = repeatable.inputlen
   local user_given_pattern = repeatable.pattern

   -- Chores to do before accessing `opts`.
   do
      -- `opts` hierarchy: current >> saved-for-repeat >> default

      -- We might want to give specific arguments exclusively for
      -- repeats - see e.g. `user.set_repeat_keys()` - so we merge the
      -- saved values.
      -- From here on we let the metatable of `opts` dispatch between
      -- `current_call` vs `default` though.
      opts.current_call =
         not user_given_opts and {}
         or invoked_repeat and vim.tbl_deep_extend(
            'keep', user_given_opts, state['repeat'].opts or {}
         )
         or invoked_dot_repeat and vim.tbl_deep_extend(
            'keep', user_given_opts, state.dot_repeat.opts or {}
         )
         or user_given_opts

      if opts.current_call.equivalence_classes then
         opts.current_call.eqv_class_of = setmetatable(
            to_membership_lookup(opts.current_call.equivalence_classes),
            -- Prevent merging with the defaults, as this is derived
            -- programmatically from a list-like option (see `opts.lua`).
            { merge = false }
         )
      end

      -- Force the label lists into strings (table support is deprecated).
      for _, tbl in ipairs { 'default', 'current_call' } do
         for _, key in ipairs { 'labels', 'safe_labels' } do
            if type(opts[tbl][key]) == 'table' then
               opts[tbl][key] = table.concat(opts[tbl][key])
            end
         end
      end

      notify_user_about_removed_opts()
   end

   local is_directional = not windows
   local no_labels_to_use = #opts.labels == 0 and #opts.safe_labels == 0

   if not is_directional and no_labels_to_use then
      echo('no labels to use')
      return
   end
   if windows and #windows == 0 then
      echo('no targetable windows')
      return
   end

   -- We need to save the mode here, because the `:normal` command in
   -- `jump.jump_to()` can change the state. See vim/vim#9332.
   local mode = api.nvim_get_mode().mode
   local is_visual_mode = mode:match('^[vV\22]')
   local is_op_mode = mode:match('o')
   local is_change_op = is_op_mode and (vim.v.operator == 'c')

   local count
   if is_directional then
      if vim.v.count ~= 0 then
         count = vim.v.count
      elseif is_op_mode and no_labels_to_use then
         count = 1
      end
   end

   local is_keyboard_input = not (
      invoked_repeat
      or invoked_dot_repeat
      or user_given_inputlen == 0
      or type(user_given_pattern) == 'string'
      or user_given_targets
   )
   local inputlen = user_given_inputlen or (is_keyboard_input and 2) or 0

   -- Force the values in `opts.keys` into a table, and translate keycodes.
   -- Using a metatable instead of deepcopy, in case one would modify
   -- the entries on `LeapEnter` (or even later).
   local keys = setmetatable({}, {
      __index = function(_, k)
         local v = opts.keys[k]
         return vim.tbl_map(keycode, type(v) == 'string' and { v } or v)
      end
   })

   -- The first key on a `keys` list is considered "safe"
   -- (not to be used as search input).
   local contains = vim.list_contains
   local contains_first = function(t, v) return t[1] == v end

   -- Ephemeral state (of the current call) that is not interesting
   -- for the outside world.
   local st = {
      -- Multi-phase processing (show preview)?
      phase =
         is_keyboard_input
         and inputlen == 2
         and not no_labels_to_use
         and opts.preview ~= false
         and 1
         or nil,
      -- When repeating a `{char}<enter>` search (started to traverse
      -- after the first input).
      repeating_shortcut = false,
      -- For traversal mode.
      curr_idx = 0,
      -- Currently selected label group, 0-indexed
      -- (`target.group` starts at 1).
      group_offset = 0,
      -- For getting keymapped input (see `input.lua`).
      prompt = nil,
      errmsg = nil,
   }

   local function exec_user_autocmds(pattern)
      api.nvim_exec_autocmds('User', { pattern = pattern, modeline = false })
   end

   local exit
   do
     local exited
     exit = function()
        exec_user_autocmds('LeapLeave')
        assert(not exited)
        exited = true
     end
   end

   local function exit_early()
      if is_change_op then handle_interrupted_change_op() end
      if st.errmsg then echo(st.errmsg) end
      exit()
   end

   local function with_redraw(callback)
      exec_user_autocmds('LeapRedraw')
      -- Should be called after `LeapRedraw` - the idea is that callbacks
      -- clean up after themselves on that event (next time, that is).
      if callback then callback() end
      vim.cmd.redraw()
      -- Should be after `redraw()`, to avoid a flickering effect
      -- when jumping directly onto a label.
      pcall(api.nvim__redraw, { cursor = true })  -- EXPERIMENTAL API
   end

   local function can_traverse(targets)
      return action_can_traverse or (
         is_directional
         and not (count or is_op_mode or user_given_action)
         and #targets >= 2
      )
   end

   -- When traversing without labels, keep highlighting the same one
   -- group of targets, and do not shift until reaching the end of the
   -- group - it is less disorienting if the "snake" does not move
   -- continuously, on every jump.
   local function get_number_of_highlighted_traversal_targets()
      local group_size = opts.max_highlighted_traversal_targets or 10  -- deprecated
      -- Assumption: being here means we are after an autojump, and
      -- started highlighting from the 2nd target (no `count`). Thus, we
      -- can use `st.curr-idx` as the reference, instead of some
      -- separate counter (but only because of the above).
      local consumed = (st.curr_idx - 1) % group_size
      local remaining = group_size - consumed
      -- Switch just before the whole group gets eaten up.
      return remaining <= 1 and (remaining + group_size) or remaining
   end

   local function get_highlighted_idx_range(targets, use_no_labels)
      if use_no_labels and (opts.max_highlighted_traversal_targets == 0) then  -- deprecated
         return 0, -1  -- empty range
      else
         local n = get_number_of_highlighted_traversal_targets()
         local start = st.curr_idx + 1
         local _end = use_no_labels and min(start - 1 + n, #targets)
         return start, _end
      end
   end

   local function get_target_with_active_label(targets, input)
      for idx, target in ipairs(targets) do
         if target.label then
            local relative_group = target.group - st.group_offset
            if relative_group > 1 then  -- beyond the active group
               return
            end
            if relative_group == 1 and target.label == input then
               return target, idx
            end
         end
      end
   end

  -- Get inputs

   local function get_repeat_input()
      if not state['repeat'].in1 then
         st.errmsg = 'no previous search'
         return
      else
         if inputlen == 1 then
            return state['repeat'].in1
         elseif inputlen == 2 then
            if not state['repeat'].in2 then
               st.repeating_shortcut = true
            end
            return state['repeat'].in1, state['repeat'].in2
         end
      end
   end

   local function get_first_pattern_input()
      with_redraw()
      local in1, prompt = get_char_keymapped(st.prompt)
      if in1 then
         if contains_first(keys.next_target, in1) then
            st.phase = nil
            return get_repeat_input()
         else
            st.prompt = prompt
            return in1
         end
      end
   end

   local function get_second_pattern_input(targets)
      -- Note: `count` does _not_ automatically disable two-phase
      -- processing altogether, as we might want to do a char<enter>
      -- shortcut, but it implies not needing to show beacons.
      if not count then
         with_redraw(function() light_up_beacons(targets) end)
      end
      return get_char_keymapped(st.prompt)
   end

   local function get_full_pattern_input()
      local in1, in2 = get_first_pattern_input()
      if in1 and in2 then
         return in1, in2
      elseif in1 then
         if inputlen == 1 then
            return in1
         else
            local in2_ = get_char_keymapped(st.prompt)
            if in2_ then
               return in1, in2_
            end
         end
      end
   end

   -- Get targets

   ---@param pattern string
   ---@param in1? string
   ---@param in2? string
   local function get_targets(pattern, in1, in2)
      local errmsg = in1 and ('not found: ' .. in1 .. (in2 or '')) or 'no targets'
      local targets = require('leap.search').get_targets(pattern, {
         is_backward = is_backward,
         windows = windows,
         offset = offset,
         is_op_mode = is_op_mode,
         inputlen = inputlen,
      })
      if not targets then
         st.errmsg = errmsg
         return
      else
         return targets
      end
   end

   local function get_user_given_targets(targets_)
      local default_errmsg = 'no targets'
      local targets, errmsg = (type(targets_) == 'function') and targets_() or targets_
      if not targets or #targets == 0 then
         st.errmsg = errmsg or default_errmsg
         return
      else
         -- Fill wininfo-s when not provided.
         if not targets[1].wininfo then
            local wininfo = vim.fn.getwininfo(api.nvim_get_current_win())[1]
            for _, t in ipairs(targets) do
               t.wininfo = wininfo
            end
         end
         return targets
      end
   end

   --- Sets `autojump` and `label_set` attributes for the target list,
   --- plus `label` and `group` attributes for each individual target.
   ---@param targets table
   local function prepare_labeled_targets_(targets)
      prepare_labeled_targets(targets, {
         can_traverse = can_traverse(targets),
         force_noautojump =
            not action_can_traverse
            and (
               -- No jump, doing sg else.
               user_given_action
               -- Should be able to select our target.
               or is_op_mode and #targets > 1
            ),
         multi_windows = windows and #windows > 1,
      })
   end

   -- Repeat

   local repeat_state = {
      offset = kwargs.offset,
      backward = kwargs.backward,
      inclusive = kwargs.inclusive,
      pattern = kwargs.pattern,
      inputlen = inputlen,
      opts = vim.deepcopy(opts.current_call),
   }

   local function update_repeat_state(in1, in2)
      if
         not (invoked_repeat or invoked_dot_repeat)
         and (is_keyboard_input or user_given_pattern)
      then
         state['repeat'] = vim.tbl_extend('error', repeat_state, {
            in1 = is_keyboard_input and in1,
            in2 = is_keyboard_input and in2,
         })
      end
   end

   local function set_dot_repeat(in1, in2, target_idx)
      local function update_dot_repeat_state()
         state.dot_repeat = vim.tbl_extend('error', repeat_state, {
            target_idx = target_idx,
            targets = user_given_targets,
            in1 = is_keyboard_input and in1,
            in2 = is_keyboard_input and in2,
         })
         if not is_directional then
            state.dot_repeat.backward = target_idx < 0
            state.dot_repeat.target_idx = abs(target_idx)
         end
      end

      local is_dot_repeatable_op =
         is_op_mode and (vim.o.cpo:match('y') or vim.v.operator ~= 'y')

      local is_dot_repeatable_call =
         is_dot_repeatable_op and not invoked_dot_repeat
         and type(user_given_targets) ~= 'table'

      if is_dot_repeatable_call then
         update_dot_repeat_state()
         set_dot_repeat_()
      end
   end

   -- Jump

   local jump_to
   do
      local is_first_jump = true
      jump_to = function(target)
         require('leap.jump').jump_to(target.pos, {
            add_to_jumplist = is_first_jump,
            win = target.wininfo.winid,
            mode = mode,
            offset = offset,
            is_backward = is_backward or (target.idx and target.idx < 0),
            is_inclusive = is_inclusive,
         })
         is_first_jump = false
      end
   end

   local do_action = user_given_action or jump_to

  -- Post-pattern loops

   local function select(targets)
      local n_groups = targets.label_set and ceil(#targets / #targets.label_set) or 0

      local function display()
         local use_no_labels = no_labels_to_use or st.repeating_shortcut
         -- Do _not_ skip this on initial invocation - we might have
         -- skipped setting the initial label states if using
         -- `keys.next_target`.
         set_beacons(targets, {
            group_offset = st.group_offset,
            phase = st.phase,
            use_no_labels = use_no_labels
         })
         local start, _end = get_highlighted_idx_range(targets, use_no_labels)
         with_redraw(function()
            light_up_beacons(targets, start, _end)
         end)
      end

      local function loop(is_first_invoc)
         display()
         if is_first_invoc then
            exec_user_autocmds('LeapSelectPre')
         end
         local input = get_char()
         if input then
            local shift =
               contains(keys.next_group, input) and 1
               or (contains(keys.prev_group, input) and not is_first_invoc) and -1

            if shift and n_groups > 1 then
               st.group_offset = clamp(st.group_offset + shift, 0, n_groups - 1)
               return loop(false)
            else
               return input
            end
         end
      end

      return loop(true)
   end

   ---@return integer?
   local function traversal_get_new_idx(idx, in_, targets)
      if contains(keys.next_target, in_) then
         return min(idx + 1, #targets)
      elseif contains(keys.prev_target, in_) then
         -- Wrap around backwards (useful for treesitter selection).
         return (idx <= 1) and #targets or (idx - 1)
      end
   end

   local function traverse(targets, start_idx, use_no_labels)
      local function on_first_invoc()
         if use_no_labels then
            for _, t in ipairs(targets) do
               t.label = nil
            end
         else
            -- Remove subsequent label groups.
            for _, target in ipairs(targets) do
               if target.group and target.group > 1 then
                  target.label = nil
                  target.beacon = nil
               end
            end
         end
      end

      local function display()
         set_beacons(targets, {
            group_offset = st.group_offset,
            phase = st.phase,
            use_no_labels = use_no_labels,
         })
         local start, _end = get_highlighted_idx_range(targets, use_no_labels)
         with_redraw(function()
            light_up_beacons(targets, start, _end)
         end)
      end

      local function loop(idx, is_first_invoc)
         if is_first_invoc then on_first_invoc() end
         st.curr_idx = idx
         display()  -- needs st.curr_idx

         local input = get_char()
         if input then
            local new_idx = traversal_get_new_idx(idx, input, targets)
            if new_idx then
               do_action(targets[new_idx])
               loop(new_idx, false)
            else
               -- We still want the labels (if there are) to function.
               local target, new_idx = get_target_with_active_label(targets, input)
               if target then
                  do_action(target)
                  -- Especially for treesitter selection, make it easier to correct.
                  if is_visual_mode then
                     loop(new_idx, false)
                  end
               else
                  vim.fn.feedkeys(input, 'i')
               end
            end
         end
      end

      loop(start_idx, true)
   end

   -- After all the stage-setting, here comes the main action you've all
   -- been waiting for:

   exec_user_autocmds('LeapEnter')

   local need_in1 =
      is_keyboard_input
      or (
         invoked_repeat
         and type(state['repeat'].pattern) ~= 'string'
         and state['repeat'].inputlen ~= 0
       )
      or (
         invoked_dot_repeat
         and type(state.dot_repeat.pattern) ~= 'string'
         and state.dot_repeat.inputlen ~= 0
         and not state.dot_repeat.targets
      )

   local in1, in2

   if need_in1 then
      if is_keyboard_input then
         if st.phase then
            -- This might call `get_repeat_input()`, and also return `in2`,
            -- if using `keys.next_target`.
            in1, in2 = get_first_pattern_input()  -- REDRAW
         else
            in1, in2 = get_full_pattern_input()   -- REDRAW
         end
      elseif invoked_repeat then
         in1, in2 = get_repeat_input()
      elseif invoked_dot_repeat then
         in1, in2 = state.dot_repeat.in1, state.dot_repeat.in2
      end

      if not in1 then
         return exit_early()
      end
   end

   local targets
   do
      local user_given_targets_ =
         user_given_targets or (invoked_dot_repeat and state.dot_repeat.targets)

      if user_given_targets_ then
         targets = get_user_given_targets(user_given_targets_)
      else
         local user_given_pattern_ =
            user_given_pattern
            or invoked_repeat and state['repeat'].pattern
            or invoked_dot_repeat and state.dot_repeat.pattern

         local pattern
         if type(user_given_pattern_) == 'string' then
            pattern = user_given_pattern_
         elseif type(user_given_pattern_) == 'function' then
            local prepared = in1 and prepare_pattern(in1, in2, inputlen) or ''
            pattern = user_given_pattern_(prepared, { in1, in2 })
         else
            pattern = prepare_pattern(in1, in2, inputlen)
         end

         targets = get_targets(pattern, in1, in2)
      end

      if not targets then
         return exit_early()
      end
   end

   if invoked_dot_repeat then
      local target = targets[state.dot_repeat.target_idx]
      if target then
         do_action(target)
         return exit()
      else
         return exit_early()
      end
   end

   if st.phase then
      -- Show preview.
      populate_sublists(targets)
      for _, sublist in pairs(targets.sublists) do
         prepare_labeled_targets_(sublist)
         set_beacons(sublist, { phase = st.phase })
      end
      resolve_conflicts(targets)
   else
      local use_no_labels = no_labels_to_use or st.repeating_shortcut
      if use_no_labels then
         targets.autojump = true
      else
         prepare_labeled_targets_(targets)
      end
   end

   local need_in2 = (inputlen == 2) and not (in2 or st.repeating_shortcut)

   if need_in2 then
      in2 = get_second_pattern_input(targets)  -- REDRAW

      if not in2 then
         return exit_early()
      end
   end

   if st.phase then st.phase = 2 end

   -- Jump eagerly to the first/count-th match on the whole unfiltered
   -- target list?
   local is_shortcut =
      st.repeating_shortcut or contains_first(keys.next_target, in2)

   -- Do this now - repeat can succeed, even if we fail this time.
   update_repeat_state(in1, not is_shortcut and in2 or nil)

   if is_shortcut then
      local n = count or 1
      local target = targets[n]
      if not target then
         return exit_early()
      end
     -- Do this before `do_action()`, because it might erase forced motion.
     -- (The `:normal` command in `jump.jump_to()` can change the state
     -- of `mode()`. See vim/vim#9332.)
      set_dot_repeat(in1, nil, target.idx or n)
      do_action(target)
      if can_traverse(targets) then
         traverse(targets, 1, true)
      end
      return exit()
   end

   exec_user_autocmds('LeapPatternPost')

   -- Get the sublist for `in2`, and work with that from here on (except
   -- if we've been given custom targets).
   local targets2
   do
      -- (Mind the logic, do not fall back to `targets`.)
      targets2 = (not targets.sublists) and targets or targets.sublists[in2]
      if not targets2 then
         -- Note: at this point, `in2` might only be nil if
         -- `st.repeating_shortcut` is true; that case implies there are
         -- no sublists, and there _are_ targets.
         st.errmsg = ('not found: ' .. in1 .. in2)
         return exit_early()
      end
      if (targets2 ~= targets) and targets2[1].idx then
         normalize_directional_indexes(targets2)  -- for dot-repeat
      end
   end

   local function exit_with_action_on(idx)
      local target = targets2[idx]
      set_dot_repeat(in1, in2, target.idx or idx)
      do_action(target)
      exit()
   end

   if count then
      if count > #targets2 then
         return exit_early()
      else
         return exit_with_action_on(count)
      end
   elseif invoked_repeat and not can_traverse(targets2) then
      return exit_with_action_on(1)
   end

   if targets2.autojump then
      if #targets2 == 1 then
         return exit_with_action_on(1)
      else
         do_action(targets2[1])
         st.curr_idx = 1
      end
   end

   local in_final = select(targets2)  -- REDRAW (LOOP)
   if not in_final then
      return exit_early()
   end

   -- Traversal - `prev_target` can also start it, wrapping backwards.
   if
      (
         contains(keys.next_target, in_final)
         or contains(keys.prev_target, in_final)
      )
      and can_traverse(targets2)
      and st.group_offset == 0
   then
      local use_no_labels =
         no_labels_to_use
         or st.repeating_shortcut
         or not targets2.autojump
      -- Note: `traverse` will set `st.curr-idx` to `new-idx`.
      local new_idx = traversal_get_new_idx(st.curr_idx, in_final, targets2)
      do_action(targets2[new_idx])
      traverse(targets2, new_idx, use_no_labels)  -- REDRAW (LOOP)
      return exit()
   end

   -- `next_target` accepts the first match if the cursor hasn't moved yet
   -- (no autojump).
   if
      contains(keys.next_target, in_final)
      and st.curr_idx == 0
      and st.group_offset == 0
   then
      return exit_with_action_on(1)
   end

   -- Otherwise try to get a labeled target, and if no success, feed the key.
   local target, idx = get_target_with_active_label(targets2, in_final)
   if target and idx then
      if is_visual_mode and can_traverse(targets2) then
         do_action(targets2[idx])
         traverse(targets2, idx)  -- REDRAW (LOOP)
         return exit()
      else
         return exit_with_action_on(idx)
      end
   else
      vim.fn.feedkeys(in_final, 'i')
      return exit()
   end
end


-- Init ///1

local function init_highlight()
   hl:init()
   -- Colorscheme plugins might clear out our highlight definitions,
   -- without defining their own, so we re-init the highlight on every
   -- change.
   return api.nvim_create_autocmd('ColorScheme', {
      group = 'LeapDefault',
      -- Wrap it - do _not_ pass on event data as argument.
      callback = function(_) hl:init() end,
   })
end

local function manage_vim_opts()
   local get_opt = api.nvim_get_option_value
   local set_opt = api.nvim_set_option_value
   local saved_vim_opts = {}

   local function set_vim_opts(user_vim_opts)
      saved_vim_opts = {}

      local windows =
         state.args.windows
         or state.args.target_windows  -- deprecated
         or { api.nvim_get_current_win() }

      for opt, val in pairs(user_vim_opts) do  -- e.g.: `wo.scrolloff = 0`
         local scope, name = unpack(vim.split(opt, '.', { plain = true }))
         if scope == 'wo' then
            for _, win in ipairs(windows) do
               local saved_val = get_opt(name, { scope = 'local', win = win })
               saved_vim_opts[{ 'wo', win, name }] = saved_val
               local new_val = val
               if type(val) == 'function' then
                  new_val = val(win)
               end
               set_opt(name, new_val, { scope = 'local', win = win })
            end
         elseif scope == 'bo' then
            for _, win in ipairs(windows) do
               local buf = api.nvim_win_get_buf(win)
               local saved_val = get_opt(name, { buf = buf })
               saved_vim_opts[{ 'bo', buf, name }] = saved_val
               local new_val = val
               if type(val) == 'function' then
                  new_val = val(buf)
               end
               set_opt(name, new_val, { buf = buf })
            end
         elseif scope == 'go' then
            local saved_val = get_opt(name, { scope = 'global' })
            saved_vim_opts[name] = saved_val
            local new_val = val
            if type(val) == 'function' then
               new_val = val()
            end
            set_opt(name, new_val, { scope = 'global' })
         end
      end
   end

   local function restore_vim_opts()
      for key, val in pairs(saved_vim_opts) do
         if type(key) == 'table' then
            if key[1] == 'wo' then
               local _, win, name = unpack(key)
               if api.nvim_win_is_valid(win) then
                  set_opt(name, val, { scope = 'local', win = win })
               end
            elseif key[1] == 'bo' then
               local _, buf, name = unpack(key)
               if api.nvim_buf_is_valid(buf) then
                  set_opt(name, val, { buf = buf })
               end
            end
         else
            set_opt(key, val, { scope = 'global' })
         end
      end
   end

   api.nvim_create_autocmd('User', {
      pattern = 'LeapEnter',
      group = 'LeapDefault',
      callback = function(_) set_vim_opts(opts.vim_opts) end,
   })

   api.nvim_create_autocmd('User', {
      pattern = 'LeapLeave',
      group = 'LeapDefault',
      callback = function(_) restore_vim_opts() end,
   })
end

local function init()
   -- The equivalence class table can be potentially huge - let's do this
   -- here, and not each time `leap` is called, at least for the defaults.
   opts.default.eqv_class_of = to_membership_lookup(opts.default.equivalence_classes)
   api.nvim_create_augroup('LeapDefault', {})
   init_highlight()
   manage_vim_opts()
end

init()


-- Module ///1

return {
    state = state,
    leap = leap
}


-- vim: foldmethod=marker foldmarker=///,//>
