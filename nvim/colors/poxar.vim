" A simple neovim colorscheme

" Palette {{{
" For now the colors are hardcoded, we could try to use cterm colors instead and match from the
" terminal, but that limits the use of grays and the highlight color too much.
"
" foreground  #000000
" background  #f4e4e1
"
" light gray  #eadbd8
" medium gray #c4b7b5
" dark gray   #726b6a
"
" highlight   #e3bcb5
"
" red         #b80000
" green       #005f00
" blue        #005fd7
"
" orange      #d75f00
" purple      #5f00d7
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

hi Normal       guifg=#000000 guibg=#f4e4e1
hi Folded       guifg=#726b6a guibg=none
hi Comment      guifg=#726b6a guibg=none
hi Directory    guifg=#005fd7 guibg=none

hi None         guifg=none    guibg=none    gui=none
hi Bold         guifg=none    guibg=none    gui=bold

hi Visual                     guibg=#e3bcb5
hi VisualNOS                  guibg=#e3bcb5
hi Search                     guibg=#e3bcb5
hi IncSearch                  guibg=#e3bcb5
hi MatchParen                 guibg=#e3bcb5

hi NonText      guifg=#c4b7b5 guibg=none    gui=none
hi SpecialKey   guifg=#726b6a guibg=none    gui=none

hi Underlined   guifg=none    guibg=none    gui=none
hi Tag          guifg=#005fd7 guibg=none    gui=none

hi SpellCap     gui=underline guisp=#d75f00 guifg=#d75f00
hi SpellBad     gui=underline guisp=#b80000
hi SpellLocal   gui=underline guisp=#005f00
hi SpellRare    gui=underline guisp=#5f00d7 guifg=#5f00d7

" }}}
" UI {{{

hi Cursor       gui=reverse
hi StatusLine   gui=reverse
hi StatusLineNC guifg=fg      guibg=#c4b7b5 gui=none

hi User1        guifg=fg      guibg=bg
hi User2        guifg=fg      guibg=#e3bcb5
hi User3        guifg=bg      guibg=#d75f00
hi User4        guifg=bg      guibg=#005f00
hi User5        guifg=fg      guibg=#c4b7b5

hi VertSplit    guifg=#726b6a
hi LineNr       guifg=#726b6a
hi CursorLineNr guifg=#726b6a guibg=#eadbd8 gui=bold
hi CursorLine                 guibg=#eadbd8
hi CursorColumn               guibg=#eadbd8
hi ColorColumn                guibg=#eadbd8

hi SignColumn   guifg=#726b6a guibg=bg
hi FoldColumn   guifg=#726b6a guibg=bg

hi TabLine      guifg=fg      guibg=bg      gui=none
hi TabLineFill  guifg=fg      guibg=bg      gui=none
hi TabLineSel   guifg=bg      guibg=fg      gui=none

hi ErrorMsg     guifg=bg      guibg=#b80000 gui=bold
hi WarningMsg   guifg=#b80000 guibg=bg      gui=none

hi MoreMsg      guifg=none    guibg=none    gui=bold
hi ModeMsg      guifg=none    guibg=none    gui=bold
hi Question     guifg=none    guibg=none    gui=none

hi Pmenu        guifg=fg      guibg=#eadbd8
hi PmenuSel     guifg=fg      guibg=#e3bcb5
hi PmenuSbar                  guibg=#eadbd8
hi PmenuThumb                 guibg=fg
hi NormalFloat  guifg=fg      guibg=bg

hi DiagnosticError guifg=#b80000
hi DiagnosticWarn  guifg=#d75f00
hi DiagnosticInfo  guifg=#726b6a
hi DiagnosticHint  guifg=#726b6a

hi DiagnosticFloatingError guifg=#b80000
hi DiagnosticFloatingWarn  guifg=#d75f00
hi DiagnosticFloatingInfo  guifg=fg
hi DiagnosticFloatingHint  guifg=fg

hi DiagnosticUnderlineError gui=undercurl guisp=#b80000
hi DiagnosticUnderlineWarn gui=undercurl guisp=#d75f00
hi DiagnosticUnderlineHint gui=undercurl
hi DiagnosticUnderlineInfo gui=undercurl

hi @lsp.mod.deprecated gui=strikethrough

" }}}
" Plugins {{{

" Telescope {{{

hi! link TelescopeBorder Comment
hi! link TelescopePromptBorder Comment
hi! link TelescopeResultsBorder Comment
hi! link TelescopePreviewBorder Comment

" }}}
" Leap {{{

hi LeapLabelPrimary   guifg=fg guibg=#e3bcb5
hi LeapLabelSecondary guifg=fg guibg=#d75f00
hi LeapLabelSelected  guifg=bg guibg=fg

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

hi String     guifg=#005f00 guibg=none gui=none
hi Namespace  guifg=#726b6a guibg=none gui=none
hi PreProc    guifg=#5f00d7 guibg=none gui=none
hi Number     guifg=#005fd7 guibg=none gui=none

hi Error      guifg=bg guibg=#b80000 gui=none

hi Operator   guifg=none guibg=none gui=none
hi Identifier guifg=none guibg=none gui=none
hi Constant   guifg=none guibg=none gui=none
hi Special    guifg=none guibg=none gui=none

hi Todo           guifg=#726b6a guibg=none gui=bold
hi SpecialComment guifg=#726b6a guibg=none gui=bold

hi DiffAdd    guifg=bg   guibg=#005f00 gui=none
hi DiffDelete guifg=bg   guibg=#b80000 gui=none
hi DiffChange guifg=none guibg=none    gui=none
hi DiffText   guifg=fg   guibg=#d75f00 gui=none

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

hi mkdHeading guifg=#726b6a gui=bold
hi mkdUrl guifg=#726b6a

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

" }}}
" PHP {{{

hi! link phpComparison None

" }}}
" Lua {{{

hi! link luaFunction Keyword

" }}}

" }}}
