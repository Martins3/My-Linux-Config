" wilder 提供的配置的中照抄过来的 [^1]
" 我发现 wilder 处理对于 Man 命令的处理非常的慢，参考 [^2] 将其禁用。
"
" [^1]: https://github.com/gelguy/wilder.nvim
" [^2]: https://github.com/gelguy/wilder.nvim/issues/107
call wilder#setup({'modes': [':']})
call wilder#set_option('use_python_remote_plugin', 0)
call wilder#set_option('pipeline', [
      \   wilder#branch(
      \   [
      \     wilder#check({-> getcmdtype() ==# ':'}),
      \     {ctx, x -> wilder#cmdline#parse(x).cmd ==# 'Man' ? v:true : v:false},
      \   ],
      \     wilder#cmdline_pipeline({
      \       'fuzzy': 1,
      \       'fuzzy_filter': wilder#lua_fzy_filter(),
      \     }),
      \     wilder#vim_search_pipeline(),
      \   ),
      \ ])

call wilder#set_option('renderer', wilder#renderer_mux({
      \ ':': wilder#popupmenu_renderer({
      \   'highlighter': wilder#lua_fzy_highlighter(),
      \   'left': [
      \     ' ',
      \     wilder#popupmenu_devicons(),
      \   ],
      \   'right': [
      \     ' ',
      \     wilder#popupmenu_scrollbar(),
      \   ],
      \ }),
      \ '/': wilder#wildmenu_renderer({
      \   'highlighter': wilder#lua_fzy_highlighter(),
      \ }),
      \ }))
