local ts_builtin = require('telescope.builtin')

vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopeFindPre",
  callback = function()
    vim.opt_local.winborder = "none"
    vim.api.nvim_create_autocmd("WinLeave", {
      once = true,
      callback = function()
        vim.opt_local.winborder = "rounded"
      end,
    })
  end,
})

local function nmap(keys, func, desc)
  if desc then
    desc = 'Telescope: ' .. desc
  end

  vim.keymap.set('n', keys, func, {
    desc = desc,
    noremap = true,
    silent = true
  })
end

nmap('z=', ts_builtin.spell_suggest, 'List spelling suggestions')
nmap('<M-s>', ts_builtin.current_buffer_fuzzy_find, 'Find location in buffer')
nmap('<leader>:', ':Telescope cmdline<cr>', 'Use telescope for the cmdline')
nmap('<leader>;', ':Telescope cmdline<cr>', 'Use telescope for the cmdline')
nmap('<leader>e.', ':Telescope cmdline<cr>edit <c-r>=expand("%:p:h") . "/" <cr>')

nmap('<M-f>', ts_builtin.find_files, 'Find [F]iles')
nmap('<leader>ff', ts_builtin.find_files, '[F]ind [F]iles')
nmap('<M-b>', ts_builtin.buffers, 'Find [B]uffers')
nmap('<leader>fb', ts_builtin.buffers, '[F]ind [B]uffers')
nmap('<leader>fg', ts_builtin.live_grep, '[F]ind with [G]rep')

nmap('<leader>fr', ts_builtin.registers, '[F]ind [R]egister')
nmap('<leader>fe', ts_builtin.symbols, '[F]ind [E]moji')

nmap('<leader>fq', ts_builtin.quickfix, '[F]ind [Q]uickfix')
nmap('<leader>fl', ts_builtin.loclist, '[F]ind from [L]ocationlist')
nmap('<leader>fd', ts_builtin.diagnostics, '[F]ind in [D]iagnostics')

nmap('<leader>ft', ts_builtin.builtin, '[F]ind [T]elescope lenses')
nmap('<leader>fm', ts_builtin.man_pages, '[F]ind [M]an page')

nmap('<leader>fn', function() ts_builtin.find_files { cwd = '$HOME/Notes' } end, '[F]ind [N]otes')
nmap('<leader>gn', function() ts_builtin.live_grep { cwd = '$HOME/Notes' } end, '[G]rep [N]otes')
nmap('<leader>fc', function() ts_builtin.find_files { cwd = '$HOME/.config' } end, '[F]ind [C]onfiguration file')

nmap('<leader>fv', function()
  ts_builtin.git_files {
    cwd = vim.fn.stdpath('config'),
    use_git_root = false,
    show_untracked = true,
  }
end, '[F]ind [V]imfile')

nmap('<leader>fsn', function()
  ts_builtin.find_files { cwd = vim.fn.stdpath('config') .. '/snippets' }
end, '[F]ind [Sn]ippets')

nmap('<leader>gb', ts_builtin.git_branches, 'find [G]it [B]ranches')
nmap('<leader>gh', ts_builtin.git_commits, 'find [G]it [H]istory')
