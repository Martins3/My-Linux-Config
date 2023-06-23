" coc.nvim 的配置, 来自于 https://github.com/neoclide/coc.nvim
"
" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
" set encoding=utf-8


" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif


" GoTo code navigation.
nmap <silent> <nowait> gd : <C-u>Telescope coc definitions<cr>
nmap <silent> <nowait> gh : <C-u>Telescope coc declarations<cr>
nmap <silent> <nowait> gy : <C-u>Telescope coc type_definitions<cr>
nmap <silent> <nowait> gk : <C-u>Telescope coc implementations<cr>
nmap <silent> <nowait> gr : <C-u>Telescope coc references_used<cr>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" coc.nvim 插件，用于支持 python java 等语言
" coc-metals 时不时导致问题 #115，等到 hacking BOOM core 的时候再说吧
let s:coc_extensions = [
      \ 'coc-pyright',
      \ 'coc-css',
      \ 'coc-html',
      \ 'coc-word',
      \ 'coc-cmake',
      \ 'coc-dictionary',
      \ 'coc-rust-analyzer',
      \ 'coc-vimlsp',
      \ 'coc-snippets',
      \ 'coc-go',
      \ 'coc-sumneko-lua',
      \ 'coc-xml',
      \ 'coc-json',
      \ 'coc-yaml',
      \ 'coc-translator',
      \ 'coc-r-lsp',
      \ 'coc-vimtex',
      \ 'coc-texlab',
      \ 'coc-tsserver',
      \ 'coc-markmap',
      \]

for extension in s:coc_extensions
  call coc#add_extension(extension)
endfor

" patch for coc-sumneko-lua plugin on nixos
" for details, see https://github.com/xiyaowong/coc-sumneko-lua/issues/22
if $USERNAME == "martins3"
  call coc#config("sumneko-lua.serverDir", "/home/martins3/.nix-profile/")
  call coc#config("Lua.misc.parameters",
        \ [ "--metapath",
        \ "/home/martins3/.cache/sumneko_lua/meta",
        \ "--logpath",
        \ "/home/martins3/.cache/sumneko_lua/log"]
        \)
endif

" 方便在中文中使用 w 和 b 移动
" 安装 'coc-ci'
" nmap <silent> w <Plug>(coc-ci-w)
" nmap <silent> b <Plug>(coc-ci-b)
