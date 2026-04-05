local opts = require('leap.opts')

local api = vim.api

local M = {
   group = {
      label = 'LeapLabel',
      label_dimmed = 'LeapLabelDimmed',
      match = 'LeapMatch'
   },
   priority = {
      label = 65535
   }
}

local custom_def_maps = {
   label_light = {
      fg = 'NvimDarkGrey2',
      bg = '#ffaf3f',
      nocombine = true,
      ctermfg = 'red'
   },
   match_light = {
      fg = 'NvimDarkGrey1',
      bg = 'NvimLightYellow',
      ctermfg = 'black',
      ctermbg = 'red'
   },
   label_dark = {
      fg = 'black',
      bg = '#ccff88',
      nocombine = true,
      ctermfg = 'black',
      ctermbg = 'red'
   },
   match_dark = {
      fg = '#ccff88',
      underline = true,
      nocombine = true,
      ctermfg = 'red'
   },
}

local function get_hl(name)
   return api.nvim_get_hl(0, { name = name, link = false })
end

local function to_rgb(n)
   local r = math.floor((n / 65536))
   local g = math.floor(((n / 256) % 256))
   local b = (n % 256)
   return r, g, b
end

local function blend(color1, color2, weight)
   local r1, g1, b1 = to_rgb(color1)
   local r2, g2, b2 = to_rgb(color2)
   local r = (r1 * (1 - weight)) + (r2 * weight)
   local g = (g1 * (1 - weight)) + (g2 * weight)
   local b = (b1 * (1 - weight)) + (b2 * weight)
   return string.format('#%02x%02x%02x', r, g, b)
end

local function dimmed(def_map_)
   local def_map = vim.deepcopy(def_map_)
   local normal = get_hl('Normal')
   -- `bg` can be nil (transparent background), and e.g. the old default
   -- color scheme (`vim`) does not define Normal at all.
   -- Also, `nvim_get_hl()` apparently does not guarantee to return
   -- numeric values in the table (#260).
   if type(normal.bg) == 'number' then
      if type(def_map.bg) == 'number' then
         def_map.bg = blend(def_map.bg, normal.bg, 0.7)
      end
      if type(def_map.fg) == 'number' then
         def_map.fg = blend(def_map.fg, normal.bg, 0.5)
      end
   end
   return def_map
end

local function set_label_dimmed()
   local label = get_hl(M.group.label)
   local label_dimmed = dimmed(label)
   api.nvim_set_hl(0, M.group.label_dimmed, label_dimmed)
end

local function set_concealed_label_char()
   local label = get_hl(M.group.label)
   local middle_dot = '\194\183'
   -- Undocumented option, might be exposed in the future.
   opts.concealed_label = label.bg and ' ' or middle_dot
end

---@param force? boolean
function M.init(self, force)
   local defaults = {}
   -- vscode-neovim has a problem with linking to built-in groups.
   local use_custom_defaults = (vim.g.colors_name == 'default') or vim.g.vscode

   if use_custom_defaults then
      defaults[self.group.label] =
         custom_def_maps[vim.o.bg == 'light' and 'label_light' or 'label_dark']
      defaults[self.group.match] =
         custom_def_maps[vim.o.bg == 'light' and 'match_light' or 'match_dark']
   else
      local search_hl = get_hl('Search')

      defaults[self.group.label] =
         not vim.deep_equal(search_hl, get_hl('IncSearch'))
         and { link = 'IncSearch' }
         or not vim.deep_equal(search_hl, get_hl('CurSearch'))
         and { link = 'CurSearch' }
         or not vim.deep_equal(search_hl, get_hl('Substitute'))
         and { link = 'Substitue' }
         or custom_def_maps[vim.o.bg == 'light' and 'label_light' or 'label_dark']

      defaults[self.group.match] = { link = 'Search' }
   end

   -- Deepcopy, in case using `custom_def_maps`.
   for group, def_map in pairs(vim.deepcopy(defaults)) do
      if not force then
         def_map.default = true  -- :h hi-default
      end
      api.nvim_set_hl(0, group, def_map)
   end
   -- These should be done last, based on the actual group definitions.
   set_label_dimmed()
   set_concealed_label_char()

   -- Handle `LeapBackdrop` (deprecated).
   if not vim.tbl_isempty(get_hl('LeapBackdrop')) then
      if force then
         api.nvim_set_hl(0, 'LeapBackdrop', { link = 'None' })
      else
         require('leap.user').set_backdrop_highlight('LeapBackdrop')
      end
   end
end

return M
