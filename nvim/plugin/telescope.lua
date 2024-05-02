local ts_builtin = require('telescope.builtin')

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

nmap('<leader>ff', ts_builtin.find_files, '[F]ind [F]iles')
nmap('<leader>fb', ts_builtin.buffers, '[F]ind [B]uffers')
nmap('<leader>fB', ts_builtin.git_branches, '[F]ind git [B]ranch')
nmap('<leader>fh', ts_builtin.help_tags, '[F]ind [H]elp')
nmap('<leader>fC', ts_builtin.commands, '[F]ind [C]ommand')
nmap('<leader>fg', ts_builtin.live_grep, '[F]ind with [G]rep')
nmap('<leader>fd', ts_builtin.diagnostics, '[F]ind in [D]iagnostics')
nmap('<leader>fm', ts_builtin.man_pages, '[F]ind [M]anpage')
nmap('<leader>fS', ts_builtin.spell_suggest, '[F]ind [S]pelling')
nmap('<leader>fk', ts_builtin.keymaps, '[F]ind [K]eymappings')
nmap('<leader>ft', ts_builtin.builtin, '[F]ind [T]elescope builtin')
nmap('<leader>fe', ts_builtin.symbols, '[F]ind [E]moji')
nmap('<leader>fr', ts_builtin.registers, '[F]ind [R]egister')

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
nmap('<leader>gf', ts_builtin.git_status, 'find [G]it changed [F]iles')
