func! myspacevim#before() abort
  " 当文件被其他编辑器修改时，自动加载
  set autoread
  au FocusGained,BufEnter * :checktime

  " 当失去焦点或者离开当前的 buffer 的时候保存
  set autowrite
  autocmd FocusLost,BufLeave * silent! update

  " 重新映射 leader 键
  let g:mapleader = ','

  " 重新映射 window 键位
  let g:spacevim_windows_leader = 'c'
  
  " 在 markdown 中间编辑 table
  let g:table_mode_corner='|'

  " 调节 window 大小
  let g:winresizer_start_key = '<space>wa'

  " If you cancel and quit window resize mode by `q` (keycode 113)
  let g:winresizer_keycode_cancel = 113

  " 默认 markdown preview 在切换到其他的 buffer 或者 vim
  " 失去焦点的时候会自动关闭 preview，让
  let g:mkdp_auto_close = 0

  " 书签选中之后自动关闭 quickfix window
  let g:bookmark_auto_close = 1

  " 设置一个删除所有的 bookmark 的快捷键
  call SpaceVim#custom#SPC('nnoremap', ['m', 'c'], 'BookmarkClearAll', 'clear all bookmark', 1)

  " ctrl + ] 查询 cppman
  " 如果想让该快捷键自动查询 man，将Cppman 替换为 Cppman!
  autocmd FileType c,cpp noremap <C-]> <Esc>:execute "Cppman " . expand("<cword>")<CR>

  " 让光标自动进入到popup window 中间
  let g:git_messenger_always_into_popup = v:true
  " 设置映射规则，和 spacevim 保持一致
  call SpaceVim#custom#SPC('nnoremap', ['g', 'm'], 'GitMessenger', 'show commit message in popup window', 1)
  call SpaceVim#custom#SPC('nnoremap', ['g', 'l'], 'FloatermNew tig status', 'open lazygit in floaterm', 1)

  " 和 sourcetrail 配合使用
  call SpaceVim#custom#SPC('nnoremap', ['a', 'a'], 'SourcetrailStartServer', 'start sourcetrail server', 1)
  call SpaceVim#custom#SPC('nnoremap', ['a', 'b'], 'SourcetrailActivateToken', 'sync sourcetrail with neovim', 1)
  call SpaceVim#custom#SPC('nnoremap', ['a', 'f'], 'SourcetrailRefresh', 'sourcetrail server', 1)

  call SpaceVim#custom#SPC('nnoremap', ['s', 'f'], 'lua myluamodule.local_lua_function()', 'forbit !', 1)
  call SpaceVim#custom#SPC('nnoremap', ['s', 'k'], 'lua myluamodule.local_lua_function()', 'forbit !', 1)
  call SpaceVim#custom#SPC('nnoremap', ['s', 'i'], 'lua myluamodule.local_lua_function()', 'forbit !', 1)
  call SpaceVim#custom#SPC('nnoremap', ['s', 'l'], 'lua myluamodule.local_lua_function()', 'forbit !', 1)
  call SpaceVim#custom#SPC('nnoremap', ['s', 'j'], 'lua myluamodule.local_lua_function()', 'forbit !', 1)
  call SpaceVim#custom#SPC('nnoremap', ['f', 's'], "lua myluamodule.local_lua_function()", 'forbit !', 2)

  call SpaceVim#custom#SPC('nnoremap', ['f', 'o'], "NvimTreeFindFile", 'wow the excellent', 2)

  " 设置默认的pdf阅览工具
  let g:vimtex_view_method = 'zathura'
  let g:vimtex_syntax_conceal_default = 0
  " 关闭所有隐藏设置
  let g:tex_conceal = ""

  " 实现一键运行各种文件，适合非交互式的，少量的代码，比如 leetcode
  func! QuickRun()
    exec "w"
    let ext = expand("%:e")

    if ext ==# "sh"
      exec "!bash %"
    elseif ext ==# "cpp"
      let out = expand('%:p') . ".out"
      exec "!clang++ % -Wall -lpthread -g -std=c++17 -o " . out . " && " . out
    elseif ext ==# "c"
      let out = expand('%:p') . ".out"
      exec "!clang % -Wall -lpthread -g -std=c11 -o " . out . " && " . out
    elseif ext ==# "java"
      let classPath = expand('%:h')
      let className = expand('%:p:t:r')
      " echo classPath
      " echo className
      exec "!javac %"
      exec "!java -classpath " . classPath . " " . className
    elseif ext ==# "go"
      exec "!go run %"
    elseif ext ==# "js"
      exec "!node %"
    elseif ext ==# "bin"
      exec "!readelf -h %"
    elseif ext ==# "py"
      exec "!python3 %"
    elseif ext ==# "vim"
      exec "so %"
    elseif ext ==# "html"
      exec "!microsoft-edge %"
    elseif ext ==# "rs"
      call CargoRun()
    elseif ext ==# "svg"
      exec "%!xmllint --format -"
    elseif ext ==# "lua"
      exec "source %"
    else
      echo "Check file type !"
    endif
    echo 'done'
  endf

  " 一键运行 rust 工程，不断向上查找直到遇到 Cargo.toml，然后执行 cargo run
  func! CargoRun()
    let cargo_run_path = fnamemodify(resolve(expand('%:p')), ':h')
    while cargo_run_path != "/"
      if filereadable(cargo_run_path . "/Cargo.toml")
        echo cargo_run_path
        exec "cd " . cargo_run_path
        exec "!cargo run"
        exec "cd -"
        return
      endif
      let cargo_run_path = fnamemodify(cargo_run_path, ':h')
    endwhile
    echo "Cargo.toml not found !"
  endf

  " floaterm
  let g:floaterm_keymap_prev   = '<C-p>'
  let g:floaterm_keymap_new    = '<C-n>'
  let g:floaterm_keymap_toggle = '<F5>'
  let g:floaterm_height = 1.0
endf

func! myspacevim#after() abort
  " <F3> 打开文件树
  let g:vista_sidebar_position = "vertical topleft"
  let g:vista_default_executive = 'coc'
  let g:vista_finder_alternative_executives = 'ctags'
  nnoremap  <F2>  :Vista!!<CR>
  " nnoremap  <F3>  :CocCommand explorer<CR>
  nnoremap  <F4>  :call QuickRun()<CR>
  " <F5> floaterm toggle
  " <F7> 打开历史记录
  tnoremap  <Esc>  <C-\><C-n>

  " 使用 tab 切换 window
  map <Tab> :wincmd w<CR>

  " press <esc> to cancel.
  nmap f <Plug>(coc-smartf-forward)
  nmap F <Plug>(coc-smartf-backward)
  nmap ; <Plug>(coc-smartf-repeat)
  nmap , <Plug>(coc-smartf-repeat-opposite)

  nmap <Leader>k <Cmd>call CocAction('runCommand', 'explorer.doAction', 'closest', ['reveal:0'], [['relative', 0, 'file']])<CR>

let g:nvim_tree_quit_on_open = 0 "0 by default, closes the tree when you open a file
let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
let g:nvim_tree_disable_window_picker = 1 "0 by default, will disable the window picker.
let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
let g:nvim_tree_create_in_closed_folder = 0 "1 by default, When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
let g:nvim_tree_refresh_wait = 500 "1000 by default, control how often the tree can be refreshed, 1000 means the tree can be refresh once per 1000ms.
let g:nvim_tree_window_picker_exclude = {
    \   'filetype': [
    \     'notify',
    \     'packer',
    \     'qf'
    \   ],
    \   'buftype': [
    \     'terminal'
    \   ]
    \ }
" Dictionary of buffer option names mapped to a list of option values that
" indicates to the window picker that the buffer's window should not be
" selectable.
let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 1,
    \ 'folder_arrows': 0,
    \ }
nnoremap <F3>  :NvimTreeToggle<CR>
" nnoremap <C-r> :NvimTreeRefresh<CR>
" nnoremap <leader>n :NvimTreeFindFile<CR>
" NvimTreeOpen, NvimTreeClose, NvimTreeFocus, NvimTreeFindFileToggle, and NvimTreeResize are also available if you need them

set termguicolors " this variable must be enabled for colors to be applied properly

" a list of groups can be found at `:help nvim_tree_highlight`
highlight NvimTreeFolderIcon guibg=blue

  luafile ~/.SpaceVim.d/lua/init.lua
  " luafile ~/.SpaceVim.d/lua/tree.lua
  " luafile ~/.SpaceVim.d/lua/drink.lua
  " luafile ~/.SpaceVim.d/lua/my.lua
  " luafile ~/.SpaceVim.d/lua/ts.lua

  " lua package.path = package.path .. ";~/.SpaceVim.d/lua"
  " lua myluamodule = require("my")

  nmap <M-a> <Cmd>echo "hi"<CR>
  nmap <M-1> <Cmd>silent !tmux select-window -t 1 <CR>
  nmap <M-2> <Cmd>silent !tmux select-window -t 2 <CR>
  nmap <M-3> <Cmd>silent !tmux select-window -t 3 <CR>
  nmap <M-4> <Cmd>silent !tmux select-window -t 4 <CR>
  nmap <M-5> <Cmd>silent !tmux select-window -t 5 <CR>
  nmap <M-6> <Cmd>silent !tmux select-window -t 6 <CR>
  nmap <M-7> <Cmd>silent !tmux select-window -t 7 <CR>
  nmap <M-8> <Cmd>silent !tmux select-window -t 8 <CR>
  nmap <M-9> <Cmd>silent !tmux select-window -t 9 <CR>
endf
