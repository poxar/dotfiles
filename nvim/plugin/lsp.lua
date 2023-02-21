local nvim_lsp = require('lspconfig')
require('neodev').setup()

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>i', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>L', vim.diagnostic.setloclist)

vim.diagnostic.config({
    underline = false,
    virtual_text = {
      prefix = "● ",
    },
})

vim.cmd('sign define DiagnosticSignError text=x texthl=DiagnosticSignError linehl= numhl=')
vim.cmd('sign define DiagnosticSignWarn text=! texthl=DiagnosticSignWarn linehl= numhl=')
vim.cmd('sign define DiagnosticSignInfo text=i texthl=DiagnosticSignInfo linehl= numhl=')
vim.cmd('sign define DiagnosticSignHint text=→ texthl=DiagnosticSignHint linehl= numhl=')

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

-- List of available servers
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins
local servers = {
  "bashls", -- pacman -S bash-language-server
  "clangd", -- pacman -S clang
  "elmls", -- https://aur.archlinux.org/elm-language-server.git
  "rust_analyzer", -- pacman -S rust-analyzer
  "sumneko_lua", -- pacman -S lua-language-server
  "tsserver", -- pacman -S typescript-language-server
  "vimls", -- https://aur.archlinux.org/vim-language-server.git
  -- php
  "phpactor",
  "psalm",
  -- python
  -- pacman -S --needed ruff-lsp python-lsp-server python-lsp-black
  -- pacman -S --needed --asdeps python-pydocstyle python-rope flake8
  "ruff_lsp",
  "pylsp",
}

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
