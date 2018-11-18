func! myspacevim#before() abort
    "实现一键运行
    func! QuickRun()
        exec "w"
        let ext = expand("%:e")
        if ext ==# "sh"
            exec "!sh %"
        elseif ext ==# "cpp"
            exec "!clang++ % -Wall -g -std=c++14 -o %<.out && ./%<.out"
        elseif ext ==# "c"
            exec "!clang % -Wall -g -std=c11 -o %<.out && ./%<.out" 
        elseif ext ==# "go"
            exec "!go run %" 
        elseif ext ==# "js"
            exec "!node %" 
        elseif ext ==# "py"
            exec "!python3 %" 
        else
            echo "Check file type !"
        endif
    endf
    noremap<F7> : call QuickRun()<CR>

    " 设置gdb启动快捷键
    " 暂时debug　的使用依旧含有问题
    " call SpaceVim#custom#SPC('nnoremap', ['d', 'l'], 'VBGstartGDB ./%<.out', 'run gdb for the current file', 1)
    
    " config the make run
    call SpaceVim#custom#SPC('nnoremap', ['m', 'm'], 'make -j8', 'make with 8 thread', 1)
    call SpaceVim#custom#SPC('nnoremap', ['m', 'r'], 'make -j8 run', 'make run', 1)
    call SpaceVim#custom#SPC('nnoremap', ['m', 'c'], 'make clean', 'make clean', 1)
    call SpaceVim#custom#SPC('nnoremap', ['m', 't'], 'make test', 'make test', 1)

    " config the Gtags
    " The reason use 'a' is : other keys are already occupied by default. :)
    " call SpaceVim#custom#SPC('nnoremap', ['a', 'r'], 'Gtags -r', 'show Reference', 1)
    " call SpaceVim#custom#SPC('nnoremap', ['a', 'd'], 'Gtags', 'show Definition', 1)
    call SpaceVim#custom#SPC('nnoremap', ['a', 'p'], 'GtagsGenerate!', 'update Project', 1)
    call SpaceVim#custom#SPC('nnoremap', ['a', 'f'], 'GtagsGenerate', 'update current File', 1)
    call SpaceVim#custom#SPC('nnoremap', ['a', 'c'], 'cclose', 'close fix window', 1)

    " TODO: 当打开quick fix 之后自动进入quickfix界面
    autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>
    nnoremap <F5> :Gtags<CR>
    nnoremap <F6> :Gtags -r<CR>
    "设置debug 选中
    nnoremap <F8> :VBGstartGDB 

    "change leader
    "在spaveVim中间‘，’还有其他的用途，可以将\ 和 , 加以调换
    " let mapleader = ','
    let g:mapleader = ','
    " s　键位使用非常频繁，使用c 代替 s
    let g:spacevim_windows_leader = 'c'

    " 设置neomake的内容
    " checker layer is set by default, so neomake can not be shutdown implict
    " let g:neomake_cpp_enable_markers=['clang++']
    " let g:neomake_cpp_clang_args = ["-std=c++14"]
    " let g:neomake_open_list = get(g:, 'neomake_open_list', 0)

    "nerdtree隐藏部分类型的文件
    let g:NERDTreeIgnore=['\.o$', '\.out$', '\.bin$', '\.dis$', 'node_modules', '\.lock$','\.gch$', 'package.json', 'GPATH', 'GRTAGS', 'GTAGS', '\.hpp.gch$', 'compile_commands.json', '\.mod*', '\.ko', 'Module.symvers', 'modules.order']

    " 将默认的2 tab的缩进修改为 4 tab 缩进
    let g:spacevim_default_indent = 4
    " close with key m instead of q
    let g:spacevim_windows_smartclose = 'm'
    
    " 即使在layer层使用，但是使用ale 依旧需要手动指明
    " let g:ale_completion_enabled = 1
    " let g:spacevim_enable_ale = 1
    " let g:ale_linters = {'cpp': ['clangtidy']} " default can not recognize compile_commands.json
    " let g:ale_sign_error = '>>'
    " let g:ale_sign_warning = '--'
    let g:spacevim_disabled_plugins = ['neomake']


    " 使用ycm实现对于c++的自动补全
    let g:spacevim_enable_ycm = 1
    let g:ycm_global_ycm_extra_conf = '~/.SpaceVim.d/.ycm_extra_conf.py'
    let g:spacevim_snippet_engine = 'ultisnips'
    " 实现任何位置可以阅读
    " let g:ycm_confirm_extra_conf = 1
    " let g:ycm_extra_conf_globlist = ['~/Core/linux-source-tree/*', '~/Core/ldd/']
    
    " 去除ycm的预览和静态检查
    " let g:ycm_add_preview_to_completeopt = 0
    " let g:ycm_show_diagnostics_ui = 0

    " TODO: 让这些文件全部是隐藏文件，从而实现git会默认忽视
    " TODO: 实现对于文件的更新数据库，采用GtagsGenerate!
    nnoremap <F4> :GundoToggle<CR>
    " 没有必要重新设置文件夹，在.cache中间
    " set undofile
    " set undodir=~/.SpaceVim.d/.undo_history

    " TODO:实际测试，这一个效果似乎没有
    let NERDTreeAutoDeleteBuffer = 1

    " TODO: leaderf 中间含有错误, 似乎只有函数可以使用
endf


func! myspacevim#after() abort
    "autosave
    let g:auto_save = 1  " enable AutoSave on Vim startup
    let g:auto_save_no_updatetime = 1   " do not change the 'updatetime' option
    let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
    let g:auto_save_silent = 1  " do not display the auto-save notification

    " 使用leaderF 替代tagbar 的功能
    nnoremap <F2> :LeaderfFunction!<CR>
    " 使用GtagsCursor 代替ctags的功能
    map <C-]> :GtagsCursor<CR>
endf
