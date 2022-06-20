" ref: https://www.chrisatmachine.com/Neovim/02-vim-general-settings/
syntax enable
" 鼠标可以移动，调整窗口等
set mouse=a
" 超过 window 宽度的行不要折叠
set nowrap
" 自动进入到新打开的窗口
set splitbelow
set splitright
" 打开行号
set number
" 高亮光标所在行
set cursorline
set termguicolors
" 因为失去焦点就会自动保存，所以没有必要使用 swapfile
set noswapfile
" 这个 feature 暂时不稳定: https://github.com/neovim/neovim/pull/18961
" set cmdheight=0
" 让退出 vim 之后 undo 消息不消失
set undofile
" 只有一个全局的 status line，而不是每一个 window 一个
set laststatus=3
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

" 将 q 映射为 <leader>q，因为录制宏的操作比较少，而关掉窗口的操作非常频繁
noremap <leader>q q

" 访问系统剪切板
map <leader>y "+y
map <leader>p "+p
map <leader>d "+d

" 使用 z a 打开和关闭 fold
set foldlevelstart=99
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

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
lua require('telescope').load_extension('neoclip')

" 加载 vim 配置, 参考 https://github.com/jdhao/nvim-config
let s:core_conf_files = [
      \ 'misc.vim',
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

" 设置主题，最下面的会生效
colorscheme tokyonight
let g:everforest_background = 'hard'
colorscheme everforest
colorscheme gruvbox
