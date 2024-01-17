if vim.fn.has("nvim-0.9") == 1 then vim.cmd.packadd("dressing.nvim"); end
local nvim_lsp = require('lspconfig')
require('neodev').setup()

require('fidget').setup {
  text = { spinner = 'dots' },
  timer = { spinner_rate = 200 },
  window = { relative = 'editor' },
  fmt = { max_messages = 4 },
}

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>i', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>l', function()
  vim.diagnostic.setloclist()
  vim.cmd("lopen")
end)

vim.diagnostic.config({
    virtual_text = false,
    signs = {
      severity_sort = true,
    }
})

local _border = "single"
vim.diagnostic.config { float= { border = _border } }
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, { border = _border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, { border = _border})

vim.cmd('sign define DiagnosticSignError text=● texthl=DiagnosticSignError linehl= numhl=')
vim.cmd('sign define DiagnosticSignWarn text=● texthl=DiagnosticSignWarn linehl= numhl=')
vim.cmd('sign define DiagnosticSignInfo text=● texthl=DiagnosticSignInfo linehl= numhl=')
vim.cmd('sign define DiagnosticSignHint text=● texthl=DiagnosticSignHint linehl= numhl=')

local on_attach = function(client, bufnr)
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

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('ga', vim.lsp.buf.code_action, 'Code [A]ction')

  nmap('K', vim.lsp.buf.hover, 'Hover documentation')
  nmap('gK', 'K', 'keywordprg documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature documentation')

  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Automatically format some filetypes
local group = vim.api.nvim_create_augroup("lsp_autoformat", {})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern  = { "*.rs", "*.lua", "*.py" },
  group    = group,
  callback = function() vim.lsp.buf.format() end,
})

-- List of available servers
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins
local servers = {}

if vim.fn.executable("clangd") == 1 then
  -- pacman -S clang
  table.insert(servers, "clangd");
end

if vim.fn.executable("rust-analyzer") == 1 then
  -- pacman -S rust-analyzer
  table.insert(servers, "rust_analyzer");
end

if vim.fn.executable("lua-language-server") == 1 then
  -- pacman -S lua-language-server
  table.insert(servers, "lua_ls");
end

if vim.fn.executable("tsserver") == 1 then
  -- pacman -S typescript-language-server
  table.insert(servers, "tsserver");
end

if vim.fn.executable("marksman") == 1 then
  -- pacman -S marksman
  table.insert(servers, "marksman");
end

if vim.fn.executable("ruff-lsp") == 1 then
  -- pacman -S --needed ruff-lsp
  table.insert(servers, "ruff_lsp");
end

if vim.fn.executable("pylsp") == 1 then
  -- pacman -S --needed python-lsp-server python-lsp-black
  -- pacman -S --needed --asdeps python-pydocstyle python-rope flake8
  table.insert(servers, "pylsp");
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
    },
  }
end
