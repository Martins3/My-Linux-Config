func! myspacevim#before() abort
    " 实现一键运行
    func! QuickRun()
        exec "w"
        let ext = expand("%:e")
        if ext ==# "sh"
            exec "!sh %"
        elseif ext ==# "md"
            exec "!dos2unix %"
        elseif ext ==# "cpp"
            exec "!clang++ % -Wall -O3 -g -std=c++11 -o %<.out && ./%<.out"
        elseif ext ==# "c"
            exec "!clang % -Wall -g -std=c11 -o %<.out && ./%<.out"
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
            exec "!google-chrome-stable %"
        elseif ext ==# "rs"
            call CargoRun()
        else
            echo "Check file type !"
        endif
    endf

    " 一键运行 rust 工程
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

    " 重新映射 leader 键
    let g:mapleader = ','
    " 重新映射 window 键位
    let g:spacevim_windows_leader = 'c'


    " 自定义的Space 的快捷键
    call SpaceVim#custom#SPC('nnoremap', ['m', 'm'], 'make -j8', 'make with 8 thread', 1)
    call SpaceVim#custom#SPC('nnoremap', ['m', 'c'], 'make clean', 'make clean', 1)
    call SpaceVim#custom#SPC('nnoremap', ['m', 'r'], 'make run', 'make run', 1)
    call SpaceVim#custom#SPC('nnoremap', ['m', 'd'], 'guigdb %', 'debug current file', 1)

    call SpaceVim#custom#SPC('nnoremap', ['s', 'f'], 'Vista finder', 'search ctags simbols', 1)
    call SpaceVim#custom#SPC('nnoremap', ['s', 'F'], 'LeaderfFunction!', 'list functions', 1)

    " 为了使用 vim-commentary 而不是 nerdcommenter
    " 似乎必须显示的disable掉这个插件
    " https://github.com/SpaceVim/SpaceVim/issues/216
    let g:spacevim_disabled_plugins = ['nerdcommenter']
    " remap vim-commentary 来保持兼容
    nmap <space>cl gcc
    vmap <space>cl gc


    let g:spacevim_snippet_engine = 'ultisnips'

    let g:table_mode_corner='|'

    " If you want to start window resize mode by `Ctrl+T`
    let g:winresizer_start_key = '<space>wa'
    " If you cancel and quit window resize mode by `q` (keycode 113)
    let g:winresizer_keycode_cancel = 113

    " spell https://wiki.archlinux.org/index.php/Language_checking
    
    let g:spacevim_enable_vimfiler_filetypeicon = 1
    " let g:spacevim_enable_vimfiler_gitstatus = 1

    " 书签选中之后自动关闭 quickfix window
    let g:bookmark_auto_close = 1

    let g:vista_echo_cursor_strategy = 'scroll'
    let g:vista_close_on_jump = 1
    let g:vista_sidebar_position = "vertical topleft"


    " vim-lsp-cxx-highlight 和这个选项存在冲突
    " let g:rainbow_active = 1
endf



func! myspacevim#after() abort
    " 焦点消失的时候自动保存
    au FocusLost * :wa
    au FocusGained,BufEnter * :checktime

    set autowrite
    set autoread

    nnoremap <F2> :Vista!!<CR>
    " <F3> 打开文件树
    nnoremap <F4> :call QuickRun()<CR>
    " <F7> 打开历史记录

    " 重新映射终端的快捷键
    tnoremap <Esc> <C-\><C-n>

    " Cppman
    " autocmd FileType cpp nnoremap <silent><buffer> <C-]> <Esc>:Cppman <cword><CR>
    set foldmethod=syntax
    set nofoldenable
endf
