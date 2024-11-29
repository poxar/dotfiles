local cmp = require('cmp')
local snippy = require('snippy')
local autopairs = require('nvim-autopairs.completion.cmp')
local lspkind = require('lspkind')

cmp.setup({
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      maxwidth = {
        menu = 50,
        abbr = 50,
      },
      ellipsis_char = '…'
    }),
  },
  snippet = {
    expand = function(args)
      require('snippy').expand_snippet(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-y>'] = cmp.mapping.confirm(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-n>'] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
    }),
    ['<C-p>'] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
    }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'snippy' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'crates' },
    { name = 'path' },
  }),
})

-- Insert ( after select function or method item
cmp.event:on('confirm_done', autopairs.on_confirm_done())

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

snippy.setup({
  mappings = {
    is = {
      ['<C-y>'] = 'expand_or_advance',
      ['<C-h>'] = 'previous',
    },
    nx = {
      ['<C-s>'] = 'cut_text',
    },
  },
})
