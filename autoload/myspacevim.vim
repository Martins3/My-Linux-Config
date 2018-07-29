func! myspacevim#before() abort

  "实现一键运行
  func! QuickRun()
    echo "fuck"
    exec "w"
    let ext = expand("%:e")

    if ext ==# "sh"
      exec "! ./%"
    endif
  endf
  noremap<F7> : call QuickRun()<CR>
endf


func! myspacevim#after() abort

endf
