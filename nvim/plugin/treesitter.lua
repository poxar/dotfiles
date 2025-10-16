local ts = require('nvim-treesitter')

local languages = { 'rust', 'python' }

if vim.fn.executable("tree-sitter") == 1 then
  ts.install(languages)

  vim.api.nvim_create_autocmd('FileType', {
    pattern = languages,
    callback = function() vim.treesitter.start() end,
  })
end
