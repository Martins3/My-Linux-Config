" coc.nvim 的配置, 来自于 https://github.com/neoclide/coc.nvim

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

autocmd FileType python let b:coc_root_patterns = ['.git']

" 使用 f/F 快速跳转一个字符上
call coc#config("smartf.wordJump", v:false)
call coc#config("smartf.jumpOnTrigger", v:false)

augroup Smartf
  autocmd User SmartfEnter :hi Conceal ctermfg=220 guifg=pink
  autocmd User SmartfLeave :hi Conceal ctermfg=239 guifg=#504945
augroup end

" 方便在中文中间使用 w 和 b 移动
nmap <silent> w <Plug>(coc-ci-w)
nmap <silent> b <Plug>(coc-ci-b)

" 来自 https://github.com/neoclide/coc-snippets 的配置 snippet
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use Tap for trigger snippet expand.
let g:coc_snippet_next = '<tab>'

" rust-analyzer 需要手动下载配置
" https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary
call coc#config("rust-analyzer.serverPath", "~/.cargo/bin/rust-analyzer")

call coc#config("codeLens.enable", v:true)

call coc#config('coc.preferences', {
			\ "autoTrigger": "always",
			\ "maxCompleteItemCount": 10,
			\ "codeLens.enable": 1,
			\ "diagnostic.virtualText": 1,
			\})

call coc#config(
      \'explorer', {
      \   "position": "floating",
      \   "floating.width": "150",
      \   "git.showIgnored": v:false,
      \   "openAction.strategy": "previousWindow",
      \   "keyMappings.global": {
      \     "<tab>": v:false,
      \     "yy": "copyFilepath",
      \     "d": "deleteForever",
      \},
      \ "icon.enableNerdfont": v:true,
  \})

call SpaceVim#custom#SPC('nnoremap', ['f', 'o'], "CocCommand explorer --reveal", 'open file explorer', 1)

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

call coc#config("git.addGBlameToVirtualText", v:true)
call coc#config("git.virtualTextPrefix", "👋 ")

" 使用 shellcheck 可以让 shell 自动补全，格式化和静态检查
call coc#config("diagnostic-languageserver.filetypes", {
      \"sh": "shellcheck",
      \})

call coc#config("diagnostic-languageserver.formatFiletypes",{
      \"sh": "shfmt",
      \})

" coc.nvim 插件，用于支持 python java 等语言
let s:coc_extensions = [
			\ 'coc-pyright',
      \ 'coc-explorer',
			\ 'coc-java',
      \ 'coc-css',
      \ 'coc-html',
      \ 'coc-word',
      \ 'coc-cmake',
      \ 'coc-dictionary',
      \ 'coc-rust-analyzer',
      \ 'coc-vimlsp',
      \ 'coc-ci',
      \ 'coc-snippets',
      \ 'coc-vimtex',
      \ 'coc-smartf',
      \ 'coc-go',
      \ 'coc-sh',
      \ 'coc-git',
      \ 'coc-diagnostic',
      \ 'coc-lua',
      \ 'coc-xml',
			\]

for extension in s:coc_extensions
	call coc#add_extension(extension)
endfor

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <silent> <nowait> gd : <C-u>Telescope coc definitions<cr>
nmap <silent> <nowait> gh : <C-u>Telescope coc declarations<cr>
nmap <silent> <nowait> gy : <C-u>Telescope coc type_definitions<cr>
nmap <silent> <nowait> gi : <C-u>Telescope coc implementations<cr>
nmap <silent> <nowait> gr : <C-u>Telescope coc references<cr>

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
set updatetime=300
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>k  <Plug>(coc-format-selected)
nmap <leader>k  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Use `:Format` for format current buffer
" command! -nargs=0 Format :call CocAction('format')
call SpaceVim#custom#SPC('nnoremap', ['r', 'f'], "call CocAction('format')", 'format file with coc.nvim', 1)

" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Search code action.
nnoremap <silent><nowait> <leader>a  :<C-u>Telescope coc code_actions<cr>
" Show buffers
nnoremap <silent><nowait> <leader>b  :<C-u>Telescope buffers prompt_prefix=🔍<cr>
" Show commands.
nnoremap <silent><nowait> <leader>c  :<C-u>Telescope coc commands<cr>
" Show all diagnostics.
nnoremap <silent><nowait> <leader>d  :<C-u>Telescope coc workspace_diagnostics<cr>
" Show colorscheme
nnoremap <silent><nowait> <leader>e  :<C-u>Telescope colorscheme<cr>
" Show files
nnoremap <silent><nowait> <leader>f  :<C-u>Telescope find_files prompt_prefix=🔍<cr>
" Live grep
nnoremap <silent><nowait> <leader>g  :<C-u>Telescope live_grep<cr>
" Search help
nnoremap <silent><nowait> <leader>h  :<C-u>Telescope help_tags<cr>
nnoremap <silent><nowait> <leader>i  :<C-u>Octo issue list<cr>
" FIXME 这是唯一一个还需要使用 CocFzfList 的位置
" 因为使用 Telescope 无法在 markdown 中预览
" Find symbol of current document.
" nnoremap <silent><nowait> <leader>o  :<C-u>Telescope coc document_symbols<cr>
nnoremap <silent><nowait> <leader>o  :<C-u>CocFzfList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>s  :<C-u>Telescope coc workspace_symbols<cr>
nnoremap <silent><nowait> <leader>m  :<C-u>Telescope man_pages<cr>

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>x  <Plug>(coc-codeaction-selected)
nmap <leader>x  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>lc  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" 下面是 ccls 提供的 LSP Extension
" https://github.com/MaskRay/ccls/wiki/coc.nvim

nn <silent> xl :call CocLocations('ccls','$ccls/navigate',{'direction':'D'})<cr>
nn <silent> xk :call CocLocations('ccls','$ccls/navigate',{'direction':'L'})<cr>
nn <silent> xj :call CocLocations('ccls','$ccls/navigate',{'direction':'R'})<cr>
nn <silent> xh :call CocLocations('ccls','$ccls/navigate',{'direction':'U'})<cr>

noremap x <Nop>
nn <silent> xb :call CocLocations('ccls','$ccls/inheritance')<cr>
" bases of up to 3 levels
nn <silent> xb :call CocLocations('ccls','$ccls/inheritance',{'levels':3})<cr>
" derived
nn <silent> xd :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true})<cr>
" derived of up to 3 levels
nn <silent> xD :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true,'levels':3})<cr>

" caller
nn <silent> xc :call CocLocations('ccls','$ccls/call')<cr>
" callee
nn <silent> xC :call CocLocations('ccls','$ccls/call',{'callee':v:true})<cr>

" $ccls/member
" member variables / variables in a namespace
nn <silent> xm :call CocLocations('ccls','$ccls/member')<cr>
" member functions / functions in a namespace
nn <silent> xf :call CocLocations('ccls','$ccls/member',{'kind':3})<cr>
" nested classes / types in a namespace
nn <silent> xs :call CocLocations('ccls','$ccls/member',{'kind':2})<cr>

nmap <silent> xt <Plug>(coc-type-definition)<cr>
nn <silent> xv :call CocLocations('ccls','$ccls/vars')<cr>
nn <silent> xV :call CocLocations('ccls','$ccls/vars',{'kind':1})<cr>

nn xx x
