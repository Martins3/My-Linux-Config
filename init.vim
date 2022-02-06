" ref: https://github.com/jdhao/nvim-config
let s:core_conf_files = [
      \ 'core.vim',
      \ 'coc.vim',
      \ 'coc-config.vim',
      \ 'debug.vim',
      \ 'ccls.vim',
      \ ]

for s:fname in s:core_conf_files
  execute printf('source %s/core/%s', stdpath('config'), s:fname)
endfor
