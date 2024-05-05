local true_zen = require('true-zen')
true_zen.setup {
  integrations = {
    tmux = true,
  }
}

vim.keymap.set('n', '<leader>z', true_zen.ataraxis, { noremap = true })
vim.keymap.set('v', '<leader>z', function()
  local first = vim.fn.line('v')
  local last = vim.fn.line('.')
  true_zen.narrow(first, last)
end, { noremap = true })
