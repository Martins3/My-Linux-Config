func! myspacevim#before() abort

  "实现一键运行
  func! QuickRun()
    exec "w"
    let ext = expand("%:e")
    if ext ==# "sh"
      exec "! ./%"
    elseif ext ==# "cpp"
      exec "!clang++ % -Wall -g -std=c++14 -o %<.out && ./%<.out"
    endif
  endf
  noremap<F7> : call QuickRun()<CR>

  "根据当前文件自动修改pwd
  set autochdir

  "change leader
  "在spaveVim中间‘，’还有其他的用途，可以将\ 和 , 加以调换
  let mapleader = ','
  let g:mapleader = ','

  "设置neomake的内容
  let g:neomake_cpp_enable_markers=['clang']
  let g:neomake_cpp_clang_args = ["-std=c++14"]

  


  "nerdtree隐藏不可编辑文件
  let g:NERDTreeIgnore=['\.o$', '\.out$']

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

  "关闭智障的自动报错， 尚且没有办法完成
  let g:spacevim_lint_on_save = 1

  " 使用ycm实现对于c++的自动补全
  let g:spacevim_enable_ycm = 1
  let g:ycm_global_ycm_extra_conf = '~/.SpaceVim.d/.ycm_extra_conf.py'


endf


func! myspacevim#after() abort
  "autosave
  let g:auto_save = 1  " enable AutoSave on Vim startup
  let g:auto_save_no_updatetime = 1  " do not change the 'updatetime' option
  let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
  let g:auto_save_silent = 1  " do not display the auto-save notification
endf
