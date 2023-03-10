local dap = require('dap')
local widgets = require('dap.ui.widgets')
local telescope = require('telescope')
telescope.load_extension('dap')

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

local function sidebar()
  local my_sidebar = widgets.sidebar(widgets.scopes)
  my_sidebar.toggle()
end

nmap('<leader>db', dap.toggle_breakpoint, 'Toggle [D]ebug [B]reakpoint')
nmap('<leader>dc', dap.continue, '[D]ebug [C]ontinue')
nmap('<leader>ds', dap.step_into, '[D]ebug [S]tep into')
nmap('<leader>do', dap.step_over, '[D]ebug step [O]ver')
nmap('<leader>dO', dap.step_out, '[D]ebug step [O]ut')
nmap('<leader>dl', telescope.extensions.dap.list_breakpoints, '[D]ebug [L]ist breakpoints')
nmap('<leader>di', function() widgets.centered_float(widgets.scopes) end, '[D]ebug [I]nspect Variables/Scopes')
nmap('<leader>dt', sidebar, '[D]ebug [T]oggle sidebar')
