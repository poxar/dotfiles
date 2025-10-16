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
    orange = "#d75f00",
    purple = "#5f00d7",
  },

  bg = {
    main = "#fafafa",

    light = "#ededed",
    medium = "#d8d3d3",

    yellow = "#ffdf64",
  },
}

local fg = c.fg.main
local bg = c.bg.main

-- General

-- custom groups for common presets
hi("Bold", { fg = "NONE", bg = "NONE", bold = true })
hi("Dim", { fg = c.fg.dim, bg = "NONE" })
hi("DimAll", { fg = c.fg.dim, bg = "NONE", bold = false, nocombine = true })
hi("DimBold", { fg = c.fg.dim, bg = "NONE", bold = true })

hi("Normal", { fg = fg, bg = bg })
hi("Folded", { link = "Dim" })
hi("Comment", { link = "Dim" })
hi("Directory", { fg = c.fg.blue, bg = "NONE" })

hi("Visual", { bg = c.bg.medium })
hi("VisualNOS", { bg = c.bg.medium })
hi("Search", { fg = fg, bg = c.bg.yellow })
hi("IncSearch", { bg = c.bg.yellow })
hi("CurSearch", { fg = fg, bg = c.bg.yellow })
hi("MatchParen", { bg = c.bg.yellow })

hi("NonText", { fg = c.bg.medium, bg = "NONE" })
hi("SpecialKey", { link = "Dim" })

hi("Conceal", { link = "Dim" })
hi("Tag", { fg = c.fg.blue, bg = "NONE" })

hi("SpellCap", { undercurl = true, sp = c.fg.orange, fg = c.fg.orange })
hi("SpellBad", { undercurl = true, sp = c.fg.red })
hi("SpellLocal", { undercurl = true, sp = c.fg.green })
hi("SpellRare", { undercurl = true, sp = c.fg.purple, fg = c.fg.purple })

hi("TrailWhitespace", { fg = bg, bg = c.fg.red })

-- UI

hi("Cursor", { reverse = true })
hi("StatusLine", { fg = bg, bg = fg })
hi("StatusLineNC", { fg = fg, bg = c.bg.medium })
hi("WinBar", { fg = bg, bg = fg })
hi("WinBarNC", { fg = fg, bg = c.bg.medium })
hi("WildMenu", { bg = c.bg.yellow })
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

hi("ErrorMsg", { fg = bg, bg = c.fg.red, bold = true })
hi("WarningMsg", { fg = c.fg.red, bg = bg })

hi("MoreMsg", { link = "Bold" })
hi("ModeMsg", { link = "Bold" })

hi("Pmenu", { fg = fg, bg = c.bg.light })
hi("PmenuSel", { fg = bg, bg = fg })
hi("PmenuSbar", { bg = c.bg.light })
hi("PmenuThumb", { bg = fg })
hi("NormalFloat", { fg = fg, bg = bg })

hi("DiagnosticOk", { fg = c.fg.green })
hi("DiagnosticError", { fg = c.fg.red })
hi("DiagnosticWarn", { fg = c.fg.orange })
hi("DiagnosticInfo", { link = "Dim" })
hi("DiagnosticHint", { link = "Dim" })

hi("DiagnosticFloatingError", { fg = c.fg.red })
hi("DiagnosticFloatingWarn", { fg = c.fg.orange })
hi("DiagnosticFloatingInfo", { fg = fg })
hi("DiagnosticFloatingHint", { fg = fg })

hi("DiagnosticUnderlineError", { underline = true, sp = c.fg.red })
hi("DiagnosticUnderlineWarn", { underline = true, sp = c.fg.orange })
hi("DiagnosticUnderlineHint", { underline = true, sp = c.fg.dim })
hi("DiagnosticUnderlineInfo", { underline = true, sp = c.fg.dim })
hi("DiagnosticUnderlineOk", { underline = true, sp = c.fg.dim })
hi("DiagnosticDeprecated", { strikethrough = true })

-- Syntax
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
hi("Number", { fg = c.fg.blue, bg = "NONE" })

hi("Error", { fg = bg, bg = c.fg.red })

hi("Operator", {})
hi("Identifier", {})
hi("Constant", {})
hi("Special", {})

hi("Todo", { link = "DimBold" })
hi("SpecialComment", { link = "DimBold" })

hi("Added", { fg = bg, bg = c.fg.green })
hi("Removed", { fg = bg, bg = c.fg.red })
hi("Changed", { fg = bg, bg = c.fg.orange })
hi("DiffAdd", { fg = bg, bg = c.fg.green })
hi("DiffDelete", { fg = bg, bg = c.fg.red })
hi("DiffText", { fg = fg, bg = c.fg.orange })

-- Treesitter/LSP adjustments
hi("@attribute.builtin", { link = "PreProc" })

hi("@tag.builtin", { bold = true })
hi("@markup.link", { fg = c.fg.blue })
hi("@markup.link.label", { fg = c.fg.blue, bold = true })
hi("@markup.link.url", { link = "Dim" })
hi("@markup.list.checked", { strikethrough = true })

-- Deemphasize
hi("@variable.builtin", { link = "DimAll" })
hi("@punctuation.delimiter", { link = "Dim" })
hi("@punctuation.bracket", { link = "Dim" })
hi("@punctuation.special", { link = "Dim" })

-- First disable all LSP groups, then reenable strategically
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end

hi("@lsp.mod.deprecated", { strikethrough = true })
hi("@lsp.type.decorator", { fg = c.fg.purple })
hi("@lsp.type.macro", { fg = c.fg.purple })

hi("@lsp.type.keyword", { link = "Keyword" })
hi("@lsp.type.number", { link = "Number" })
hi("@lsp.type.namespace", { link = "Namespace" })
hi("@lsp.type.string", { link = "String" })
hi("@lsp.mod.documentation", { link = "SpecialComment" })

-- Languages

-- Vim
hi("vimGroup", {})
hi("vimHiTerm", {})
hi("vimOption", {})
hi("vimCommentTitle", { link = "SpecialComment" })
hi("vimNotation", { bold = true })

-- Help
hi("helpHeader", { link = "Bold" })
hi("helpSectionDelim", {})

-- Git
hi("diffAdded", { fg = c.fg.green })
hi("diffRemoved", { fg = c.fg.red })

-- Markdown
hi("mkdHeading", { link = "DimBold" })
hi("mkdUrl", { link = "Dim" })

-- HTML
hi("htmlArg", {})
hi("htmlLink", { link = "Number" })

-- CSS
hi("cssProp", {})
hi("cssImportant", { link = "Bold" })

-- Rust
hi("rustModPath", { link = "Namespace" })
hi("rustModPathSep", { link = "Namespace" })
hi("@module.rust", { link = "Namespace" })

-- PHP
hi("phpComparison", {})

-- Lua
hi("luaFunction", { link = "Keyword" })

-- Plugins

-- Telescope
hi("TelescopeBorder", { link = "Comment" })
hi("TelescopePromptBorder", { link = "Comment" })
hi("TelescopeResultsBorder", { link = "Comment" })
hi("TelescopePreviewBorder", { link = "Comment" })

-- Leap
hi("LeapLabel", { fg = bg, bg = c.fg.purple })
hi("LeapMatch", { fg = c.fg.purple, bg = bg })
hi("LeapBackdrop", { link = "Comment" })

-- CheckHealth
hi("healthSuccess", { fg = bg, bg = c.fg.green })
hi("healthWarning", { fg = c.fg.orange })
hi("healthError", { fg = c.fg.red })

-- Illuminate
hi("IlluminatedWordText", { bg = c.bg.light })
hi("IlluminatedWordRead", { bg = c.bg.light })
hi("IlluminatedWordWrite", { bg = c.bg.light })
