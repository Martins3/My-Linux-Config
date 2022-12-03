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
" 自动隐藏 command-line
set cmdheight=0
" 让退出 vim 之后 undo 消息不消失
set undofile
" 只有一个全局的 status line，而不是每一个 window 一个
set laststatus=3
" 当打开文件的时候，自动进入到上一次编辑的位置
lua vim.api.nvim_create_autocmd( "BufReadPost", { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] })
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

" 让远程的 server 内容拷贝到系统剪切板中，具体参考 https://github.com/ojroques/vim-oscyank
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif
autocmd TextYankPost * if v:event.operator is 'd' && v:event.regname is '+' | execute 'OSCYankReg +' | endif

" 使用 z a 打开和关闭 fold
set foldlevelstart=99
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" 加载 lua 配置
lua require 'usr'

" 加载 vim 配置, 参考 https://github.com/jdhao/nvim-config
let s:core_conf_files = [
      \ 'misc.vim',
      \ 'coc.vim',
      \ 'debug.vim',
      \ 'wilder.vim',
      \ 'startify.vim',
      \ 'airline.vim',
      \ ]

for s:fname in s:core_conf_files
  execute printf('source %s/vim/%s', stdpath('config'), s:fname)
endfor

" patch for coc-sumneko-lua plugin on nixos
" for details, see https://github.com/xiyaowong/coc-sumneko-lua/issues/22
if $USERNAME == "martins3"
  call coc#config("sumneko-lua.serverDir", "/home/martins3/.nix-profile/")
  call coc#config("Lua.misc.parameters",
        \ [ "--metapath",
        \ "/home/martins3/.cache/sumneko_lua/meta",
        \ "--logpath",
        \ "/home/martins3/.cache/sumneko_lua/log"]
        \)
endif


colorscheme tokyonight
" this keymapping originally set by whichkey doesn't work in neovim 0.8
noremap <Space>bc :BDelete hidden<cr>

" 因为 nvim-treesitter-textobjects 使用 x 来跳转，原始的 x 被映射为 xx
nn xx x
