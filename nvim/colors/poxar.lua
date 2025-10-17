if not vim.fn.has("gui_running") and not vim.fn.has("termguicolors") then
  return
end

vim.cmd.highlight('clear')
vim.g.colors_name = 'poxar'

local hi = function(name, val)
  val.force = true
  val.cterm = val.cterm or {}
  vim.api.nvim_set_hl(0, name, val)
end

local fg = {
  std = "#000000",
  dim = "#6a6868",

  red = "#b34444",
  green = "#005f00",
  blue = "#005fd7",
  brown = "#2c2500", -- aka dark yellow
  orange = "#d88b4d",
  purple = "#6d1ab3",
}

local bg = {
  std = "#fdf8f3",

  -- gray variations for windows and bars
  light = "#f1eae5",
  medium = "#ddd3cd",

  red = "#ffdada",
  green = "#f0fff0",
  blue = "#f0f5ff",
  yellow = "#ffdf64",
  orange = "#fff8f0",
  purple = "#faf3ff",

  -- A slightly darker version of purple for MatchParen
  mauve = "#d2adff",
}

---------------------------------------------------------------
--- General
---------------------------------------------------------------

-- custom groups for common presets
hi("Bold", { bold = true })
hi("Dim", { fg = fg.dim })
hi("DimAll", { fg = fg.dim, bold = false, nocombine = true })

hi("Normal", { fg = fg.std, bg = bg.std })
hi("Folded", { link = "Dim" })
hi("Directory", { fg = fg.blue })

hi("Visual", { bg = bg.medium })
hi("VisualNOS", { bg = bg.medium })

hi("Search", { fg = fg.brown, bg = bg.yellow })
hi("CurSearch", { fg = fg.brown, bg = bg.yellow })
hi("IncSearch", { reverse = true })
hi("YankPost", { fg = bg.purple, bg = fg.purple })

hi("MatchParen", { fg = fg.purple, bg = bg.mauve })

hi("NonText", { fg = bg.medium })
hi("SpecialKey", { link = "Dim" })

hi("Conceal", { link = "Dim" })
hi("Tag", { fg = fg.blue })

hi("SpellCap", { undercurl = true, sp = fg.orange })
hi("SpellBad", { undercurl = true, sp = fg.red })
hi("SpellLocal", {})
hi("SpellRare", {})

hi("TrailWhitespace", { fg = fg.red, bg = bg.red })

hi("HighlightBlue", { bg = bg.blue })
hi("HighlightGreen", { bg = bg.green })
hi("HighlightPurple", { bg = bg.purple })

---------------------------------------------------------------
--- UI
---------------------------------------------------------------

hi("Cursor", { reverse = true })
hi("StatusLine", { fg = bg.std, bg = fg.std })
hi("StatusLineNC", { fg = fg.std, bg = bg.medium })
hi("WinBar", { fg = bg.std, bg = fg.std })
hi("WinBarNC", { fg = fg.std, bg = bg.medium })
hi("WildMenu", { fg = fg.light, bg = bg.yellow })
hi("QuickFixLine", { link = "Bold" })

hi("VertSplit", { link = "Dim" })
hi("LineNr", { link = "Dim" })
hi("CursorLineNr", { link = "Dim" })
hi("CursorLine", { bg = bg.light })
hi("CursorColumn", { bg = bg.light })
hi("ColorColumn", { bg = bg.light })

hi("SignColumn", { link = "Dim" })
hi("FoldColumn", { link = "Dim" })

hi("TabLine", {})
hi("TabLineFill", {})
hi("TabLineSel", { reverse = true })

hi("Question", {})
hi("ErrorMsg", { fg = fg.red })
hi("WarningMsg", { fg = fg.orange })

hi("MoreMsg", { link = "Bold" })
hi("ModeMsg", { link = "Bold" })

hi("Pmenu", { fg = fg.std, bg = bg.light })
hi("PmenuSel", { fg = bg.std, bg = fg.std })
hi("PmenuSbar", { bg = bg.light })
hi("PmenuThumb", { bg = fg.std })
hi("NormalFloat", { fg = fg.std, bg = bg.std })

hi("DiagnosticOk", { fg = fg.green })
hi("DiagnosticError", { fg = fg.red, bg = bg.red })
hi("DiagnosticWarn", { fg = fg.orange, bg = bg.orange })
hi("DiagnosticInfo", { link = "Dim" })
hi("DiagnosticHint", { link = "Dim" })

hi("DiagnosticSignOk", { fg = fg.green })
hi("DiagnosticSignError", { fg = fg.red })
hi("DiagnosticSignWarn", { fg = fg.orange })
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

hi("String", { fg = fg.green })
hi("PreProc", { fg = fg.purple })
hi("Number", { fg = fg.blue })

hi("Error", { fg = fg.red, bg = bg.red })
hi("Todo", { fg = fg.std, bold = true })

hi("Operator", {})
hi("Identifier", {})
hi("Constant", {})
hi("Special", {})

hi("Comment", { link = "Dim" })
hi("SpecialComment", { fg = fg.dim, bold = true })

hi("Added", { fg = bg.std, bg = fg.green })
hi("Removed", { fg = bg.std, bg = fg.red })
hi("Changed", { fg = bg.std, bg = fg.orange })
hi("DiffAdd", { fg = bg.std, bg = fg.green })
hi("DiffDelete", { fg = bg.std, bg = fg.red })
hi("DiffChange", { fg = fg.std, bg = bg.light })
hi("DiffText", { fg = fg.brown, bg = fg.orange })

-- Treesitter/LSP adjustments

hi("@attribute.builtin", { link = "PreProc" })

hi("@markup.link", { fg = fg.blue })
hi("@markup.link.label", { fg = fg.blue, bold = true })
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
hi("diffAdded", { fg = fg.green })
hi("diffRemoved", { fg = fg.red })

-- Markdown
hi("markdownUrl", { link = "Dim" })

-- HTML
hi("htmlLink", { fg = fg.blue })

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
hi("LeapLabel", { fg = bg.purple, bg = fg.purple })
hi("LeapMatch", { fg = fg.purple, bg = bg.purple })
hi("LeapBackdrop", { link = "Dim" })

-- CheckHealth
hi("healthSuccess", { fg = fg.green })
hi("healthWarning", { fg = fg.orange })
hi("healthError", { fg = fg.red })
