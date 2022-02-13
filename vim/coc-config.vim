call coc#config("git.addGBlameToVirtualText", v:true)
call coc#config("git.virtualTextPrefix", "👋 ")

call coc#config("smartf.jumpOnTrigger", v:false)
call coc#config("smartf.wordJump", v:false)

" https://github.com/fannheyward/coc-pyright/issues/184
call coc#config("python.pythonPath", "/bin/python3")

call coc#config("codeLens.enable", v:false)

call coc#config('coc.preferences', {
      \ "autoTrigger": "always",
      \ "maxCompleteItemCount": 10,
      \ "codeLens.enable": 1,
      \ "diagnostic.virtualText": 1,
      \})

" c/c++ language server 设置
call coc#config("languageserver", {
      \"ccls": {
      \  "command": "ccls",
      \  "filetypes": ["c", "cpp"],
      \  "rootPatterns": ["compile_commands.json", ".git/"],
      \  "index": {
      \     "threads": 0
      \  },
      \  "initializationOptions": {
      \     "cache": {
      \       "directory": ".ccls-cache"
      \     },
      \     "highlight": { "lsRanges" : v:true }
      \   },
      \  "client": {
      \    "snippetSupport": v:true
      \   }
      \},
      \})

" Undefined global `vim` problem, see
" https://github.com/josa42/coc-lua/issues/55

" 使用 shellcheck 可以让 shell 自动补全，格式化和静态检查
call coc#config("diagnostic-languageserver.filetypes", {
      \"sh": "shellcheck",
      \})

call coc#config("diagnostic-languageserver.formatFiletypes",{
      \"sh": "shfmt",
      \})

call coc#config("translator.engines", ["youdao"])

" coc.nvim 插件，用于支持 python java 等语言
let s:coc_extensions = [
      \ 'coc-pyright',
      \ 'coc-css',
      \ 'coc-html',
      \ 'coc-word',
      \ 'coc-cmake',
      \ 'coc-dictionary',
      \ 'coc-rust-analyzer',
      \ 'coc-vimlsp',
      \ 'coc-ci',
      \ 'coc-snippets',
      \ 'coc-smartf',
      \ 'coc-go',
      \ 'coc-sh',
      \ 'coc-diagnostic',
      \ 'coc-lua',
      \ 'coc-xml',
      \ 'coc-git',
      \ 'coc-translator',
      \]

" coc-vimtex
for extension in s:coc_extensions
  call coc#add_extension(extension)
endfor
