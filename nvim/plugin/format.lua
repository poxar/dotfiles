local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    json = { "jq" },
    lua = { "stylua" },
    rust = { "rustfmt" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    markdown = { "prettier" },
    fish = { "fish_indent" },
    elm = { "elm_format" },
    xml = { "xmllint" },
    yaml = { "yq" },
  },
  default_format_opts = {
    -- Always run the lsp formatter as fallback
    lsp_format = "fallback",
  },
})

vim.keymap.set('n', '<leader>p', conform.format)

vim.api.nvim_create_user_command('Format', function(_)
  conform.format()
end, { desc = 'Format current buffer' })

vim.api.nvim_create_user_command('PP', function(_)
  conform.format()
end, { desc = 'Pretty-print current buffer' })
