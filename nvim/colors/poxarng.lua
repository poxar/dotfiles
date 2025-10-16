if not vim.fn.has("gui_running") and not vim.fn.has("termguicolors") then
  return
end

vim.cmd.highlight('clear')
vim.g.colors_name = 'poxarng'

local hi = function(name, val)
  val.force = true
  val.cterm = val.cterm or {}
  vim.api.nvim_set_hl(0, name, val)
end

local c = {
  fg = {
    main = "#000000",
    dim = "#6a6868",

    red = "#b80000",
    green = "#005f00",
    blue = "#005fd7",
    brown = "#2c2500", -- aka dark yellow
    orange = "#d75f00",
    purple = "#5f00d7",
  },

  bg = {
    main = "#fafafa",

    light = "#ededed",
    medium = "#d8d3d3",

    red = "#fff0f0",
    green = "#f0fff0",
    blue = "#f0f5ff",
    yellow = "#ffdf64",
    orange = "#fff8f0",
    purple = "#f8f0ff",

    -- A slightly darker version of purple for MatchParen
    mauve = "#d2adff",
  },
}

local fg = c.fg.main
local bg = c.bg.main

---------------------------------------------------------------
--- General
---------------------------------------------------------------

-- custom groups for common presets
hi("Bold", { fg = "NONE", bg = "NONE", bold = true })
hi("Dim", { fg = c.fg.dim, bg = "NONE" })
hi("DimAll", { fg = c.fg.dim, bg = "NONE", bold = false, nocombine = true })

hi("Normal", { fg = fg, bg = bg })
hi("Folded", { link = "Dim" })
hi("Directory", { fg = c.fg.blue, bg = "NONE" })

hi("Visual", { bg = c.bg.medium })
hi("VisualNOS", { bg = c.bg.medium })

hi("Search", { fg = c.fg.brown, bg = c.bg.yellow })
hi("CurSearch", { fg = c.fg.brown, bg = c.bg.yellow })
hi("IncSearch", { fg = c.bg.yellow, bg = c.fg.brown })

hi("MatchParen", { fg = c.fg.purple, bg = c.bg.mauve })

hi("NonText", { fg = c.bg.medium, bg = "NONE" })
hi("SpecialKey", { link = "Dim" })

hi("Conceal", { link = "Dim" })
hi("Tag", { fg = c.fg.blue, bg = "NONE" })

hi("SpellCap", { undercurl = true, sp = c.fg.orange, fg = c.fg.orange, bg = c.bg.orange })
hi("SpellBad", { undercurl = true, sp = c.fg.red })
hi("SpellLocal", { undercurl = true, sp = c.fg.green })
hi("SpellRare", { undercurl = true, sp = c.fg.purple, fg = c.fg.purple, bg = c.bg.purple })

hi("TrailWhitespace", { fg = c.fg.red, bg = c.bg.red })

---------------------------------------------------------------
--- UI
---------------------------------------------------------------

hi("Cursor", { reverse = true })
hi("StatusLine", { fg = bg, bg = fg })
hi("StatusLineNC", { fg = fg, bg = c.bg.medium })
hi("WinBar", { fg = bg, bg = fg })
hi("WinBarNC", { fg = fg, bg = c.bg.medium })
hi("WildMenu", { fg = c.fg.light, bg = c.bg.yellow })
hi("QuickFixLine", { link = "Bold" })

hi("VertSplit", { link = "Dim" })
hi("LineNr", { link = "Dim" })
hi("CursorLineNr", { link = "Dim" })
hi("CursorLine", { bg = c.bg.light })
hi("CursorColumn", { bg = c.bg.light })
hi("ColorColumn", { bg = c.bg.light })

hi("SignColumn", { link = "Dim" })
hi("FoldColumn", { link = "Dim" })

hi("TabLine", { fg = fg, bg = bg })
hi("TabLineFill", { fg = fg, bg = bg })
hi("TabLineSel", { fg = bg, bg = fg })

hi("ErrorMsg", { fg = c.fg.red, bg = c.bg.red, bold = true })
hi("WarningMsg", { fg = c.fg.red, bg = bg })

hi("MoreMsg", { link = "Bold" })
hi("ModeMsg", { link = "Bold" })

hi("Pmenu", { fg = fg, bg = c.bg.light })
hi("PmenuSel", { fg = bg, bg = fg })
hi("PmenuSbar", { bg = c.bg.light })
hi("PmenuThumb", { bg = fg })
hi("NormalFloat", { fg = fg, bg = bg })

hi("DiagnosticOk", { fg = c.fg.green, bg = c.bg.green })
hi("DiagnosticError", { fg = c.fg.red, bg = c.bg.red })
hi("DiagnosticWarn", { fg = c.fg.orange, bg = c.bg.orange })
hi("DiagnosticInfo", { link = "Dim" })
hi("DiagnosticHint", { link = "Dim" })

hi("DiagnosticSignOk", { fg = c.fg.green })
hi("DiagnosticSignError", { fg = c.fg.red })
hi("DiagnosticSignWarn", { fg = c.fg.orange })
hi("DiagnosticSignInfo", { link = "Dim" })
hi("DiagnosticSignHint", { link = "Dim" })

hi("DiagnosticDeprecated", { strikethrough = true })

---------------------------------------------------------------
--- Syntax
---------------------------------------------------------------

hi("Title", { link = "Bold" })
hi("Statement", { link = "Bold" })
hi("Keyword", { link = "Bold" })
hi("Include", { link = "Bold" })
hi("Define", { link = "Bold" })
hi("Boolean", { link = "Bold" })
hi("Debug", { link = "Bold" })

hi("Type", {})
hi("Function", {})
hi("Delimiter", { link = "Dim" })
hi("Namespace", { link = "DimAll" })

hi("String", { fg = c.fg.green, bg = "NONE" })
hi("PreProc", { fg = c.fg.purple, bg = "NONE" })
hi("Number", { fg = c.fg.blue })

hi("Error", { fg = c.fg.red, bg = c.bg.red })

hi("Operator", {})
hi("Identifier", {})
hi("Constant", {})
hi("Special", {})

hi("Comment", { link = "Dim" })
hi("SpecialComment", { fg = c.fg.dim, bold = true })

hi("Added", { fg = bg, bg = c.fg.green })
hi("Removed", { fg = bg, bg = c.fg.red })
hi("Changed", { fg = bg, bg = c.fg.orange })
hi("DiffAdd", { fg = bg, bg = c.fg.green })
hi("DiffDelete", { fg = bg, bg = c.fg.red })
hi("DiffText", { fg = fg, bg = c.fg.orange })

-- Treesitter/LSP adjustments

hi("@attribute.builtin", { link = "PreProc" })

hi("@markup.link", { fg = c.fg.blue })
hi("@markup.link.label", { fg = c.fg.blue, bold = true })
hi("@markup.link.url", { link = "Dim" })
hi("@markup.list.checked", { strikethrough = true })

-- Deemphasize
hi("@variable.builtin", { link = "DimAll" })
hi("@punctuation.delimiter", { link = "Dim" })
hi("@punctuation.bracket", { link = "Dim" })
hi("@punctuation.special", { link = "Dim" })
hi("@lsp.type.namespace", { link = "Dim" })

---------------------------------------------------------------
--- Languages
---------------------------------------------------------------

-- Vim
hi("vimCommentTitle", { link = "SpecialComment" })

-- Git
hi("diffAdded", { fg = c.fg.green })
hi("diffRemoved", { fg = c.fg.red })

-- Markdown
hi("markdownUrl", { link = "Dim" })

-- HTML
hi("htmlLink", { fg = c.fg.blue })

-- CSS
hi("cssImportant", { link = "Bold" })
hi("cssColor", { link = "Number" })

-- Rust
hi("rustModPath", { link = "Namespace" })
hi("rustModPathSep", { link = "Namespace" })
hi("@module.rust", { link = "Namespace" })

-- Lua
hi("luaFunction", { link = "Keyword" })

---------------------------------------------------------------
--- Plugins
---------------------------------------------------------------

-- Telescope
hi("TelescopeBorder", { link = "Dim" })
hi("TelescopePromptBorder", { link = "Dim" })
hi("TelescopeResultsBorder", { link = "Dim" })
hi("TelescopePreviewBorder", { link = "Dim" })

-- Leap
hi("LeapLabel", { fg = c.bg.purple, bg = c.fg.purple })
hi("LeapMatch", { fg = c.fg.purple, bg = c.bg.purple })
hi("LeapBackdrop", { link = "Dim" })

-- CheckHealth
hi("healthSuccess", { fg = c.fg.green, bg = c.bg.green })
hi("healthWarning", { fg = c.fg.orange, bg = c.bg.orange })
hi("healthError", { fg = c.fg.red, bg = c.bg.red })
