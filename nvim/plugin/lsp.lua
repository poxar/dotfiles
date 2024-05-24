if vim.fn.has("nvim-0.9") == 1 then vim.cmd.packadd("dressing.nvim"); end
local nvim_lsp = require('lspconfig')

require('fidget').setup {
  text = { spinner = 'dots' },
  timer = { spinner_rate = 200 },
  window = { relative = 'editor' },
  fmt = { max_messages = 4 },
}

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>i', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>d', function()
  vim.diagnostic.setloclist()
  vim.cmd("botright lopen")
end)

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    severity_sort = true,
  }
})

local _border = "single"
vim.diagnostic.config { float = { border = _border } }
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, { border = _border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, { border = _border })

vim.cmd('sign define DiagnosticSignError text=● texthl=DiagnosticSignError linehl= numhl=')
vim.cmd('sign define DiagnosticSignWarn text=● texthl=DiagnosticSignWarn linehl= numhl=')
vim.cmd('sign define DiagnosticSignInfo text=● texthl=DiagnosticSignInfo linehl= numhl=')
vim.cmd('sign define DiagnosticSignHint text=● texthl=DiagnosticSignHint linehl= numhl=')

local on_attach = function(_, bufnr)
  local function nmap(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, {
      buffer = bufnr,
      desc = desc,
      noremap = true,
      silent = true
    })
  end

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efintion')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('gT', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  nmap('<leader>sd', require('telescope.builtin').lsp_document_symbols, '[S]ymbols in [D]ocument')
  nmap('<leader>sw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]ymbols in [W]orkspace')

  nmap('cd', vim.lsp.buf.rename, 'Rename symbol')
  nmap('ga', vim.lsp.buf.code_action, 'Run code action')

  nmap('K', vim.lsp.buf.hover, 'Hover documentation')
  nmap('gK', 'K', 'keywordprg documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature documentation')
end

vim.api.nvim_create_user_command('Format', function(_)
  vim.lsp.buf.format()
end, { desc = 'Format current buffer with LSP' })
vim.keymap.set('n', 'f<cr>', vim.lsp.buf.format)

-- Automatically format some filetypes
local group = vim.api.nvim_create_augroup("lsp_autoformat", {})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern  = {
    "*.rs",
    "*.lua",
    "*.py",
    "*.sh",
    "*.bash",
    "*.html",
    "*.js",
    "*.ts",
    "*.css",
  },
  group    = group,
  callback = function() vim.lsp.buf.format() end,
})

-- List of available servers
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
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

-- typescript
if vim.fn.executable("typescript-language-server") == 1 then
  table.insert(servers, "tsserver");
end

-- javascript/typescript
if vim.fn.executable("vscode-eslint-language-server") == 1 then
  table.insert(servers, "eslint");
end

-- markdown
if vim.fn.executable("marksman") == 1 then
  table.insert(servers, "marksman");
end

-- python
if vim.fn.executable("ruff-lsp") == 1 then
  table.insert(servers, "ruff_lsp");
end

-- sh/bash
if vim.fn.executable("bash-language-server") == 1 then
  table.insert(servers, "bashls");
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

local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.alex,        -- rude wording
    null_ls.builtins.diagnostics.fish,
    null_ls.builtins.diagnostics.vint,        -- vimL
    null_ls.builtins.formatting.prettier,     -- html/css/js/ts
    null_ls.builtins.formatting.shfmt,        -- sh/bash
  }
})
