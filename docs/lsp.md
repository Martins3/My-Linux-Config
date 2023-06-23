# 一些 native lsp 的资源

显然，lsp 的易用还没有到 coc.nvim 的程度。

- https://github.com/kosayoda/nvim-lightbulb : 左边搞个灯泡，可以永远展示可用的代码提示，类似 VSCode 中的

- https://github.com/neovim/nvim-lspconfig : 基础
- https://github.com/LunarVim/Neovim-from-scratch : 教学入门
- https://github.com/williamboman/mason.nvim

- https://github.com/glepnir/lspsaga.nvim : 提升体验
- [ ] https://github.com/ray-x/lsp_signature.nvim

- [ ] https://github.com/hrsh7th/nvim-cmp

- [ ] https://github.com/NvChad/NvChad

- [ ] https://github.com/folke/lsp-trouble.nvim
- [ ] https://github.com/simrat39/symbols-outline.nvim


- https://crispgm.com/page/neovim-is-overpowering.html
- https://github.com/SmiteshP/nvim-navic
- https://github.com/bushblade/nvim : Moving from CoC to native LSP in nvim 0.5
- https://github.com/SmiteshP/nvim-navic : 类似 VsCode 的将当前的信息显示到 winbar 中，但是依赖 lspconfig
- [ ] https://github.com/williamboman/nvim-lsp-installer/discussions/876 lsp-installer 插件发生改变，看来 native lsp 还是在演进的。


- [x] https://github.com/hrsh7th/nvim-compe

## 有些插件只是支持 native lsp 的
- https://github.com/SmiteshP/nvim-navic : 显示当前在什么函数中间
- https://github.com/simrat39/symbols-outline.nvim
- https://github.com/nix-community/nixd/blob/main/docs/editor-setup.md
- https://github.com/scalameta/nvim-metals/discussions/39 : 这个插件将 coc 切换为原生的了，如果这种事情继续发生，那么就只能切换成为原生的 lsp 了。

## lua 学习
- :help lua-guide

## coc 的 option

```plain
local options = {
  backup = false,                          -- creates a backup file
  clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  cmdheight = 2,                           -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0,                        -- so that `` is visible in markdown files
  fileencoding = "utf-8",                  -- the encoding written to a file
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  mouse = "a",                             -- allow the mouse to be used in neovim
  pumheight = 10,                          -- pop up menu height
  showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2,                         -- always show tabs
  smartcase = true,                        -- smart case
  smartindent = true,                      -- make indenting smarter again
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  swapfile = false,                        -- creates a swapfile
  -- termguicolors = true,                    -- set term gui colors (most terminals support this)
  timeoutlen = 300,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                         -- enable persistent undo
  updatetime = 300,                        -- faster completion (4000ms default)
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  tabstop = 2,                             -- insert 2 spaces for a tab
  cursorline = true,                       -- highlight the current line
  number = true,                           -- set numbered lines
  relativenumber = false,                  -- set relative numbered lines
  numberwidth = 4,                         -- set number column width to 2 {default 4}

  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  wrap = true,                             -- display lines as one long line
  linebreak = true,                        -- companion to wrap, don't split words
  scrolloff = 8,                           -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 8,                       -- minimal number of screen columns either side of cursor if wrap is `false`
  guifont = "monospace:h17",               -- the font used in graphical neovim applications
  whichwrap = "bs<>[]hl",                  -- which "horizontal" keys are allowed to travel to prev/next line
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- vim.opt.shortmess = "ilmnrx"                        -- flags to shorten vim messages, see :help 'shortmess'
vim.opt.shortmess:append "c"                           -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append "-"                           -- hyphenated words recognized by searches
vim.opt.formatoptions:remove({ "c", "r", "o" })        -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")  -- separate vim plugins from neovim in case vim still in use
```


require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

https://github.com/ranjithshegde/ccls.nvim

- 太酷了: https://github.com/gbrlsnchs/telescope-lsp-handlers.nvim
  - 似乎可以移除掉一些奇怪的 workaround 了
