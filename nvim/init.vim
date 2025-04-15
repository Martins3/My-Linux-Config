set autoread
au FocusGained,BufEnter * :checktime
" 当失去焦点或者离开当前的 buffer 的时候保存
set autowrite
autocmd FocusLost,BufLeave * silent! update

" 映射 leader 键为 ,
let g:mapleader = ','
" 将 q 映射为 <leader>q，因为录制宏的操作比较少，而关掉窗口的操作非常频繁
noremap <leader>q q

" 访问系统剪切板
map <leader>y "+y
map <leader>p "+p
map <leader>d "+d

" 使用 z a 打开和关闭 fold ，打开大文件（超过 10 万行）的时候可能造成性能问题
" set foldlevelstart=99
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

" 加载 lua 配置
lua require 'usr'

" 在 markdown 中间编辑 table
let g:table_mode_corner='|'

" 让光标自动进入到 popup window 中间
let g:git_messenger_always_into_popup = v:true
let g:git_messenger_no_default_mappings = v:true

" 使用 gx 在 vim 中间直接打开链接
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" 自动关闭 vim 如果 window 中只有一个 filetree
" https://github.com/kyazdani42/nvim-tree.lua

" 关闭特性，开启后会导致nvim 目录时发生闪退
" Disable the feature; enabling it causes Neovim to crash when accessing directories.

" autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif

" 定义预先录制的 macro
let @j = 'ysiw`\<Esc>' " 在一个 word 两侧添加上 `，例如将 abc 变为 `abc`
let @k = 'ysiw"\<Esc>'

let g:loaded_perl_provider = 0

" this keymapping originally set by whichkey doesn't work in neovim 0.8
noremap <Space>bc :BDelete hidden<cr>

let g:gitblame_delay = 1500
let g:gitblame_ignored_filetypes = ['lua', 'markdown', 'sh']

" 因为 nvim-treesitter-textobjects 使用 x 来跳转，原始的 x 被映射为 xx
nn xx x
