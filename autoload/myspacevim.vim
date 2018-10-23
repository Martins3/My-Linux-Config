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

  "cscope的自动链接数据库
  if has("cscope")
    set csprg=/usr/bin/cscope
    set csto=1
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    set csverb
  endif

  "将默认的2 tab的缩进修改为 4 tab 缩进
  let g:spacevim_default_indent = 4


  "关闭智障的自动报错的窗口，暂时启用YCM 的效果
  let g:spacevim_lint_on_save = 0
  " let g:neomake_open_list = get(g:, 'neomake_open_list', 0)

  " 暂时不知道和deoplete的关系
  " 这一个东西真的烦人，　ycm的开启导致　原来的补全失效
  " neomake 和 YCM　的功能似乎冲突，显然自动补全的部分功能没有处理啊

  " 使用ycm实现对于c++的自动补全
  let g:spacevim_enable_ycm = 1
  let g:ycm_global_ycm_extra_conf = '~/.SpaceVim.d/.ycm_extra_conf.py'
  let g:spacevim_snippet_engine = 'ultisnips'

  " seems to be useless
  let g:spacevim_windows_smartclose = 'q'

  " more smart undo than ctrl-R
  nnoremap <F4> :GundoToggle<CR>
  " 开启保存 undo 历史功能, 此功能与 QucikRun　函数相冲突
  " set undofile
  " set undodir=~/.SpaceVim.d/.undo_history

  " warp line
  " set nowrap
  " nnoremap <F5> :set wrap! wrap?<CR>
  " SPC t W 就可以实现，没有必要使用

  " 默认没有linenum
  " 删除文件时自动删除文件对应 buffer
  " set nonu
  let NERDTreeAutoDeleteBuffer=1

endf


func! myspacevim#after() abort
  "autosave
  let g:auto_save = 1  " enable AutoSave on Vim startup
  let g:auto_save_no_updatetime = 1   " do not change the 'updatetime' option
  let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
  let g:auto_save_silent = 1  " do not display the auto-save notification
endf
