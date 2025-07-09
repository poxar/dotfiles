require('illuminate').configure({
  filetypes_denylist = {
    '',
    'text',
    'markdown',
    'help',
    'dirbuf',
    'dirvish',
    'fugitive',
    'gitcommit',
  }
})
