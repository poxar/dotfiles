local function map(mode, keys, func, desc)
  if desc then
    desc = 'Crates: ' .. desc
  end

  vim.keymap.set(mode, keys, func, {
    desc = desc,
    noremap = true,
    silent = true,
    buffer = true,
  })
end

vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("cargo_plugin", { clear = true }),
    pattern = "Cargo.toml",
    callback = function()
      local crates = require('crates')
      crates.setup({
        popup = {
          autofocus = true,
          border = "single",
          text = {
            pill_left = "",
            pill_right = "",
          }
        }
      })
      require('cmp').setup.buffer({ sources = { { name = "crates" } } })

      map('n', '<leader>cu', crates.upgrade_crate, 'Upgrade crate under cursor to latest version')
      map('v', '<leader>cu', crates.upgrade_crates, 'Upgrade selected crates to latest version')

      map('n', '<leader>ct', crates.toggle, 'Toggle inline crate information')
      map('n', '<leader>ci', crates.show_popup, 'Show basic information on crate under cursor')
      map('n', 'K', crates.show_popup, 'Show basic information on crate under cursor')
      map('n', '<leader>cf', crates.show_features_popup, 'Select features of crate under cursor')
      map('n', '<leader>cd', crates.show_dependencies_popup, 'Show dependencies of crate under cursor')
    end,
})
