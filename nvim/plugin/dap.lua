local dap = require('dap')
local widgets = require('dap.ui.widgets')
local telescope = require('telescope')
telescope.load_extension('dap')

local function nmap(keys, func, desc)
  if desc then
    desc = 'DAP: ' .. desc
  end

  vim.keymap.set('n', keys, func, {
    desc = desc,
    noremap = true,
    silent = true
  })
end

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { '/usr/lib/node_modules/php-debug/out/phpDebug.js' }
}

dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = 9003
  }
}

local function sidebar()
  local my_sidebar = widgets.sidebar(widgets.scopes)
  my_sidebar.open()
end

nmap('<leader>db', dap.toggle_breakpoint, 'Toggle [D]ebug [B]reakpoint')
nmap('<leader>dc', dap.continue, '[D]ebug [C]ontinue')
nmap('<leader>ds', dap.step_into, '[D]ebug [S]tep into')
nmap('<leader>do', dap.step_over, '[D]ebug [S]tep over')
nmap('<leader>dx', dap.step_out, '[D]ebug [S]tep out')
nmap('<leader>dl', telescope.extensions.dap.list_breakpoints, '[D]ebug [L]ist breakpoints')
nmap('<leader>di', function() widgets.centered_float(widgets.scopes) end, '[D]ebug [I]nspect Variables/Scopes')
nmap('<leader>dt', function() widgets.sidebar(widgets.expression).open() end, '[D]ebug [T]oggle sidebar')
