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

local col = {
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

-- General

hi("Normal", { fg = col.fg.main, bg = col.bg.main })
hi("Folded", { fg = col.fg.dim, bg = "NONE" })
hi("Comment", { fg = col.fg.dim, bg = "NONE" })
hi("Directory", { fg = col.fg.blue, bg = "NONE" })

hi("Bold", { fg = "NONE", bg = "NONE", bold = true })

hi("Visual", { bg = col.bg.medium })
hi("VisualNOS", { bg = col.bg.medium })
hi("Search", { fg = col.fg.main, bg = col.bg.yellow })
hi("IncSearch", { bg = col.bg.yellow })
hi("CurSearch", { fg = col.fg.main, bg = col.bg.yellow })
hi("MatchParen", { bg = col.bg.yellow })

hi("NonText", { fg = col.bg.medium, bg = "NONE" })
hi("SpecialKey", { fg = col.fg.dim, bg = "NONE" })

hi("Conceal", { fg = col.fg.dim })
hi("Tag", { fg = col.fg.blue, bg = "NONE" })

hi("SpellCap", { undercurl = true, sp = col.fg.orange, fg = col.fg.orange })
hi("SpellBad", { undercurl = true, sp = col.fg.red })
hi("SpellLocal", { undercurl = true, sp = col.fg.green })
hi("SpellRare", { undercurl = true, sp = col.fg.purple, fg = col.fg.purple })

hi("TrailWhitespace", { fg = col.bg.main, bg = col.fg.red })

-- UI

hi("Cursor", { reverse = true })
hi("StatusLine", { fg = col.bg.main, bg = col.fg.main })
hi("StatusLineNC", { fg = col.fg.main, bg = col.bg.medium })
hi("WinBar", { fg = col.bg.main, bg = col.fg.main })
hi("WinBarNC", { fg = col.fg.main, bg = col.bg.medium })
hi("WildMenu", { bg = col.bg.yellow })
hi("QuickFixLine", { link = "Bold" })

hi("VertSplit", { fg = col.fg.dim })
hi("LineNr", { fg = col.fg.dim })
hi("CursorLineNr", { fg = col.fg.dim, bg = col.bg.light, bold = true })
hi("CursorLine", { bg = col.bg.light })
hi("CursorColumn", { bg = col.bg.light })
hi("ColorColumn", { bg = col.bg.light })

hi("SignColumn", { fg = col.fg.dim, bg = col.bg.main })
hi("FoldColumn", { fg = col.fg.dim, bg = col.bg.main })

hi("TabLine", { fg = col.fg.main, bg = col.bg.main })
hi("TabLineFill", { fg = col.fg.main, bg = col.bg.main })
hi("TabLineSel", { fg = col.bg.main, bg = col.fg.main })

hi("ErrorMsg", { fg = col.bg.main, bg = col.fg.red, bold = true })
hi("WarningMsg", { fg = col.fg.red, bg = col.bg.main })

hi("MoreMsg", { link = "Bold" })
hi("ModeMsg", { link = "Bold" })

hi("Pmenu", { fg = col.fg.main, bg = col.bg.light })
hi("PmenuSel", { fg = col.bg.main, bg = col.fg.main })
hi("PmenuSbar", { bg = col.bg.light })
hi("PmenuThumb", { bg = col.fg.main })
hi("NormalFloat", { fg = col.fg.main, bg = col.bg.main })

hi("DiagnosticOk", { fg = col.fg.green })
hi("DiagnosticError", { fg = col.fg.red })
hi("DiagnosticWarn", { fg = col.fg.orange })
hi("DiagnosticInfo", { fg = col.fg.dim })
hi("DiagnosticHint", { fg = col.fg.dim })

hi("DiagnosticFloatingError", { fg = col.fg.red })
hi("DiagnosticFloatingWarn", { fg = col.fg.orange })
hi("DiagnosticFloatingInfo", { fg = col.fg.main })
hi("DiagnosticFloatingHint", { fg = col.fg.main })

hi("DiagnosticUnderlineError", { underline = true, sp = col.fg.red })
hi("DiagnosticUnderlineWarn", { underline = true, sp = col.fg.orange })
hi("DiagnosticUnderlineHint", { underline = true, sp = col.fg.dim })
hi("DiagnosticUnderlineInfo", { underline = true, sp = col.fg.dim })
hi("DiagnosticUnderlineOk", { underline = true, sp = col.fg.dim })
hi("DiagnosticDeprecated", { strikethrough = true })

-- Syntax

hi("Title", { link = "Bold" })
hi("Statement", { link = "Bold" })
hi("Keyword", { link = "Bold" })
hi("Type", { link = "Bold" })
hi("Include", { link = "Bold" })
hi("Define", { link = "Bold" })
hi("Boolean", { link = "Bold" })
hi("Debug", { link = "Bold" })

hi("Function", {})
hi("Delimiter", {})

hi("String", { fg = col.fg.green, bg = "NONE" })
hi("Namespace", { fg = col.fg.dim, bg = "NONE" })
hi("PreProc", { fg = col.fg.purple, bg = "NONE" })
hi("Number", { fg = col.fg.blue, bg = "NONE" })

hi("Error", { fg = col.bg.main, bg = col.fg.red })

hi("Operator", {})
hi("Identifier", {})
hi("Constant", {})
hi("Special", {})

hi("Todo", { fg = col.fg.dim, bg = "NONE", bold = true })
hi("SpecialComment", { fg = col.fg.dim, bg = "NONE", bold = true })

hi("Added", { fg = col.bg.main, bg = col.fg.green })
hi("Removed", { fg = col.bg.main, bg = col.fg.red })
hi("Changed", { fg = col.bg.main, bg = col.fg.orange })
hi("DiffAdd", { fg = col.bg.main, bg = col.fg.green })
hi("DiffDelete", { fg = col.bg.main, bg = col.fg.red })
hi("DiffText", { fg = col.fg.main, bg = col.fg.orange })

-- Treesitter/LSP adjustments
hi("@type.builtin", { link = "Type" })
hi("@attribute.builtin", { link = "PreProc" })
hi("@variable", {})

-- Deemphasize common things
hi("@variable.builtin", { fg = col.fg.dim })
hi("@punctuation.delimiter", { fg = col.fg.dim })
hi("@punctuation.bracket", { fg = col.fg.dim })
hi("@punctuation.special", { fg = col.fg.purple })

hi("@tag.builtin", { bold = true })
hi("@markup.link", { fg = col.fg.blue })
hi("@markup.link.label", { fg = col.fg.blue, bold = true })
hi("@markup.link.url", { link = "@markup.link" })
hi("@markup.list.checked", { strikethrough = true })

-- First disable all LSP groups, then reenable strategically
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end

hi("@lsp.mod.deprecated", { strikethrough = true })
hi("@lsp.type.decorator", { fg = col.fg.purple })
hi("@lsp.type.macro", { fg = col.fg.purple })

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
hi("diffAdded", { fg = col.fg.green })
hi("diffRemoved", { fg = col.fg.red })

-- Markdown
hi("mkdHeading", { fg = col.fg.dim, bold = true })
hi("mkdUrl", { fg = col.fg.dim })

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
hi("LeapLabel", { fg = col.bg.main, bg = col.fg.purple })
hi("LeapMatch", { fg = col.fg.purple, bg = col.bg.main })
hi("LeapBackdrop", { link = "Comment" })

-- CheckHealth
hi("healthSuccess", { fg = col.bg.main, bg = col.fg.green })
hi("healthWarning", { fg = col.fg.orange })
hi("healthError", { fg = col.fg.red })

-- Illuminate
hi("IlluminatedWordText", { bg = col.bg.light })
hi("IlluminatedWordRead", { bg = col.bg.light })
hi("IlluminatedWordWrite", { bg = col.bg.light })
