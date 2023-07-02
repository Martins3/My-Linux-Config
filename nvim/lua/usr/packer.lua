local vim = vim
-- ensure that packer is installed
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
  vim.api.nvim_command("packadd packer.nvim")
end
vim.cmd("packadd packer.nvim")
local packer = require("packer")
local util = require("packer.util")
packer.init({
  package_root = util.join_paths(vim.fn.stdpath("data"), "site", "pack"),
})

require("packer").startup({
  function(use)
    use({ "lewis6991/impatient.nvim", config = [[require('impatient')]] })
    use({ "wbthomason/packer.nvim", opt = true })
    -- 基础
    use("nvim-lua/plenary.nvim")        -- 很多 lua 插件依赖的库
    use("kyazdani42/nvim-web-devicons") -- 显示图标
    use("folke/which-key.nvim")         -- 用于配置和提示快捷键
    use("kkharji/sqlite.lua")           -- 数据库

    -- Cmp
    use({ "hrsh7th/nvim-cmp" })         -- The completion plugin
    use({ "hrsh7th/cmp-buffer" })       -- buffer completions
    use({ "hrsh7th/cmp-path" })         -- path completions
    use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
    use({ "hrsh7th/cmp-nvim-lsp" })
    use({ "hrsh7th/cmp-nvim-lua" })

    -- Snippets
    use({ "L3MON4D3/LuaSnip" })             --snippet engine
    use({ "rafamadriz/friendly-snippets" }) -- a bunch of snippets to use

    -- LSP
    use({ "neovim/nvim-lspconfig" })           -- enable LSP
    use({ "williamboman/mason.nvim" })         -- simple to use language server installer
    use({ "williamboman/mason-lspconfig.nvim" })
    use({ "jose-elias-alvarez/null-ls.nvim" }) -- for formatters and linters
    use({ "j-hui/fidget.nvim", branch = "legacy" })
    use({ "SmiteshP/nvim-navic" })
    use("utilyre/barbecue.nvim")
    use({ "kosayoda/nvim-lightbulb" })

    -- treesitter
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }) -- 基于语法树的高亮
    use("RRethy/nvim-treesitter-textsubjects")
    use("nvim-treesitter/nvim-treesitter-textobjects")
    use({
      "cshuaimin/ssr.nvim",
      module = "ssr",
      vim.keymap.set({ "n", "x" }, "<leader>r", function()
        require("ssr").open()
      end),
    }) -- 结构化查询和替换

    -- ui
    use("simrat39/symbols-outline.nvim")
    use("liuchengxu/vista.vim")               -- 导航栏
    use("kyazdani42/nvim-tree.lua")           -- 文件树
    use("mhinz/vim-startify")                 -- 启动界面
    use("akinsho/bufferline.nvim")            -- buffer
    use("nvim-lualine/lualine.nvim")          -- 状态栏
    use("kazhala/close-buffers.nvim")         -- 一键删除不可见 buffer
    use("gelguy/wilder.nvim")                 -- 更加智能的命令窗口
    use("romgrk/fzy-lua-native")              -- wilder.nvim 的依赖
    use("xiyaowong/nvim-transparent")         -- 可以移除掉背景色，让 vim 透明
    -- 颜色主题
    use("folke/tokyonight.nvim")
    use({ "catppuccin/nvim", as = "catppuccin" })
    -- git 管理
    use("tpope/vim-fugitive")      -- 显示 git blame，实现一些基本操作的快捷执行
    use("rhysd/git-messenger.vim") -- 利用 git blame 显示当前行的 commit message
    use("lewis6991/gitsigns.nvim") -- 显示改动的信息
    -- 基于 telescope 的搜索
    use("nvim-telescope/telescope.nvim")
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })      -- telescope 搜索的插件，可以提升搜索效率
    use("dhruvmanila/telescope-bookmarks.nvim")                            -- 搜索 bookmarks
    use("nvim-telescope/telescope-frecency.nvim")                          -- 查找最近打开的文件
    -- 命令执行
    use("voldikss/vim-floaterm")                                           -- 终端
    use("akinsho/toggleterm.nvim")                                         -- 性能好点，但是易用性和稳定性都比较差
    use("CRAG666/code_runner.nvim")                                        -- 一键运行代码
    use("samjwill/nvim-unception")                                         -- 嵌套 nvim 自动 offload 到 host 中
    -- markdown
    use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install" }) -- 预览
    -- 如果 markdown-preview.nvim 安装有问题，可以尝试
    -- 进入到 ~/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim 中手动执行 cd app && npm install
    use("mzlogin/vim-markdown-toc")       -- 自动目录生成
    use("dhruvasagar/vim-table-mode")     -- 快速编辑 markdown 的表格
    use("xiyaowong/telescope-emoji.nvim") -- 使用 telescope 搜索 emoji 表情
    -- 高效编辑
    use("tpope/vim-commentary")           -- 快速注释代码
    use("kylechui/nvim-surround")         -- 快速编辑单词两侧的符号
    use("tpope/vim-sleuth")               -- 自动设置 tabstop 之类的
    use("tpope/vim-repeat")               -- 更加强大的 `.`
    use("windwp/nvim-autopairs")          -- 自动括号匹配
    use("honza/vim-snippets")             -- 安装公共的的 snippets
    use("mbbill/undotree")                -- 显示编辑的历史记录
    use("mg979/vim-visual-multi")         -- 同时编辑多个位置
    use("AckslD/nvim-neoclip.lua")        -- 保存 macro
    use("windwp/nvim-spectre")            -- 媲美 vscode 的多文件替换
    -- 快速移动
    use("ggandor/leap.nvim")
    -- 书签
    use("MattesGroeger/vim-bookmarks")
    use("tom-anders/telescope-vim-bookmarks.nvim") -- 辅助书签的搜索
    -- 高亮
    use("norcalli/nvim-colorizer.lua")             -- 显示 #FFFFFF
    use("andymass/vim-matchup")                    -- 高亮匹配的元素，例如 #if 和 #endif
    -- 时间管理
    use("nvim-orgmode/orgmode")                    -- orgmode 日程管理
    -- use 'wakatime/vim-wakatime' -- 代码时间统计
    -- lsp 增强
    use("jackguo380/vim-lsp-cxx-highlight") -- ccls 高亮
    use("mattn/efm-langserver")             -- 支持 bash
    -- 其他
    use("tyru/open-browser.vim")            -- 使用 gx 打开链接
    use("keaising/im-select.nvim")              -- 自动切换输入法
    use("olimorris/persisted.nvim")         -- 打开 vim 的时候，自动回复上一次打开的样子
    use("anuvyklack/hydra.nvim")            -- 消除重复快捷键，可以用于调整 window 大小等
    use("ojroques/vim-oscyank")             -- 让 nvim 在远程 server 上拷贝到本地剪切板上
    use("azabiong/vim-highlighter")         -- 高亮多个搜索内容
    use("dstein64/vim-startuptime")         -- 分析 nvim 启动时间
    use("voldikss/vim-translator")          -- 翻译
  end,
})
