local plug_mappings = {
   {
      { 'n', 'x', 'o' },
      '<Plug>(leap)',
      function ()
         require('leap').leap {
            windows = { vim.api.nvim_get_current_win() },
            inclusive = true
         }
      end
   },
   {
      { 'n', 'x', 'o' },
      '<Plug>(leap-from-window)',
      function ()
         require('leap').leap {
            windows = require('leap.user').get_enterable_windows()
         }
      end
   },
   {
      { 'n', 'x', 'o' },
      '<Plug>(leap-anywhere)',
      function ()
         require('leap').leap {
            windows = require('leap.user').get_focusable_windows()
         }
      end
   },
   {
      { 'n', 'x', 'o' },
      '<Plug>(leap-forward)',
      function () require('leap').leap { inclusive = true } end
   },
   {
      { 'n', 'x', 'o' },
      '<Plug>(leap-backward)',
      function () require('leap').leap { backward = true } end
   },
   {
      { 'n', 'x', 'o' },
      '<Plug>(leap-forward-till)',
      function () require('leap').leap { offset = -1, inclusive = true } end
   },
   {
      { 'n', 'x', 'o' },
      '<Plug>(leap-backward-till)',
      function () require('leap').leap { backward = true, offset = 1 } end
   },
}

for _, t in ipairs(plug_mappings) do
   local modes, lhs, rhs = unpack(t)
   vim.keymap.set(modes, lhs, rhs, { silent = true })
end
