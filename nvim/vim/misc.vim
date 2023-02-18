" 在 markdown 中间编辑 table
let g:table_mode_corner='|'

" 默认 markdown preview 在切换到其他的 buffer 或者 vim
" 失去焦点的时候会自动关闭 preview
let g:mkdp_auto_close = 0
" 书签选中之后自动关闭 quickfix window
let g:bookmark_auto_close = 1

" 让光标自动进入到 popup window 中间
let g:git_messenger_always_into_popup = v:true

" 设置默认的 pdf 阅览工具
let g:vimtex_view_method = 'zathura'
let g:tex_conceal = "" " 关闭所有隐藏设置

" 因为 telescope-coc 没有实现 outline，所以只能靠 telescope-heading.nvim 实现
func! Outline()
  if expand("%:e") ==# "md"
    exec "Telescope heading"
  else
    exec "Telescope coc document_symbols"
  endif
endf

" 实现一键运行各种文件，适合非交互式的，少量的代码，比如 leetcode
func! QuickRun()
  exec "w"
  let ext = expand("%:e")
  if ext ==# "tex"
    exec "VimtexCompile"
  else
    exec "RunCode"
  endif
endf

func! Preivew()
  exec "w"
  let ext = expand("%:e")
  if ext ==# "md"
    exec "MarkdownPreview"
  elseif ext ==# "tex"
    exec "VimtexView"
  else
    echo "no preview"
  endif
endf

let g:vista_sidebar_position = "vertical topleft"
let g:vista_default_executive = 'coc'
let g:vista_finder_alternative_executives = 'ctags'

let g:git_messenger_no_default_mappings = v:true

" 使用 gx 在 vim 中间直接打开链接
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" 不要让进入 vim 的时候光标在 nvim-tree 中，所以默认关闭 bookmarks
let g:auto_session_pre_save_cmds = ["NvimTreeClose", "BookmarkSave.vim-bookmarks"]
let g:auto_session_pre_restore_cmds = ["BookmarkLoad .vim-bookmarks"]

let g:bookmark_save_per_working_dir = 1
let g:bookmark_no_default_key_mappings = 1

let g:floaterm_keymap_prev   = '<C-p>'
let g:floaterm_keymap_new    = '<C-n>'
let g:floaterm_keymap_toggle = '<C-t>'

" 默认不要折叠 markdown
let g:vim_markdown_folding_disabled = 1

let g:markdown_fenced_languages = ['html', 'python', 'sh', 'c', 'cpp', 'diff', 'rust']
let g:markdown_minlines = 200

" 自动关闭 vim 如果 window 中只有一个 filetree
" https://github.com/kyazdani42/nvim-tree.lua
autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif

" 定义预先录制的 macro
let @j = 'ysiw`\<Esc>' " 在一个 word 两侧添加上 `，例如将 abc 变为 `abc`
