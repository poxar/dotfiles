local M = {
   default = {
      preview = true,
      equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' },
      safe_labels = 'sfnut/SFNLHMUGTZ?',
      labels = 'sfnjklhodweimbuyvrgtaqpcxz/SFNJKLHODWEIMBUYVRGTAQPCXZ?',
      keys = {
         next_target = '<enter>',
         prev_target = '<backspace>',
         next_group = '<space>',
         prev_group = '<backspace>'
      },
      vim_opts = {
         ['wo.scrolloff'] = 0,  -- keep the view when auto-jumping
         ['wo.sidescrolloff'] = 0,
         ['wo.conceallevel'] = 0,
         ['bo.modeline'] = false  -- see lightspeed#81
      },
      -- Deprecated options.
      max_highlighted_traversal_targets = 10,
      substitute_chars = {},
   },
   -- Will be updated by `leap()` on invocation.
   current_call = {},
}

-- `default` might be accessed directly (see `init.lua`), need to handle
-- the deprecated name here too.
setmetatable(M.default, {
   __index = function(self, key_)
      return self[key_ == 'special_keys' and 'keys' or key_]
   end,
})

setmetatable(M, {
   __index = function(self, key_)
      -- Handle deprecated name.
      local key = key_ == 'special_keys' and 'keys' or key_

      -- Try to look up everything in the `current_call` table first,
      -- so that we can override settings on a per-call basis.
      local cc = self.current_call[key]
      if cc == nil then  -- `false` should be returned too
         return rawget(self.default, key)
      else
         local first_access_to_dict =
            type(cc) == 'table'
            and not vim.isarray(cc)
            and (getmetatable(cc) and getmetatable(cc).merge or nil) ~= false
         if first_access_to_dict then
            -- On the first access, we automatically merge map-like
            -- subtables with their defaults. This way users can set the
            -- relevant values only, without having to deepcopy the
            -- whole default subtable, and then modify it.
            for k, v in pairs(self.default[key]) do
               if cc[k] == nil then cc[k] = v end
            end
            -- Using a metatable field as a convenient flag to skip
            -- merging on subsequent access. It can also be used by
            -- users to prevent merging in the first place.
            return setmetatable(cc, { merge = false })
         else
            return cc
         end
      end
   end,
})

return M
