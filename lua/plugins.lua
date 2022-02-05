vim.cmd("packadd packer.nvim")

require("packer").startup({
  function(use)
    -- it is recommened to put impatient.nvim before any other plugins
    use {'lewis6991/impatient.nvim', config = [[require('impatient')]]}

    use({"wbthomason/packer.nvim", opt = true})
    use {'neoclide/coc.nvim', branch = 'release'}
    -- 快速编辑 markdown 的表格
    use 'dhruvasagar/vim-table-mode'
    -- 更加美观的 tagbar
    use 'liuchengxu/vista.vim'
    -- 更加方便的调节窗口的大小
    use 'simeji/winresizer'
    -- 为 c/cpp 提供基于 lsp 的高亮
    use 'jackguo380/vim-lsp-cxx-highlight'
    -- 从 http://cplusplus.com/ 和 http://cppreference.com/ 获取文档
    use 'skywind3000/vim-cppman'
    -- 利用 git blame 显示当前行的 commit message
    use 'rhysd/git-messenger.vim'
    -- 以悬浮窗口的形式打开终端
    use 'voldikss/vim-floaterm'
    -- 显示搜索的标号
    use 'google/vim-searchindex.git'
    -- 安装公共的的 snippets
    use 'honza/vim-snippets'
    -- 很多 lua 插件依赖的库
    use 'nvim-lua/plenary.nvim'
    -- 安装 telescope 来实现搜索
    use 'nvim-telescope/telescope.nvim'
    -- 使用 telescope 来搜索 coc 提供的符号
    use 'fannheyward/telescope-coc.nvim'
    -- telescope 搜索的插件，可以提升搜索效率
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    -- neovim 0.5 的关键新特性，实现更好的高亮
    use 'nvim-treesitter/nvim-treesitter'
    -- 虽然 spacevim 内置了 filetree，但是这一个是最好用的
    use 'kyazdani42/nvim-tree.lua'
    -- 用于文件树等插件的图标
    use 'kyazdani42/nvim-web-devicons'
    -- 在 neovim 中使用 github cli
    use 'pwntester/octo.nvim'
    -- 媲美 vscode 的多文件替换
    use 'windwp/nvim-spectre'
    -- git 管理
    use 'tpope/vim-fugitive'
    -- 自动括号匹配
    use 'windwp/nvim-autopairs'
    -- 搜索 bookmarks
    use 'dhruvmanila/telescope-bookmarks.nvim'
    use 'MattesGroeger/vim-bookmarks'
    use 'akinsho/bufferline.nvim'
    use 'norcalli/nvim-colorizer.lua'
    use 'goolord/alpha-nvim'
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
    -- markdown 预览
    use({ "iamcco/markdown-preview.nvim", ft = "markdown", run = "cd app && yarn install" })
    use 'kazhala/close-buffers.nvim'
    use 'tpope/vim-commentary'
    -- 颜色主题
    use 'folke/tokyonight.nvim'
    use 'morhetz/gruvbox'
  end,
})
