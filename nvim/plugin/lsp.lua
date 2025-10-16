require("inc_rename").setup()
require('fidget').setup()

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

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(ev)
    vim.keymap.set("n", "grn", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true, buffer = ev.buf, noremap = true, silent = true })

    local function nmap(keys, func)
      vim.keymap.set('n', keys, func, {
        buffer = ev.buf,
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
})

-- List of available servers
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins

-- c family
if vim.fn.executable("clangd") == 1 then
  vim.lsp.enable("clangd")
end

-- rust
if vim.fn.executable("rust-analyzer") == 1 then
  vim.lsp.config("rust_analyzer", { procMacro = { enable = true }})
  vim.lsp.enable("rust_analyzer")
end

-- lua
if vim.fn.executable("lua-language-server") == 1 then
  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim', 'require' },
        },
      },
    },
  })
  vim.lsp.enable("lua_ls")
end

-- web technology
if vim.fn.executable("typescript-language-server") == 1 then
  vim.lsp.enable("ts_ls");
end
if vim.fn.executable("vscode-eslint-language-server") == 1 then
  vim.lsp.config("eslint", { format = false })
  vim.lsp.enable("eslint");
end
if vim.fn.executable("vscode-css-language-server") == 1 then
  vim.lsp.enable("cssls")
end
if vim.fn.executable("vscode-html-language-server") == 1 then
  vim.lsp.enable("html")
end
if vim.fn.executable("vscode-json-language-server") == 1 then
  vim.lsp.enable("jsonls")
end

-- markdown
if vim.fn.executable("marksman") == 1 then
  vim.lsp.enable("marksman")
end

-- yaml
if vim.fn.executable("yaml-language-server") == 1 then
  vim.lsp.enable("yamlls")
end

-- python
if vim.fn.executable("ruff-lsp") == 1 then
  vim.lsp.enable("ruff")
end

-- sh/bash
if vim.fn.executable("bash-language-server") == 1 then
  vim.lsp.enable("bashls")
end

-- slint ui framework
if vim.fn.executable("slint-lsp") == 1 then
  vim.lsp.enable("slint_lsp")
end
