local hl = require('leap.highlight')
local opts = require('leap.opts')

local api = vim.api

-- "Beacon" is an umbrella term for any kind of visual overlay tied to
-- targets - in practice, either a label character, or a highlighting of
-- the match itself. Technically an [offset extmark-opts] tuple, where
-- the latter is an option table expected by `nvim_buf_set_extmark()`.

local M = {}

local function set_beacon_to_match_hl(target)
   local col = target.pos[2]
   local ch1, ch2 = unpack(target.chars)
   local extmark_opts =
      ch1 == ''  -- on empty lines...
      and { virt_text = { { ' ', hl.group.match } } }  -- ...fill the column
      or { end_col = col + ch1:len() + ch2:len() - 1, hl_group = hl.group.match }
   target.beacon = { 0, extmark_opts }
end

local function set_beacon_to_concealed_label(target)
   local virt_text = target.beacon[2].virt_text
   if virt_text then virt_text[1][1] = opts.concealed_label end
end

local function get_label_offset(target)
   return target.chars[1]:len()
      + (target.is_at_win_edge and 0 or target.chars[2]:len())
end

local function set_beacon_for_labeled(target, group_offset, phase)
   local has_ch2 = target.chars and (target.chars[2] ~= '')
   local pad = (has_ch2 and not phase) and ' ' or ''
   local label = opts.substitute_chars[target.label] or target.label
   local relative_group = target.group - (group_offset or 0)
   -- In unlabeled matches are not highlighted, then "no highlight"
   -- should be the very signal for "no further keystrokes needed", so
   -- in that case it is mandatory to show all labeled positions in some
   -- way. (Note: We're keeping this on even after phase one - sudden
   -- visual changes should be avoided as much as possible.)
   local show_all = phase
   local virt_text =
      relative_group == 1
      and { { label .. pad, hl.group.label } }
      or (relative_group == 2 or show_all and relative_group > 2)
      and { { opts.concealed_label .. pad, hl.group.label_dimmed } }

   if not virt_text then
      target.beacon = nil
   else
      local offset = (target.chars and phase) and get_label_offset(target) or 0
      local extmark_opts = { virt_text = virt_text }
      target.beacon = { offset, extmark_opts }
   end
end

function M.set_beacons(targets, kwargs)
   local group_offset = kwargs.group_offset
   local use_no_labels = kwargs.use_no_labels
   local phase = kwargs.phase

   if use_no_labels then
      -- User-given targets might not have `chars`.
      if targets[1].chars then
         for _, target in ipairs(targets) do
            set_beacon_to_match_hl(target)
         end
      else
         for _, target in ipairs(targets) do
            target.beacon = nil
         end
      end
   else
      for _, target in ipairs(targets) do
         if target.label then
            if phase ~= 1 or target.is_previewable then
               set_beacon_for_labeled(target, group_offset, phase)
            end
         end
      end
   end
end

--- After setting the beacons in a context-unaware manner, the following
--- conflicts can occur:
---
--- (A) Two labels on top of each other (possible at EOL or window edge,
--- where labels need to be shifted left).
--- 
---           x1 lbl |
---        y1 y2 lbl |
---      -------------
---        -3 -2 -1  |
--- 
--- (B) An unlabeled match touches the label of another match (possible
--- if the label is shifted, just like above). This is unacceptable - it
--- looks like the label is for the unlabeled target:
---
---           x1 lbl |
---        y1 y2     |
---      -------------
---        -3 -2 -1  |
--- 
--- (C) An unlabeled match covers a label.
--- 
--- Fix: switch the label(s) to an empty one. This keeps things simple
--- from a UI perspective (no special beacon for marking conflicts). An
--- empty label next to, or on top of an unlabeled match (case B and C)
--- is not ideal, but the important thing is to avoid accidents - typing
--- a label by mistake. A possibly unexpected autojump on these rare
--- occasions is a relatively minor nuisance.
--- Show the empty label even if unlabeled targets are set to be
--- highlighted, and remove the match highlight instead, for a similar
--- reason - to prevent (falsely) expecting an autojump. (In short:
--- always err on the safe side.)
---
function M.resolve_conflicts(targets)
   -- Tables to help us check potential conflicts (we'll be filling them
   -- as we go):
   -- { "<buf> <win> <lnum> <col>" = <target-obj> }
   local unlabeled_match_pos = {}
   local label_pos = {}
   -- We do only one traversal run, and we don't assume anything about
   -- the ordering of the targets; a particular conflict will always be
   -- resolved the second time we encounter the conflicting pair - at
   -- that point, one of them will already have been registered as a
   -- potential source of conflict. That is why we need to check two
   -- separate subcases for both A and B (for C, they are the same).
   for _, target in ipairs(targets) do
      local is_empty_line = (target.chars[1] == '') and (target.pos[2] == 0)
      if not is_empty_line then
         local buf = target.wininfo.bufnr
         local win = target.wininfo.winid
         local lnum = target.pos[1]
         local col_ch1 = target.pos[2]
         local col_ch2 = col_ch1 + (target.chars[1]):len()
         local key_prefix = buf .. ' ' .. win .. ' ' .. lnum .. ' '

         if target.label and target.beacon then
            -- Active label.
            local label_offset = target.beacon[1]
            local col_label = col_ch1 + label_offset
            local label_shifted = col_label == col_ch2
            local other =
               -- label on top of label (A)
               --   [-][a][L]|     | current
               --   [a][a][L]|     | other
               --          ^       | column to check
               --   or
               --   [a][a][L]|
               --   [-][a][L]|
               --          ^
               label_pos[key_prefix .. col_label]
               -- label touches unlabeled (B1)
               --   [-][a][L]|
               --   [a][a][-]|
               --       ^
               or label_shifted and unlabeled_match_pos[key_prefix .. col_ch1]
               -- label covered by unlabeled (C1)
               --   [a][b][L][-]
               --   [-][-][a][c]
               --          ^
               --   or
               --   [a][a][L]
               --   [-][a][b]
               --          ^
               or unlabeled_match_pos[key_prefix .. col_label]
            if other then
               other.beacon = nil
               set_beacon_to_concealed_label(target)
            end
            -- Do this LAST (chasing our own tail is not funny).
            label_pos[key_prefix .. col_label] = target
         else
            -- No label (unlabeled or inactive).
            local col_ch3 = col_ch2 + (target.chars[2]):len()
            local other =
               -- unlabeled covers label (C2)
               --   [-][-][a][b]
               --   [a][c][L][-]
               --          ^
               label_pos[key_prefix .. col_ch1]
               -- unlabeled covers label (C2)
               --   [-][a][b]
               --   [a][a][L]
               --          ^
               or label_pos[key_prefix .. col_ch2]
               -- unlabeled touches label (B2)
               --   [a][a][-]|
               --   [-][a][L]|
               --          ^
               or label_pos[(key_prefix .. col_ch3)]
            if other then
               target.beacon = nil
               set_beacon_to_concealed_label(other)
            end
            unlabeled_match_pos[key_prefix .. col_ch1] = target
            unlabeled_match_pos[key_prefix .. col_ch2] = target
         end
      end
   end
end

do
   local ns = api.nvim_create_namespace('')
   -- Register each newly set extmark in a table, so that we can delete
   -- them one by one, without needing any further contextual
   -- information. This is relevant if we process user-given targets and
   -- have no knowledge about the boundaries of the search area.
   local extmarks = {}

   local function light_up_beacon(target, at_endpos)
      local lnum, col = unpack(at_endpos and target.endpos or target.pos)
      local buf = target.wininfo.bufnr
      local offset, extmark_opts_ = unpack(target.beacon)
      local extmark_opts = vim.tbl_extend('keep', extmark_opts_, {
         virt_text_pos = opts.virt_text_pos or 'overlay',
         hl_mode = 'combine',
         priority = hl.priority.label,
         strict = false,
      })
      local id = api.nvim_buf_set_extmark(
         buf, ns, lnum - 1, col - 1 + offset, extmark_opts
      )
      table.insert(extmarks, { buf, id })
   end

   function M.light_up_beacons(targets, start_idx, end_idx)
      if opts.on_beacons and opts.on_beacons(targets, start_idx, end_idx) == false then
         return
      end

      for i = (start_idx or 1), (end_idx or #targets) do
         local target = targets[i]
         if target.beacon then
            light_up_beacon(target)
            if target.endpos then
               light_up_beacon(target, true)
            end
         end
      end
      -- Set auto-cleanup.
      api.nvim_create_autocmd('User', {
         pattern = { 'LeapRedraw', 'LeapLeave' },
         once = true,
         callback = function()
            for _, t in ipairs(extmarks) do
               local buf, id = unpack(t)
               if api.nvim_buf_is_valid(buf) then
                  api.nvim_buf_del_extmark(buf, ns, id)
               end
            end
            extmarks = {}
         end
      })
   end
end

return M
