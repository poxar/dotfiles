require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "c",
    "css",
    "html",
    "htmldjango",
    "javascript",
    "lua",
    "query",
    "rust",
    "typescript",
    "vim",
  },
  sync_install = false,
  auto_install = true,
  ignore_install = {},
  modules = {},
}
