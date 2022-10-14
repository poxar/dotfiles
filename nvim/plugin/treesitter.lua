local status, ts = pcall(require, 'nvim-treesitter.configs')

if (status) then
  ts.setup {
    ensure_installed = "all",
    context_commentstring = { enable = true }
  }
end
