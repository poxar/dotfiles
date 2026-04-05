-- We're exposing some fields from other modules here so that they can
-- be accessed directly as `require('leap').foo`. Using a metatable is a
-- convenient way to avoid requiring the modules ahead of time.

return setmetatable({}, {
   __index = function(_, k)
      if k == 'leap' then
         return require('leap.main').leap
      elseif k == 'opts' then
         return require('leap.opts').default
      elseif k == 'state' then
         return require('leap.main').state
      elseif k == 'init_hl' then
         return function(...) require('leap.highlight'):init(...) end
      -- Deprecated ones.
      elseif k == 'setup' then
         return require('leap.user').setup
      elseif k == 'add_default_mappings' then
         return require('leap.user').add_default_mappings
      elseif k == 'add_repeat_mappings' then
         return require('leap.user').add_repeat_mappings
      elseif k == 'init_highlight' then
         return function(...) return require('leap.highlight'):init(...) end
      end
   end,
})
