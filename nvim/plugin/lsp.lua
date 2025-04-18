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
  }
})

vim.cmd('sign define DiagnosticSignError text=● texthl=DiagnosticSignError linehl= numhl=')
vim.cmd('sign define DiagnosticSignWarn text=● texthl=DiagnosticSignWarn linehl= numhl=')
vim.cmd('sign define DiagnosticSignInfo text=● texthl=DiagnosticSignInfo linehl= numhl=')
vim.cmd('sign define DiagnosticSignHint text=● texthl=DiagnosticSignHint linehl= numhl=')

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
  nmap('gR', require('telescope.builtin').lsp_references)
  nmap('gI', require('telescope.builtin').lsp_implementations)
  nmap('gT', require('telescope.builtin').lsp_type_definitions)

  nmap('<leader>sd', require('telescope.builtin').lsp_document_symbols)
  nmap('<leader>sw', require('telescope.builtin').lsp_dynamic_workspace_symbols)

  nmap('gr', vim.lsp.buf.rename)
  nmap('ga', vim.lsp.buf.code_action)

  nmap('gK', 'K')
  nmap('<C-k>', vim.lsp.buf.signature_help)
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
        checkOnSave = { command = "clippy" },
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
