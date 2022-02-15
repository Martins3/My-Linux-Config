" ref: https://www.chrisatmachine.com/Neovim/02-vim-general-settings/
syntax enable                           " Enables syntax highlighing
set mouse=a                             " Enable your mouse
set nowrap                              " Display long lines as just one line
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set tabstop=2                           " Insert 2 spaces for a tab
set shiftwidth=2                        " Change the number of space characters inserted for indentation
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set autoindent                          " Good auto indent
set number                              " Line numbers
set cursorline                          " Enable highlighting of the current line
set termguicolors
set hidden
" 让退出 vim 之后 undo 消息不消失
set undofile
" 在滚动屏幕的时候保留 3 行
set scrolloff=3
" 在替换的时候，自动设置 split 一个窗口来预览
set inccommand=split
" 当打开文件的时候，自动进入到上一次编辑的位置
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
" 当文件被其他编辑器修改时，自动加载
set autoread
au FocusGained,BufEnter * :checktime
" 当失去焦点或者离开当前的 buffer 的时候保存
set autowrite
autocmd FocusLost,BufLeave * silent! update
" 在 terminal 中也是使用 esc 来进入 normal 模式
tnoremap  <Esc>  <C-\><C-n>
" 映射 leader 键为 ,
let g:mapleader = ','
" 设置主题
colorscheme tokyonight

augroup CursorLineOnlyInActiveWindow
    autocmd!
    " 离开插入模式时
    autocmd InsertLeave * setlocal relativenumber
    " 进入插入模式时
    autocmd InsertEnter * setlocal norelativenumber
    " 进入缓冲区后
    autocmd BufEnter * setlocal cursorline
    " 离开缓冲区后
    autocmd BufLeave * setlocal nocursorline
augroup END

" 将 q 映射为 <leader>q，因为录制宏的操作比较少，而关掉窗口的操作非常频繁
noremap <leader>q q

" 在 markdown 中间编辑 table
let g:table_mode_corner='|'

" 调节 window 大小
let g:winresizer_start_key = 'ca'
" If you cancel and quit window resize mode by `q` (keycode 113)
let g:winresizer_keycode_cancel = 113

" 默认 markdown preview 在切换到其他的 buffer 或者 vim
" 失去焦点的时候会自动关闭 preview
let g:mkdp_auto_close = 0
" 书签选中之后自动关闭 quickfix window
let g:bookmark_auto_close = 1

" ctrl + ] 查询 cppman
" 如果想让该快捷键自动查询 man，将Cppman 替换为 Cppman!
autocmd FileType c,cpp noremap <C-]> <Esc>:execute "Cppman " . expand("<cword>")<CR>

" 让光标自动进入到popup window 中间
let g:git_messenger_always_into_popup = v:true

" 设置默认的 pdf 阅览工具
let g:vimtex_view_method = 'zathura'
let g:vimtex_syntax_conceal_default = 0
let g:tex_conceal = "" " 关闭所有隐藏设置

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
  if ext ==# "md"
    exec "MarkdownPreview"
  elseif ext ==# "lua"
    exec "source %"
  else
    exec "RunCode"
  endif
endf

let g:vista_sidebar_position = "vertical topleft"
let g:vista_default_executive = 'coc'
let g:vista_finder_alternative_executives = 'ctags'

let g:floaterm_keymap_prev   = '<C-p>'
let g:floaterm_keymap_new    = '<C-n>'
let g:floaterm_keymap_toggle = '<C-t>'

" 使用 f/F 来快速移动
" press <esc> to cancel.
nmap f <Plug>(coc-smartf-forward)
nmap F <Plug>(coc-smartf-backward)
nmap ; <Plug>(coc-smartf-repeat)
" nmap , <Plug>(coc-smartf-repeat-opposite)

augroup Smartf
  autocmd User SmartfEnter :hi Conceal ctermfg=220 guifg=pink
  autocmd User SmartfLeave :hi Conceal ctermfg=239 guifg=#504945
augroup end

" 访问系统剪切板
map <leader>y "+y
map <leader>p "+p
map <leader>d "+d

let g:git_messenger_no_default_mappings = v:true

" 加载各种插件的配置, 参考 https://github.com/jdhao/nvim-config
let s:core_conf_files = [
      \ 'coc.vim',
      \ 'debug.vim',
      \ 'ccls.vim',
      \ 'wilder.vim',
      \ 'startify.vim',
      \ 'airline.vim',
      \ ]

for s:fname in s:core_conf_files
  execute printf('source %s/vim/%s', stdpath('config'), s:fname)
endfor

" 加载 lua 配置
lua require 'plugins'
lua require 'buffer-config'
lua require 'orgmode-config'
lua require 'telescope-config'
lua require 'tree-config'
lua require 'whichkey-config'
lua require 'code-runner-config'
lua require 'colorizer'.setup{'css'; 'javascript'; 'vim'; html = { mode = 'foreground';}}
lua require('nvim-autopairs').setup{}
