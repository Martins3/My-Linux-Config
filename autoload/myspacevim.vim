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
        elseif ext ==# "html"
            exec "!google-chrome-stable %"
        elseif ext ==# "rs"
            call CargoRun()
        else
            echo "Check file type !"
        endif
    endf

func! GoToDef()
    let ext = expand("%:e")
    if ext ==# "c" || ext ==# "cpp" || ext ==# "cpp"
      echo "begin"
      exec "GtagsCursor"
      echo "end"
    elseif ext ==# "rs"
     echo "Debug this go to def"
     call LanguageClient#textDocument_definition()
    else
      echo "There is no goto definition for this file type!"
    endif
endf

func! FormatFile()
    let ext = expand("%:e")
    if ext ==# "c" || ext ==# "cpp" || ext ==# "cpp"
      exec 'Neoformat'
    elseif ext ==# "rs"
      exec 'RustFmt'
    else
      echo "There is no format config for this file type!"
    endif
endf


" TODO not familiar with vimscipt, maybe better implementation

" 1. rust project root is tag with Cargo.toml instread of VCS
" 2. this configuration is only for project, not for single rust file
func! CargoRun()
  let cargo_run_path = fnamemodify(resolve(expand('%:p')), ':h')
  while cargo_run_path != "/"
    if filereadable(cargo_run_path . "/Cargo.toml")
        echo cargo_run_path
        exec "cd " . cargo_run_path
        exec "Cargo run"
        exec "cd -"
        return
    endif
   let cargo_run_path = fnamemodify(cargo_run_path, ':h')
  endwhile
  echo "Cargo.toml not found !"
endf

    " call SpaceVim#layers#disable('core#statusline')
    " call SpaceVim#layers#disable('core#tabline')

    " config the make run
    call SpaceVim#custom#SPC('nnoremap', ['m', 'm'], 'make -j8', 'make with 8 thread', 1)
    call SpaceVim#custom#SPC('nnoremap', ['m', 'r'], 'make -j8 run', 'make run', 1)
    call SpaceVim#custom#SPC('nnoremap', ['m', 'c'], 'make clean', 'make clean', 1)
    call SpaceVim#custom#SPC('nnoremap', ['m', 't'], 'make -j8 test', 'make test', 1)
    call SpaceVim#custom#SPC('nnoremap', ['m', 'd'], 'guigdb %', 'debug current file', 1)

    call SpaceVim#custom#SPC('nnoremap', ['a', 'c'], 'cclose', 'close fix window', 1)
    call SpaceVim#custom#SPC('nnoremap', ['a', 'p'], 'GtagsGenerate!', 'create a gtags database', 1)
    call SpaceVim#custom#SPC('nnoremap', ['a', 'u'], 'GtagsGenerate', 'update tag database', 1)
    call SpaceVim#custom#SPC('nnoremap', ['s', 'm'], 'Gtags', 'search tags', 1)
    " call SpaceVim#custom#SPC('nnoremap', ['a', 'f'], 'GtagsGenerate', 'update current File', 1)

    " config the Gtags, based on gtags.vim
    " gtags update
    let g:gtags_open_list = 0

    "rust auto fmt when save file
    " let g:rustfmt_autosave = 1

    " config the Gtags, based on jsfaint/gen_tags.vim
    " let g:gen_tags#gtags_auto_update = 1 "be carteful,Ctrl+\ t maybe we should rewrite autowrite

    " TODO: 当打开quick fix 之后自动进入quickfix界面
    autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>



    "change leader
    "在spaveVim中间‘，’还有其他的用途，可以将\ 和 , 加以调换
    let g:mapleader = ','
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
    " let g:ale_linters = {'cpp': ['clangtidy']} " default can not recognize compile_commands.json
    " let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
    " let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
    " let g:ale_c_clang_options = '-Wall -O2 -std=c99'
    " let g:ale_cpp_clang_options = '-Wall -O2 -std=c++14 -I/home/shen/Core/c/inlcude'
    " let g:spacevim_disabled_plugins = ['neomake']
    " this line should be is a test for localvimrc
    " let g:ale_cpp_clangtidy_options = '-Wall -O2 -std=c++14 -I/home/shen/Core/c/include'

    " let g:spacevim_enable_ale = 1
    " let g:ale_linters = {'c':['clangtidy'], 'cpp':['clangtidy'], 'asm':['clangtidy']}


    " make Parentheses colorful
    " let g:rainbow_active = 1

    " 使用ycm实现对于c的自动补全
    " let g:spacevim_enable_ycm = 1
    " let g:spacevim_autocomplete_method = 'ycm'
    let g:spacevim_snippet_engine = 'ultisnips'
    " 去除ycm的预览和静态检查
    " let g:ycm_add_preview_to_completeopt = 0
    " let g:ycm_show_diagnostics_ui = 0
    " To elimilite some error
    " let g:ycm_global_ycm_extra_conf = '~/.SpaceVim.d/.ycm_extra_conf.py'
    " 实现任何位置可以阅读
    " let g:ycm_confirm_extra_conf = 1
    " let g:ycm_extra_conf_globlist = ['~/Core/linux-source-tree/*', '~/Core/sl/*', '~/Core/Sharp/*', '~/Core/pa/ics2018/*']

    set autoread
    au FocusGained,BufEnter * :checktime
    let g:table_mode_corner='|'

    " By far, I don't know how to set spell check by default just for markdown
    " set spelllang=en_us
    " set spellfile=$HOME/Dropbox/vim/spell/en.utf-8.add

    " TODO:实际测试，这一个效果似乎没有
    let NERDTreeAutoDeleteBuffer = 1
    set hidden

    " Automatically start language servers.
    " let g:LanguageClient_autoStart = 1
    " let g:LanguageClient_serverCommands = {
        " \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
        " \ }

    " nnoremap gD :call LanguageClient_contextMenu()<CR>
    " Or map each action separately
    " nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
    " nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
    " nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

    " 暂时添加，用于查找被git忽略的文件
    let g:Lf_UseVersionControlTool = 0
    let g:bookmark_no_default_key_mappings = 1
endf


func! myspacevim#after() abort
    "autosave
    let g:auto_save = 1  " enable AutoSave on Vim startup
    let g:auto_save_no_updatetime = 1   " do not change the 'updatetime' option
    let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
    let g:auto_save_silent = 1  " do not display the auto-save notification

    " 使用leaderF 替代tagbar 的功能
    " nnoremap <F2> :LeaderfFunction!<CR>
    " 使用GtagsCursor 代替ctags的功能
    nnoremap <F4> :GundoToggle<CR>
    nnoremap <F6> :Gtags -r<CR>
    nnoremap <F7> :call QuickRun()<CR>

    " FIXME wait for the plugin to update or just choose another plugin
    func! GtagsSearch()
      exec "GtagsCursor"
      exec "cd ."
    endf

    map <C-]> : call GtagsSearch() <CR>
    "设置debug 选中
    nnoremap <F8> :gdbgui

    nnoremap <silent> <Up> :cp<CR>
    nnoremap <silent> <Down> :cn<CR>


    nnoremap <silent> <Leader>mm :<C-u>BookmarkToggle<Cr>
    nnoremap <silent> <Leader>mi :<C-u>BookmarkAnnotate<Cr>
    nnoremap <silent> <Leader>ma :<C-u>BookmarkShowAll<Cr>
    nnoremap <silent> <Leader>mn :<C-u>BookmarkNext<Cr>
    nnoremap <silent> <Leader>mp :<C-u>BookmarkPrev<Cr>

    "set foldmethod
    set foldmethod=syntax
    set nofoldenable
endf
