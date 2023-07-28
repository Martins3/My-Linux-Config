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

" 让远程的 server 内容拷贝到系统剪切板中，具体参考 https://github.com/ojroques/vim-oscyank
autocmd TextYankPost *
    \ if v:event.operator is 'y' && v:event.regname is '+' |
    \ execute 'OSCYankRegister +' |
    \ endif

autocmd TextYankPost *
    \ if v:event.operator is 'd' && v:event.regname is '+' |
    \ execute 'OSCYankRegister +' |
    \ endif

" 使用 z a 打开和关闭 fold，打开大文件（超过 10万行)的时候可能造成性能问题
" set foldlevelstart=99
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

" floaterm 永远的神
let g:floaterm_width = 0.7
let g:floaterm_height = 0.7
let g:floaterm_keymap_prev   = '<C-p>'
let g:floaterm_keymap_new    = '<C-n>'
let g:floaterm_keymap_toggle = '<C-t>'

" 加载 lua 配置
lua require 'usr'

" 加载 vim 配置, 参考 https://github.com/jdhao/nvim-config
let s:core_conf_files = [
      \ 'misc.vim',
      \ 'debug.vim',
      \ 'wilder.vim',
      \ ]

for s:fname in s:core_conf_files
  execute printf('source %s/vim/%s', stdpath('config'), s:fname)
endfor

let g:loaded_perl_provider = 0

" this keymapping originally set by whichkey doesn't work in neovim 0.8
noremap <Space>bc :BDelete hidden<cr>

let g:gitblame_delay = 1500
let g:gitblame_ignored_filetypes = ['lua', 'markdown', 'sh']

" 因为 nvim-treesitter-textobjects 使用 x 来跳转，原始的 x 被映射为 xx
nn xx x
