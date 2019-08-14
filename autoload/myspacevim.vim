func! myspacevim#before() abort
    "实现一键运行
    func! QuickRun()
        " exec "w"
        let ext = expand("%:e")
        if ext ==# "sh"
            exec "!sh %"
        elseif ext ==# "md"
            exec "!dos2unix %"
            echo "DONE"
        elseif ext ==# "cpp"
            exec "!clang++ % -Wall -pthread -O3 -g -std=c++14 -o %<.out && ./%<.out"
        elseif ext ==# "c"
            exec "!clang % -Wall -g -std=c11 -o %<.out && ./%<.out"
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

func! GoToDef()
    let ext = expand("%:e")
    if ext ==# "c" || ext ==# "cpp" || ext ==# "cpp"
      echo "begin"
      exec "GtagsCursor"
      echo "end"
    elseif ext ==# "rs"
     echo "Debug this go to def, FIXME, we don't use this function anymore"
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
        exec "!cargo run"
        exec "cd -"
        return
    endif
   let cargo_run_path = fnamemodify(cargo_run_path, ':h')
  endwhile
  echo "Cargo.toml not found !"
endf


    let g:startify_files_number = 20

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
    let g:gtags_open_list = 2


    " play piano in vim
    " set rtp+=/home/shen/vim-keysound
    " let g:keysound_py_version = 3
    " let g:keysound_enable = 0
    " let g:keysound_volume = 1000
    " let g:keysound_theme = 'drum'
    

    " rust auto fmt when save file
    " let g:rustfmt_autosave = 1

    " config the Gtags, based on jsfaint/gen_tags.vim
    " let g:gen_tags#gtags_auto_update = 1 "be carteful,Ctrl+\ t maybe we should rewrite autowrite

    " TODO: 当打开quick fix 之后自动进入quickfix界面
    autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>

    "change leader
    "在spaveVim中间‘，’还有其他的用途，可以将\ 和 , 加以调换
    let g:mapleader = ','
    let g:spacevim_windows_leader = 'c'


    " nerdtree隐藏部分类型的文件
    let g:NERDTreeIgnore=['\.o$', '\.d$', '\.sym$', '\.out$', '\.dis$', 'node_modules', '\.lock$','\.gch$', 'package.json', 'GPATH', 'GRTAGS', 'GTAGS', '\.hpp.gch$', 'compile_commands.json', '\.mod*', '\.ko', 'Module.symvers', 'modules.order', '\.so$']

    " hack the kernel
    " let g:gitgutter_max_signs = 1500


    " let g:spacevim_default_indent = 4
    " close with key m instead of q
    " let g:spacevim_windows_smartclose = 'm'

    " make Parentheses colorful
    " let g:rainbow_active = 1

    let g:spacevim_snippet_engine = 'ultisnips'

    set autoread
    au FocusGained,BufEnter * :checktime
    let g:table_mode_corner='|'

    " By far, I don't know how to set spell check by default just for markdown
    " set spelllang=en_us
    " set spellfile=$HOME/Dropbox/vim/spell/en.utf-8.add

    " TODO:实际测试，这一个效果似乎没有
    let NERDTreeAutoDeleteBuffer = 1
    set hidden

    let g:bookmark_no_default_key_mappings = 1

    augroup Binary
      au!
      au BufReadPre  *.bin let &bin=1
      au BufReadPost *.bin if &bin | %!xxd
      au BufReadPost *.bin set ft=xxd | endif
      au BufWritePre *.bin if &bin | %!xxd -r
      au BufWritePre *.bin endif
      au BufWritePost *.bin if &bin | %!xxd
      au BufWritePost *.bin set nomod | endif
    augroup END

    " copy from  https://www.zhihu.com/question/31934850/answer/379725837
    " without understand the essence.
    let g:Lf_ShowRelativePath = 0
    let g:Lf_HideHelp = 0
    let g:Lf_PreviewResult = {'Function':0, 'Colorscheme':1}

    let g:Lf_NormalMap = {
      \ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
      \ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>']],
      \ "Mru":    [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
      \ "Tag":    [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<CR>']],
      \ "Function":    [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<CR>']],
      \ "Colorscheme":    [["<ESC>", ':exec g:Lf_py "colorschemeExplManager.quit()"<CR>']],
      \ }

endf


func! myspacevim#after() abort
    "autosave
    au FocusLost * :wa
    " let g:auto_save = 1  " enable AutoSave on Vim startup
    " let g:auto_save_no_updatetime = 1   " do not change the 'updatetime' option
    " let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
    " let g:auto_save_silent = 1  " do not display the auto-save notification

    " 使用GtagsCursor 代替ctags的功能
    set autowrite
    " F1 F2, F3 分别为文档，tagbar和file tree
    nnoremap <F2> :Vista!!<CR>
    nnoremap <F4> :GundoToggle<CR>
    noremap <F5> :LeaderfFunction!<cr>
    " nnoremap <F6> :Gtags -r<CR>
    nnoremap <F7> :call QuickRun()<CR>
    " nnoremap <F8> :!gdbgui
    
    call defx#custom#option('_', {
      \ 'winwidth': 30,
      \ 'split': 'vertical',
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 0,
      \ 'buffer_name': '',
      \ 'toggle': 1,
      \ 'resume': 1
      \ })


    let g:vista_echo_cursor_strategy = 'floating_win'
    let g:vista_sidebar_position = "vertical topleft"
    " Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
    let g:vista#renderer#enable_icon = 1

    " coc下UI实在是太丑了
    " let g:vista_executive_for = {
      " \ 'c': 'coc',
    " \ }
    
    " FIXME wait for the plugin to update or just choose another plugin
    func! GtagsSearch()
      exec "GtagsCursor"
      exec "cd ."
    endf

    map <C-]> : call GtagsSearch() <CR>
    "设置debug 选中 TODO spacevim 内置的可以应该作为默认的选项

    nnoremap <silent> <Leader>mm :<C-u>BookmarkToggle<Cr>
    nnoremap <silent> <Leader>mi :<C-u>BookmarkAnnotate<Cr>
    nnoremap <silent> <Leader>ma :<C-u>BookmarkShowAll<Cr>
    nnoremap <silent> <Leader>mc :<C-u>ClearAllBookmarks<Cr>

    " remap the terminal
    tnoremap <Esc> <C-\><C-n>

    "set foldmethod
    set foldmethod=syntax
    set nofoldenable
endf
