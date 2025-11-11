-- VSCode Dark+ theme
vim.cmd([[
  syntax reset
  set background=dark

  highlight Normal guifg=#d4d4d4 guibg=#1e1e1e ctermfg=188 ctermbg=234
  highlight NormalFloat guifg=#d4d4d4 guibg=#252526 ctermfg=188 ctermbg=235

  highlight LineNr guifg=#858585 guibg=#1e1e1e ctermfg=102 ctermbg=234
  highlight CursorLineNr guifg=#c6c6c6 guibg=#1e1e1e gui=bold ctermfg=251 ctermbg=234 cterm=bold

  highlight CursorLine guibg=#2a2a2a ctermbg=235
  highlight CursorColumn guibg=#2a2a2a ctermbg=235

  highlight Comment guifg=#6a9955 gui=italic ctermfg=65 cterm=italic

  highlight Statement guifg=#c586c0 gui=bold ctermfg=175 cterm=bold
  highlight Keyword guifg=#c586c0 gui=bold ctermfg=175 cterm=bold
  highlight Conditional guifg=#c586c0 ctermfg=175
  highlight Repeat guifg=#c586c0 ctermfg=175

  highlight Function guifg=#dcdcaa ctermfg=187

  highlight Type guifg=#4ec9b0 gui=bold ctermfg=79 cterm=bold
  highlight StorageClass guifg=#569cd6 ctermfg=74

  highlight Identifier guifg=#9cdcfe ctermfg=117
  highlight Constant guifg=#4fc1ff ctermfg=81

  highlight String guifg=#ce9178 ctermfg=174
  highlight Character guifg=#ce9178 ctermfg=174

  highlight Number guifg=#b5cea8 ctermfg=150
  highlight Boolean guifg=#569cd6 ctermfg=74
  highlight Float guifg=#b5cea8 ctermfg=150

  highlight Operator guifg=#d4d4d4 ctermfg=188
  highlight Delimiter guifg=#808080 ctermfg=244

  highlight Special guifg=#d7ba7d ctermfg=180
  highlight SpecialChar guifg=#d7ba7d ctermfg=180

  highlight PreProc guifg=#c586c0 ctermfg=175
  highlight Include guifg=#c586c0 ctermfg=175
  highlight Define guifg=#c586c0 ctermfg=175

  highlight StatusLine guifg=#ffffff guibg=#007acc gui=bold ctermfg=15 ctermbg=31 cterm=bold
  highlight StatusLineNC guifg=#858585 guibg=#2d2d30 ctermfg=102 ctermbg=236
  highlight VertSplit guifg=#444444 guibg=#1e1e1e ctermfg=238 ctermbg=234
  highlight SignColumn guifg=#858585 guibg=#1e1e1e ctermfg=102 ctermbg=234

  highlight TabLine guifg=#858585 guibg=#2d2d30 ctermfg=102 ctermbg=236
  highlight TabLineFill guibg=#2d2d30 ctermbg=236
  highlight TabLineSel guifg=#ffffff guibg=#1e1e1e gui=bold ctermfg=15 ctermbg=234 cterm=bold

  highlight Search guifg=#000000 guibg=#4fc1ff gui=bold ctermfg=0 ctermbg=81 cterm=bold
  highlight IncSearch guifg=#000000 guibg=#007acc gui=bold ctermfg=0 ctermbg=31 cterm=bold
  highlight CurSearch guifg=#000000 guibg=#ff9900 gui=bold ctermfg=0 ctermbg=208 cterm=bold

  highlight Visual guifg=#ffffff guibg=#264f78 ctermfg=15 ctermbg=24

  highlight Pmenu guifg=#cccccc guibg=#252526 ctermfg=252 ctermbg=235
  highlight PmenuSel guifg=#ffffff guibg=#094771 gui=bold ctermfg=15 ctermbg=24 cterm=bold
  highlight PmenuSbar guibg=#2d2d30 ctermbg=236
  highlight PmenuThumb guibg=#4e4e4e ctermbg=239
  highlight PmenuKind guifg=#4fc1ff guibg=#252526 ctermfg=81 ctermbg=235
  highlight PmenuKindSel guifg=#4fc1ff guibg=#094771 ctermfg=81 ctermbg=24

  highlight FloatBorder guifg=#454545 guibg=#252526 ctermfg=238 ctermbg=235

  highlight DiagnosticError guifg=#f44747 ctermfg=203
  highlight DiagnosticWarn guifg=#ff8800 ctermfg=208
  highlight DiagnosticInfo guifg=#4fc1ff ctermfg=81
  highlight DiagnosticHint guifg=#858585 ctermfg=102
  highlight DiagnosticUnderlineError gui=underline guisp=#f44747 cterm=underline
  highlight DiagnosticUnderlineWarn gui=underline guisp=#ff8800 cterm=underline
  highlight DiagnosticUnderlineInfo gui=underline guisp=#4fc1ff cterm=underline
  highlight DiagnosticUnderlineHint gui=underline guisp=#858585 cterm=underline

  highlight GitSignsAdd guifg=#587c0c ctermfg=64
  highlight GitSignsChange guifg=#0c7d9d ctermfg=31
  highlight GitSignsDelete guifg=#94151b ctermfg=88
  highlight DiffAdd guibg=#1e3a1e ctermbg=22
  highlight DiffChange guibg=#1e3a3a ctermbg=23
  highlight DiffDelete guifg=#f44747 guibg=#3a1e1e ctermfg=203 ctermbg=52
  highlight DiffText guibg=#2a5a5a ctermbg=24

  highlight TelescopeBorder guifg=#454545 ctermfg=238
  highlight TelescopePromptBorder guifg=#007acc ctermfg=31
  highlight TelescopeSelection guifg=#ffffff guibg=#094771 gui=bold ctermfg=15 ctermbg=24 cterm=bold
  highlight TelescopeSelectionCaret guifg=#4fc1ff ctermfg=81
  highlight TelescopeMatching guifg=#4fc1ff gui=bold ctermfg=81 cterm=bold
  highlight TelescopePromptPrefix guifg=#4fc1ff ctermfg=81

  highlight NvimTreeNormal guifg=#cccccc guibg=#252526 ctermfg=252 ctermbg=235
  highlight NvimTreeFolderName guifg=#cccccc ctermfg=252
  highlight NvimTreeOpenedFolderName guifg=#4fc1ff gui=bold ctermfg=81 cterm=bold
  highlight NvimTreeRootFolder guifg=#4fc1ff gui=bold ctermfg=81 cterm=bold
  highlight NvimTreeSymlink guifg=#9cdcfe ctermfg=117
  highlight NvimTreeExecFile guifg=#b5cea8 gui=bold ctermfg=150 cterm=bold
  highlight NvimTreeSpecialFile guifg=#dcdcaa ctermfg=187
  highlight NvimTreeGitDirty guifg=#ff8800 ctermfg=208
  highlight NvimTreeGitNew guifg=#587c0c ctermfg=64
  highlight NvimTreeGitDeleted guifg=#f44747 ctermfg=203

  highlight @keyword guifg=#c586c0 ctermfg=175
  highlight @keyword.function guifg=#c586c0 gui=bold ctermfg=175 cterm=bold
  highlight @function guifg=#dcdcaa ctermfg=187
  highlight @function.builtin guifg=#dcdcaa gui=bold ctermfg=187 cterm=bold
  highlight @variable guifg=#9cdcfe ctermfg=117
  highlight @variable.builtin guifg=#569cd6 ctermfg=74
  highlight @string guifg=#ce9178 ctermfg=174
  highlight @number guifg=#b5cea8 ctermfg=150
  highlight @type guifg=#4ec9b0 ctermfg=79
  highlight @type.builtin guifg=#569cd6 ctermfg=74
  highlight @constant guifg=#4fc1ff ctermfg=81
  highlight @constant.builtin guifg=#569cd6 ctermfg=74
  highlight @comment guifg=#6a9955 gui=italic ctermfg=65 cterm=italic
  highlight @parameter guifg=#9cdcfe ctermfg=117
  highlight @property guifg=#9cdcfe ctermfg=117
  highlight @constructor guifg=#4ec9b0 ctermfg=79

  highlight EndOfBuffer guifg=#1e1e1e guibg=#1e1e1e ctermfg=234 ctermbg=234

  highlight Folded guifg=#858585 guibg=#2d2d30 ctermfg=102 ctermbg=236
  highlight FoldColumn guifg=#858585 guibg=#1e1e1e ctermfg=102 ctermbg=234

  highlight SpellBad gui=undercurl guisp=#f44747 cterm=underline
  highlight SpellCap gui=undercurl guisp=#4fc1ff cterm=underline
  highlight SpellRare gui=undercurl guisp=#c586c0 cterm=underline

  highlight WhichKey guifg=#4fc1ff ctermfg=81
  highlight WhichKeyGroup guifg=#c586c0 ctermfg=175
  highlight WhichKeyDesc guifg=#cccccc ctermfg=252
  highlight WhichKeySeparator guifg=#6a9955 ctermfg=65
  highlight WhichKeyFloat guibg=#252526 ctermbg=235
  highlight WhichKeyBorder guifg=#454545 ctermfg=238

  " Indent-blankline
  highlight IblIndent guifg=#3a3a3a gui=nocombine ctermfg=237
  highlight IblScope guifg=#454545 gui=nocombine ctermfg=238

  " TODO comments
  highlight TodoBgTODO guifg=#1e1e1e guibg=#4fc1ff gui=bold ctermfg=234 ctermbg=81 cterm=bold
  highlight TodoFgTODO guifg=#4fc1ff gui=bold ctermfg=81 cterm=bold
  highlight TodoBgFIX guifg=#1e1e1e guibg=#f44747 gui=bold ctermfg=234 ctermbg=203 cterm=bold
  highlight TodoFgFIX guifg=#f44747 gui=bold ctermfg=203 cterm=bold
  highlight TodoBgNOTE guifg=#1e1e1e guibg=#dcdcaa gui=bold ctermfg=234 ctermbg=187 cterm=bold
  highlight TodoFgNOTE guifg=#dcdcaa gui=bold ctermfg=187 cterm=bold
  highlight TodoBgWARN guifg=#1e1e1e guibg=#ff8800 gui=bold ctermfg=234 ctermbg=208 cterm=bold
  highlight TodoFgWARN guifg=#ff8800 gui=bold ctermfg=208 cterm=bold

  " Treesitter context
  highlight TreesitterContext guibg=#252526 ctermbg=235
  highlight TreesitterContextLineNumber guifg=#858585 guibg=#252526 ctermfg=102 ctermbg=235

  " Flash jump labels
  highlight FlashLabel guifg=#000000 guibg=#ff007c gui=bold ctermfg=0 ctermbg=198 cterm=bold
  highlight FlashMatch guifg=#4fc1ff gui=bold ctermfg=81 cterm=bold
]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Core config
require("core.options")
require("core.mappings")
require("core.autocmds")

-- Plugins
require("plugins.lazy_setup")
