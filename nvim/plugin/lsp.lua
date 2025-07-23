local nvim_lsp = require('lspconfig')

require('fidget').setup {
  text = { spinner = 'dots' },
  timer = { spinner_rate = 200 },
  window = { relative = 'editor' },
  fmt = { max_messages = 4 },
}

vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist)

vim.diagnostic.config({
  virtual_lines = true,
  underline = false,
  signs = {
    severity_sort = true,
    text = {
      [vim.diagnostic.severity.ERROR] = '●',
      [vim.diagnostic.severity.WARN] = '●',
      [vim.diagnostic.severity.INFO] = '●',
      [vim.diagnostic.severity.HINT] = '●',
    },
    texthl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
    }
  }
})

local on_attach = function(_, bufnr)
  local function nmap(keys, func)
    vim.keymap.set('n', keys, func, {
      buffer = bufnr,
      noremap = true,
      silent = true
    })
  end

  nmap('gd', require('telescope.builtin').lsp_definitions)
  nmap('gD', vim.lsp.buf.declaration)

  nmap('grr', require('telescope.builtin').lsp_references)
  nmap('gri', require('telescope.builtin').lsp_implementations)
  nmap('grt', require('telescope.builtin').lsp_type_definitions)

  nmap('gO', require('telescope.builtin').lsp_document_symbols)
  nmap('grw', require('telescope.builtin').lsp_dynamic_workspace_symbols)

  nmap('gK', 'K')
end

-- List of available servers
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins
local servers = {}

-- c family
if vim.fn.executable("clangd") == 1 then
  table.insert(servers, "clangd");
end

-- rust
if vim.fn.executable("rust-analyzer") == 1 then
  table.insert(servers, "rust_analyzer");
end

-- lua
if vim.fn.executable("lua-language-server") == 1 then
  table.insert(servers, "lua_ls");
end

-- web technology
if vim.fn.executable("typescript-language-server") == 1 then
  table.insert(servers, "ts_ls");
end
if vim.fn.executable("vscode-eslint-language-server") == 1 then
  table.insert(servers, "eslint");
end
if vim.fn.executable("vscode-css-language-server") == 1 then
  table.insert(servers, "cssls")
end
if vim.fn.executable("vscode-html-language-server") == 1 then
  table.insert(servers, "html")
end
if vim.fn.executable("vscode-json-language-server") == 1 then
  table.insert(servers, "jsonls")
end

-- markdown
if vim.fn.executable("marksman") == 1 then
  table.insert(servers, "marksman");
end

-- yaml
if vim.fn.executable("yaml-language-server") == 1 then
  table.insert(servers, "yamlls")
end

-- python
if vim.fn.executable("ruff-lsp") == 1 then
  table.insert(servers, "ruff");
end

-- sh/bash
if vim.fn.executable("bash-language-server") == 1 then
  table.insert(servers, "bashls");
end

-- slint ui framework
if vim.fn.executable("slint-lsp") == 1 then
  table.insert(servers, "slint_lsp")
end

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    settings = {
      ["rust-analyzer"] = {
        procMacro = { enable = true },
      },
      ["Lua"] = {
        diagnostics = { globals = { 'vim' } }
      },
      ["eslint"] = {
        format = false,
      },
    },
  }
end
