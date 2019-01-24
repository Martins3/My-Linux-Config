func! myspacevim#before() abort
    "实现一键运行
    func! QuickRun()
        exec "w"
        let ext = expand("%:e")
        if ext ==# "sh"
            exec "!sh %"
        elseif ext ==# "cpp"
            exec "!clang++ % -Wall -pthread -O3 -g -std=c++14 -o %<.out && ./%<.out"
        elseif ext ==# "c"
            exec "!clang % -Wall -g -std=c11 -o %<.out && ./%<.out" 
        elseif ext ==# "go"
            exec "!go run %" 
        elseif ext ==# "js"
            exec "!node %" 
        elseif ext ==# "py"
            exec "!python3 %" 
        elseif ext ==# "vim"
            exec "so %"
        elseif ext ==# "rs"
            exec "!rustc % -o %<.out && ./%<.out"
        else
            echo "Check file type !"
        endif
    endf
    noremap<F7> : call QuickRun()<CR>
    
    " config the make run
    call SpaceVim#custom#SPC('nnoremap', ['m', 'm'], 'make -j8', 'make with 8 thread', 1)
    call SpaceVim#custom#SPC('nnoremap', ['m', 'r'], 'make -j8 run', 'make run', 1)
    call SpaceVim#custom#SPC('nnoremap', ['m', 'c'], 'make clean', 'make clean', 1)
    call SpaceVim#custom#SPC('nnoremap', ['m', 't'], 'make -j8 test', 'make test', 1)

    call SpaceVim#custom#SPC('nnoremap', ['a', 'p'], 'GtagsGenerate!', 'update Project', 1)
    " call SpaceVim#custom#SPC('nnoremap', ['a', 'f'], 'GtagsGenerate', 'update current File', 1)
    " call SpaceVim#custom#SPC('nnoremap', ['a', 'c'], 'cclose', 'close fix window', 1)
    nnoremap <F5> :cn<CR>
    nnoremap <F6> :Gtags -r<CR>
    " config the Gtags, based on gtags.vim
    let g:gtags_open_list = 0

    " config the Gtags, based on jsfaint/gen_tags.vim
    let g:gen_tags#gtags_auto_update = 1 "be carteful,Ctrl+\ t maybe we should rewrite autowrite

    " TODO: 当打开quick fix 之后自动进入quickfix界面
    autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>


    "设置debug 选中
    nnoremap <F8> :VBGstartGDB

    "change leader
    "在spaveVim中间‘，’还有其他的用途，可以将\ 和 , 加以调换
    " let mapleader = ','
    let g:mapleader = ','
    " s　键位使用非常频繁，使用c 代替 s
    let g:spacevim_windows_leader = 'c'

    " neomake
    " checker layer is set by default, so neomake can not be shutdown implict
    " let g:neomake_cpp_enable_markers=['clang++']
    " let g:neomake_cpp_clang_args = ["-std=c++14"]
    " let g:neomake_open_list = get(g:, 'neomake_open_list', 0)

    " nerdtree隐藏部分类型的文件
    let g:NERDTreeIgnore=['\.o$', '\.out$', '\.bin$', '\.dis$', 'node_modules', '\.lock$','\.gch$', 'package.json', 'GPATH', 'GRTAGS', 'GTAGS', '\.hpp.gch$', 'compile_commands.json', '\.mod*', '\.ko', 'Module.symvers', 'modules.order']

    " let g:spacevim_default_indent = 4
    " close with key m instead of q
    " let g:spacevim_windows_smartclose = 'm'

    
    " 即使在layer层使用，但是使用ale 依旧需要手动指明
    " let g:ale_completion_enabled = 1
    let g:spacevim_enable_ale = 1
    " let g:ale_linters = {'cpp': ['clangtidy']} " default can not recognize compile_commands.json
    " let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
    " let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
    " let g:ale_c_clang_options = '-Wall -O2 -std=c99'
    " let g:ale_cpp_clang_options = '-Wall -O2 -std=c++14 -I/home/shen/Core/c/inlcude'
    " let g:spacevim_disabled_plugins = ['neomake']
    " this line should be is a test for localvimrc
    " let g:ale_cpp_clangtidy_options = '-Wall -O2 -std=c++14 -I/home/shen/Core/c/include'
    let g:ale_linters = {'c':['clangtidy'], 'cpp':['clangtidy'], 'asm':['clangtidy']}


    " make Parentheses colorful
    let g:rainbow_active = 1

    " 使用ycm实现对于c++的自动补全
    " let g:spacevim_enable_ycm = 1
    " let g:ycm_global_ycm_extra_conf = '~/.SpaceVim.d/.ycm_extra_conf.py'
    let g:spacevim_snippet_engine = 'ultisnips'
    " 实现任何位置可以阅读
    " let g:ycm_confirm_extra_conf = 1
    " let g:ycm_extra_conf_globlist = ['~/Core/linux-source-tree/*', '~/Core/sl/*', '~/Core/Sharp/*', '~/Core/pa/ics2018/*']

    set autoread
    au FocusGained,BufEnter * :checktime
    let g:table_mode_corner='|'

    " By far, I don't know how to set spell check by default just for markdown
    " set spelllang=en_us
    " set spellfile=$HOME/Dropbox/vim/spell/en.utf-8.add
    
    " 去除ycm的预览和静态检查
    " let g:ycm_add_preview_to_completeopt = 0
    " let g:ycm_show_diagnostics_ui = 0

    " TODO: 让这些文件全部是隐藏文件，从而实现git会默认忽视
    " TODO: 实现对于文件的更新数据库，采用GtagsGenerate!
    nnoremap <F4> :GundoToggle<CR>

    " TODO:实际测试，这一个效果似乎没有
    let NERDTreeAutoDeleteBuffer = 1

    " TODO: leaderf 中间含有错误, 似乎只有函数可以使用
    " TODO: autosave is stupid, we have to use some new method to do it !
    
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
