# 一些 native lsp 的资源

显然，lsp 的易用还没有到 coc.nvim 的程度。

- https://github.com/neovim/nvim-lspconfig : 基础
- https://github.com/LunarVim/Neovim-from-scratch : 教学入门

- https://github.com/williamboman/mason.nvim

- https://github.com/glepnir/lspsaga.nvim : 提升体验
- https://github.com/ray-x/lsp_signature.nvim

- [ ] https://github.com/NvChad/NvChad

- [ ] https://github.com/folke/lsp-trouble.nvim

- https://crispgm.com/page/neovim-is-overpowering.html
- https://github.com/bushblade/nvim : Moving from CoC to native LSP in nvim 0.5


## 一些老故事
- [ ] https://github.com/williamboman/nvim-lsp-installer/discussions/876 lsp-installer 插件发生改变，看来 native lsp 还是在演进的。

## 有些插件只是支持 native lsp 的
- https://github.com/simrat39/symbols-outline.nvim : 总是无法搭建起来, 继续 vista 了
- https://github.com/nix-community/nixd/blob/main/docs/editor-setup.md : nixd
- https://github.com/scalameta/nvim-metals/discussions/39 : 这个插件将 coc 切换为原生的了，如果这种事情继续发生，那么就只能切换成为原生的 lsp 了。

## lua 学习
- :help lua-guide

## mason 有意义吗?
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

## 如何让 ccls.nvim 来加强
https://github.com/ranjithshegde/ccls.nvim

## 总结下这个
- 太酷了: https://github.com/gbrlsnchs/telescope-lsp-handlers.nvim
  - 似乎可以移除掉一些奇怪的 workaround 了

## 这个没有办法完全满足要求
https://github.com/uga-rosa/cmp-dictionary/wiki/Examples-of-usage
