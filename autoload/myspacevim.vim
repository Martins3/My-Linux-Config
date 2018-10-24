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
            exec "Not supported file type !"
        endif
    endf
    noremap<F7> : call QuickRun()<CR>

    "设置gdb启动快捷键
    "暂时debug　的使用依旧含有问题
    call SpaceVim#custom#SPC('nnoremap', ['d', 'l'], 'VBGstartGDB ./%<.out', 'run gdb for the current file', 1)

    "根据当前文件自动修改pwd
    set autochdir

    "change leader
    "在spaveVim中间‘，’还有其他的用途，可以将\ 和 , 加以调换
    let mapleader = ','
    let g:mapleader = ','

    "设置neomake的内容
    let g:neomake_cpp_enable_markers=['clang']
    let g:neomake_cpp_clang_args = ["-std=c++14"]

    "nerdtree隐藏部分类型的文件
    let g:NERDTreeIgnore=['\.o$', '\.out$', '\.bin$', '\.dis$', 'node_modules', '\.lock$', 'package.json']

    "将默认的2 tab的缩进修改为 4 tab 缩进
    let g:spacevim_default_indent = 4

    "关闭智障的自动报错的窗口，暂时启用YCM 的效果
    let g:spacevim_lint_on_save = 0
    " let g:neomake_open_list = get(g:, 'neomake_open_list', 0)

    " 使用ycm实现对于c++的自动补全
    let g:spacevim_enable_ycm = 1
    let g:ycm_global_ycm_extra_conf = '~/.SpaceVim.d/.ycm_extra_conf.py'
    let g:spacevim_snippet_engine = 'ultisnips'
    " 实现任何位置可以阅读
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_extra_conf_globlist = ['~/Application/linux-4.18.3' ]
    " 去除ycm的预览和静态检查
    let g:ycm_add_preview_to_completeopt = 0
    let g:ycm_show_diagnostics_ui = 0

    " more smart undo than ctrl-R
    " 似乎文件夹的设置完全没有用途

    nnoremap <F4> :GundoToggle<CR>
    set undofile
    set undodir=~/.SpaceVim.d/.undo_history

    " 实际测试，这一个效果似乎没有
    let NERDTreeAutoDeleteBuffer = 1

    " gtags 的配置，但是中间的含义不是很懂
    " 认为SpaceVim 中间的ctags设置含有问题
    let $GTAGSLABEL = 'native-pygments'
    let $GTAGSCONF = '~/.SpaceVim.d/gtags.conf'



    " 禁用 gutentags 自动加载 gtags 数据库的行为
    let g:gutentags_auto_add_gtags_cscope = 0
    " 添加的内容
    let g:gutentags_define_advanced_commands = 1
    " 自动更新含有问题
    " TODO: fuzzy find 在SpaceVim中间的功能不全，而且无法理解使用的原理是什么
    " TODO: leaderf 中间含有错误
    " TODO: 无法区分当前的报错到底是ycm
    " 还是ale的结果，也就是说两者的功能都是没有办法开发完整两者的作用

endf


func! myspacevim#after() abort
    "autosave
    let g:auto_save = 1  " enable AutoSave on Vim startup
    let g:auto_save_no_updatetime = 1   " do not change the 'updatetime' option
    let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
    let g:auto_save_silent = 1  " do not display the auto-save notification

    " 使用leaderF 替代tagbar 的功能
    nnoremap <F2> :LeaderfFunction!<CR>
endf
