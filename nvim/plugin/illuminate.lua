require('illuminate').configure({
  filetypes_denylist = {
    '',
    'text',
    'markdown',
    'dirbuf',
    'dirvish',
    'fugitive',
    'gitcommit',
  }
})
