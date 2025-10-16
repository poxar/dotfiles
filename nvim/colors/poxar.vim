" A simple neovim colorscheme

" Palette {{{
"
" foreground  #000000
" background  #fafafa
"
" light gray  #ededed
" medium gray #d8d3d3
" dark gray   #6a6868
"
" red         #b80000
" green       #005f00
" blue        #005fd7
" orange      #d75f00
" purple      #5f00d7
"
" highlighting
" yellow      #ffdf64
" blue        #99c7ff
"
" }}}

" Preamble {{{

if !has("gui_running") && !has("termguicolors")
  finish
endif

hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "poxar"

" }}}
" General {{{

hi Normal       guifg=#000000 guibg=#fafafa
hi Folded       guifg=#6a6868 guibg=none
hi Comment      guifg=#6a6868 guibg=none
hi Directory    guifg=#005fd7 guibg=none

hi None         guifg=none    guibg=none    gui=none
hi Bold         guifg=none    guibg=none    gui=bold

hi Visual                     guibg=#d8d3d3
hi VisualNOS                  guibg=#d8d3d3
hi Search       guifg=fg      guibg=#ffdf64
hi IncSearch                  guibg=#ffdf64
hi CurSearch    guifg=fg      guibg=#ffdf64
hi MatchParen                 guibg=#ffdf64

hi NonText      guifg=#d8d3d3 guibg=none    gui=none
hi SpecialKey   guifg=#6a6868 guibg=none    gui=none

hi Conceal      guifg=#6a6868
hi Underlined   guifg=none    guibg=none    gui=none
hi Tag          guifg=#005fd7 guibg=none    gui=none

hi SpellCap     gui=undercurl guisp=#d75f00 guifg=#d75f00
hi SpellBad     gui=undercurl guisp=#b80000
hi SpellLocal   gui=undercurl guisp=#005f00
hi SpellRare    gui=undercurl guisp=#5f00d7 guifg=#5f00d7

match TrailWhitespace /\s\+$/
hi TrailWhitespace guifg=bg guibg=#b80000

" }}}
" UI {{{

hi Cursor       gui=reverse
hi StatusLine   guifg=#fafafa guibg=#000000
hi StatusLineNC guifg=fg      guibg=#d8d3d3 gui=none
hi WinBar       guifg=#fafafa guibg=#000000
hi WinBarNC     guifg=fg      guibg=#d8d3d3 gui=none
hi WildMenu                   guibg=#ffdf64
hi QuickFixLine guifg=none guibg=none gui=bold

hi User1        guifg=fg      guibg=bg
hi User2        guifg=bg      guibg=fg
hi User3        guifg=bg      guibg=#d75f00
hi User4        guifg=bg      guibg=#005f00
hi User5        guifg=fg      guibg=#d8d3d3

hi VertSplit    guifg=#6a6868
hi LineNr       guifg=#6a6868
hi CursorLineNr guifg=#6a6868 guibg=#ededed gui=bold
hi CursorLine                 guibg=#ededed
hi CursorColumn               guibg=#ededed
hi ColorColumn                guibg=#ededed

hi SignColumn   guifg=#6a6868 guibg=bg
hi FoldColumn   guifg=#6a6868 guibg=bg

hi TabLine      guifg=fg      guibg=bg      gui=none
hi TabLineFill  guifg=fg      guibg=bg      gui=none
hi TabLineSel   guifg=bg      guibg=fg      gui=none

hi ErrorMsg     guifg=bg      guibg=#b80000 gui=bold
hi WarningMsg   guifg=#b80000 guibg=bg      gui=none

hi MoreMsg      guifg=none    guibg=none    gui=bold
hi ModeMsg      guifg=none    guibg=none    gui=bold
hi Question     guifg=none    guibg=none    gui=none

hi Pmenu        guifg=fg      guibg=#ededed
hi PmenuSel     guifg=bg      guibg=fg
hi PmenuSbar                  guibg=#ededed
hi PmenuThumb                 guibg=#000000
hi NormalFloat  guifg=fg      guibg=bg

hi DiagnosticOk    guifg=#005f00
hi DiagnosticError guifg=#b80000
hi DiagnosticWarn  guifg=#d75f00
hi DiagnosticInfo  guifg=#6a6868
hi DiagnosticHint  guifg=#6a6868

hi DiagnosticFloatingError guifg=#b80000
hi DiagnosticFloatingWarn  guifg=#d75f00
hi DiagnosticFloatingInfo  guifg=fg
hi DiagnosticFloatingHint  guifg=fg

hi DiagnosticUnderlineError gui=underline guisp=#b80000
hi DiagnosticUnderlineWarn gui=underline guisp=#d75f00
hi DiagnosticUnderlineHint gui=underline guisp=#6a6868
hi DiagnosticUnderlineInfo gui=underline guisp=#6a6868
hi DiagnosticUnderlineOk   gui=underline guisp=#6a6868
hi DiagnosticDeprecated    gui=strikethrough guisp=none

" }}}
" Plugins {{{

" Telescope {{{

hi! link TelescopeBorder Comment
hi! link TelescopePromptBorder Comment
hi! link TelescopeResultsBorder Comment
hi! link TelescopePreviewBorder Comment

" }}}
" Leap {{{

hi LeapLabel   guifg=bg      guibg=#5f00d7
hi LeapMatch   guifg=#5f00d7 guibg=bg
hi! link LeapBackdrop Comment

" }}}
" CheckHealth {{{

hi healthSuccess guifg=bg guibg=#005f00
hi healthWarning guifg=#d75f00
hi healthError   guifg=#b80000

" }}}
" Illuminate {{{
hi def IlluminatedWordText guibg=#ededed
hi def IlluminatedWordRead guibg=#ededed
hi def IlluminatedWordWrite guibg=#ededed
" }}}

" }}}
" Syntax {{{

hi Title      guifg=none guibg=none gui=bold
hi Statement  guifg=none guibg=none gui=bold
hi Keyword    guifg=none guibg=none gui=bold
hi Type       guifg=none guibg=none gui=bold
hi Include    guifg=none guibg=none gui=bold
hi Define     guifg=none guibg=none gui=bold
hi Boolean    guifg=none guibg=none gui=bold
hi Debug      guifg=none guibg=none gui=bold
hi Function   guifg=none guibg=none gui=none
hi Delimiter  guifg=none guibg=none gui=none
hi @variable  guifg=none

hi String     guifg=#005f00 guibg=none gui=none
hi Namespace  guifg=#6a6868 guibg=none gui=none
hi PreProc    guifg=#5f00d7 guibg=none gui=none
hi Number     guifg=#005fd7 guibg=none gui=none

hi Error      guifg=bg guibg=#b80000 gui=none

hi Operator   guifg=none guibg=none gui=none
hi Identifier guifg=none guibg=none gui=none
hi Constant   guifg=none guibg=none gui=none
hi Special    guifg=none guibg=none gui=none

hi Todo           guifg=#6a6868 guibg=none    gui=bold
hi SpecialComment guifg=fg      guibg=#99c7ff gui=none

hi Added      guifg=bg   guibg=#005f00 gui=none
hi Removed    guifg=bg   guibg=#b80000 gui=none
hi Changed    guifg=bg   guibg=#d75f00 gui=none
hi DiffAdd    guifg=bg   guibg=#005f00 gui=none
hi DiffDelete guifg=bg   guibg=#b80000 gui=none
hi DiffChange guifg=none guibg=none    gui=none
hi DiffText   guifg=fg   guibg=#d75f00 gui=none

" Treesitter/LSP adjustments

hi! link @comment.documentation SpecialComment
hi! link @string.documentation  SpecialComment
lua << ENDLUA
  for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
    vim.api.nvim_set_hl(0, group, {})
  end
ENDLUA

hi @lsp.mod.deprecated gui=strikethrough
hi @lsp.type.decorator guifg=#5f00d7
hi @lsp.type.macro     guifg=#5f00d7
hi! link @lsp.mod.documentation SpecialComment

hi @markup.link           guifg=#005fd7
hi @markup.link.label     guifg=#005fd7 gui=bold
hi! link @markup.link.url @markup.link
hi @markup.list.checked   gui=strikethrough

" }}}
" Languages {{{

" Vim {{{

hi! link vimGroup None
hi! link vimHiTerm None
hi! link vimOption None
hi! link vimCommentTitle SpecialComment

hi vimNotation gui=bold

" }}}
" Help {{{

hi helpHeader guifg=none guibg=none gui=bold
hi! link helpSectionDelim None

" }}}
" Git {{{

hi diffAdded   guifg=#005f00
hi diffRemoved guifg=#b80000

" }}}
" Markdown {{{

hi mkdHeading guifg=#6a6868 gui=bold
hi mkdUrl guifg=#6a6868

" }}}
" HTML {{{

hi! link htmlArg None
hi! link htmlLink Number

" }}}
" CSS {{{

hi! link cssProp None
hi! link cssImportant Bold

" }}}
" Rust {{{

hi! link rustModPath Namespace
hi! link rustModPathSep Namespace

" }}}
" PHP {{{

hi! link phpComparison None

" }}}
" Lua {{{

hi! link luaFunction Keyword

" }}}

" }}}
