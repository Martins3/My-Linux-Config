local vim = vim
-- ensure that packer is installed
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.api.nvim_command('packadd packer.nvim')
end
vim.cmd('packadd packer.nvim')
local packer = require 'packer'
local util = require 'packer.util'
packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

require("packer").startup({
  function(use)
    use { 'lewis6991/impatient.nvim', config = [[require('impatient')]] }
    use({ "wbthomason/packer.nvim", opt = true })
    -- 基础
    use 'nvim-lua/plenary.nvim' -- 很多 lua 插件依赖的库
    use { 'neoclide/coc.nvim', branch = 'release' } -- lsp
    use 'kyazdani42/nvim-web-devicons' -- 显示图标
    use 'folke/which-key.nvim' -- 用于配置和提示快捷键
    use 'tami5/sqlite.lua' -- 数据库
    -- treesitter
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } -- 基于语法树的高亮
    use 'RRethy/nvim-treesitter-textsubjects'
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'lewis6991/spellsitter.nvim' -- 当检查拼写的时候，仅仅检查注释
    -- ui
    use 'liuchengxu/vista.vim' -- 导航栏
    use 'kyazdani42/nvim-tree.lua' -- 文件树
    use 'mhinz/vim-startify' -- 启动界面
    use 'vim-airline/vim-airline' -- 状态栏
    use 'vim-airline/vim-airline-themes' -- 状态栏的主题
    use 'akinsho/bufferline.nvim' -- buffer
    use 'kazhala/close-buffers.nvim' -- 一键删除不可见 buffer
    use 'gelguy/wilder.nvim' -- 更加智能的命令窗口
    use 'romgrk/fzy-lua-native' -- wilder.nvim 的依赖
    use 'xiyaowong/nvim-transparent' -- 可以移除掉背景色，让 vim 透明
    -- 颜色主题
    use 'folke/tokyonight.nvim'
    -- git 管理
    use 'tpope/vim-fugitive' -- 显示 git blame，实现一些基本操作的快捷执行
    use 'rhysd/git-messenger.vim' -- 利用 git blame 显示当前行的 commit message
    use 'lewis6991/gitsigns.nvim' -- 显示改动的信息
    -- 基于 telescope 的搜索
    use 'nvim-telescope/telescope.nvim'
    use { 'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make' } -- telescope 搜索的插件，可以提升搜索效率
    use 'fannheyward/telescope-coc.nvim' -- 搜索 coc 提供的符号
    use 'dhruvmanila/telescope-bookmarks.nvim' -- 搜索 bookmarks
    -- 命令执行
    use 'voldikss/vim-floaterm' -- 以悬浮窗口的形式打开终端
    use 'CRAG666/code_runner.nvim' -- 一键运行代码
    -- markdown
    use({ "iamcco/markdown-preview.nvim", ft = "markdown",
      run = "cd app && yarn install" }) -- 预览
    use 'mzlogin/vim-markdown-toc' -- 自动目录生成
    use 'dhruvasagar/vim-table-mode' -- 快速编辑 markdown 的表格
    use 'crispgm/telescope-heading.nvim' -- Telescope coc 没有 outline，所以只好使用这个
    use 'tpope/vim-markdown' -- markdown 语法高亮
    use 'xiyaowong/telescope-emoji.nvim' -- 使用 telescope 搜索 emoji 表情
    -- 高效编辑
    use 'tpope/vim-commentary' -- 快速注释代码
    use 'kylechui/nvim-surround' -- 快速编辑单词两侧的符号
    use 'tpope/vim-sleuth' -- 自动设置 tabstop 之类的
    use 'tpope/vim-repeat' -- 更加强大的 `.`
    use 'windwp/nvim-autopairs' -- 自动括号匹配
    use 'honza/vim-snippets' -- 安装公共的的 snippets
    use 'mbbill/undotree' -- 显示编辑的历史记录
    use 'mg979/vim-visual-multi' -- 同时编辑多个位置
    use 'AckslD/nvim-neoclip.lua' -- 保存 macro
    use 'windwp/nvim-spectre' -- 媲美 vscode 的多文件替换
    -- 快速移动
    use 'ggandor/lightspeed.nvim'
    -- c/c++
    use 'jackguo380/vim-lsp-cxx-highlight' -- 为 c/cpp 提供基于 lsp 的高亮
    use 'skywind3000/vim-cppman' -- http://cplusplus.com/ 和 http://cppreference.com/ 获取文档
    -- 书签
    use 'MattesGroeger/vim-bookmarks'
    use 'tom-anders/telescope-vim-bookmarks.nvim' -- 辅助书签的搜索
    -- 高亮
    use 'norcalli/nvim-colorizer.lua' -- 显示 #FFFFFF
    use 'andymass/vim-matchup' -- 高亮匹配的元素，例如 #if 和 #endif
    -- 时间管理
    use 'nvim-orgmode/orgmode' -- orgmode 日程管理
    -- latex
    use 'lervag/vimtex'
    -- 其他
    use 'CoatiSoftware/vim-sourcetrail' -- sourcetrail 插件
    use 'tyru/open-browser.vim' -- 使用 gx 打开链接
    use 'martins3/fcitx.nvim' -- 自动切换输入法
    use 'rmagatti/auto-session' -- 打开 vim 的时候，自动回复上一次打开的样子
    use 'anuvyklack/hydra.nvim' -- 消除重复快捷键，可以用于调整 window 大小等
    -- use 'inkarkat/vim-mark' --- 高亮多个搜索的内容 @todo 暂时安装不上
    use 'ojroques/vim-oscyank' -- 让 nvim 在远程 server 上拷贝到本地剪切板上
  end,
})
