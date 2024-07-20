local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local function is_martins3()
  local root = vim.fn.system("whoami")
  root = root:sub(1, -2)
  return vim.fn.system("whoami") == "martins3\n"
end

-- FIXME windows 和 mac 也许不可以使用这个方法
local function is_graphic_mode()
  local exit = os.execute("ls " .. os.getenv("HOME") .. "/Pictures/")
  return exit == 0
end

require("lazy").setup({
  -- 基础
  "nvim-lua/plenary.nvim", -- 很多 lua 插件依赖的库
  "kyazdani42/nvim-web-devicons", -- 显示图标
  "folke/which-key.nvim", -- 用于配置和提示快捷键
  "kkharji/sqlite.lua", -- 数据库
  "MunifTanjim/nui.nvim", -- 图形库

  -- 补全
  { "hrsh7th/nvim-cmp" }, -- The completion plugin
  { "hrsh7th/cmp-buffer" }, -- buffer completions
  { "hrsh7th/cmp-path" }, -- path completions
  { "saadparwaiz1/cmp_luasnip" }, -- snippet completions
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },
  { "hrsh7th/cmp-cmdline" },
  { "octaltree/cmp-look" }, -- 利用 nvim/10k.txt 来补全输入

  -- 代码段
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
  },

  -- lsp
  { "neovim/nvim-lspconfig" }, -- enable LSP
  { "williamboman/mason.nvim" }, -- simple to use language server installer
  { "williamboman/mason-lspconfig.nvim" },
  { "nvimtools/none-ls.nvim" }, -- for formatters and linters
  { "j-hui/fidget.nvim", tag = "legacy" },
  { "SmiteshP/nvim-navic" }, -- 在 winbar 展示当前的路径
  { "utilyre/barbecue.nvim" },
  { "kosayoda/nvim-lightbulb" }, -- 右下角展示索引的进度

  --treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  "RRethy/nvim-treesitter-textsubjects",
  "nvim-treesitter/nvim-treesitter-textobjects",
  {
    "cshuaimin/ssr.nvim",
    module = "ssr",
    vim.keymap.set({ "n", "x" }, "<leader>r", function()
      require("ssr").open()
    end),
  }, -- 结构化查询和替换

  -- ui
  "stevearc/aerial.nvim", -- 导航栏
  "kyazdani42/nvim-tree.lua", -- 文件树
  "akinsho/bufferline.nvim", -- buffer
  "nvim-lualine/lualine.nvim", -- 状态栏
  "kazhala/close-buffers.nvim", -- 一键删除不可见 buffer
  { "axkirillov/hbac.nvim", event = "SessionLoadPost", opts = {} }, -- 自动删除长期不用的 buffer
  "gelguy/wilder.nvim", -- 更加智能的命令窗口
  "romgrk/fzy-lua-native", -- wilder.nvim 的依赖
  "xiyaowong/nvim-transparent", -- 可以移除掉背景色，让 vim 透明
  -- 颜色主题
  "folke/tokyonight.nvim",
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- git 管理
  "tpope/vim-fugitive", -- 显示 git blame，实现一些基本操作的快捷执行
  "rhysd/git-messenger.vim", -- 利用 git blame 显示当前行的 commit message
  "lewis6991/gitsigns.nvim", -- 显示改动的信息
  "f-person/git-blame.nvim", -- 显示 git blame 信息
  -- 基于 telescope 的搜索
  "nvim-telescope/telescope.nvim",
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function()
      return vim.fn.executable("make") == 1
    end,
  },
  "nvim-telescope/telescope-frecency.nvim", -- 查找最近打开的文件
  -- 命令执行
  "voldikss/vim-floaterm", -- 终端
  "akinsho/toggleterm.nvim", -- 性能好点，但是易用性和稳定性都比较差
  "CRAG666/code_runner.nvim", -- 一键运行代码
  "samjwill/nvim-unception", -- 嵌套 nvim 自动 offload 到 host 中
  -- markdown
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview" },
    ft = { "markdown" },
    build = "cd app && npm install",
  },
  -- 如果发现插件有问题， 可以进入到 ~/.local/share/nvim/lazy/markdown-preview.nvim/app && npm install
  "mzlogin/vim-markdown-toc", -- 自动目录生成
  "dhruvasagar/vim-table-mode", -- 快速编辑 markdown 的表格
  -- 高效编辑
  "tpope/vim-commentary", -- 快速注释代码
  "kylechui/nvim-surround", -- 快速编辑单词两侧的符号
  "tpope/vim-repeat", -- 更加强大的 `.`
  "windwp/nvim-autopairs", -- 自动括号匹配
  "mbbill/undotree", -- 显示编辑的历史记录
  "mg979/vim-visual-multi", -- 同时编辑多个位置
  "AckslD/nvim-neoclip.lua", -- 保存 macro
  "windwp/nvim-spectre", -- 媲美 vscode 的多文件替换
  {
    "cbochs/portal.nvim",
    -- Optional dependencies
    dependencies = {
      "cbochs/grapple.nvim",
      "ThePrimeagen/harpoon",
    },
  },
  -- 高亮
  "norcalli/nvim-colorizer.lua", -- 显示 #FFFFFF
  "andymass/vim-matchup", -- 高亮匹配的元素，例如 #if 和 #endif
  -- 时间管理
  "nvim-orgmode/orgmode", -- orgmode 日程管理
  -- use 'wakatime/vim-wakatime' -- 代码时间统计

  -- lsp 增强
  "jackguo380/vim-lsp-cxx-highlight", -- ccls 高亮
  "mattn/efm-langserver", -- 支持 bash
  "gbrlsnchs/telescope-lsp-handlers.nvim",
  "jakemason/ouroboros", -- quickly switch between header and source file in C/C++ project
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  -- 其他
  "ggandor/leap.nvim", -- 快速移动
  "ggandor/flit.nvim", -- 利用 leap.nvim 强化 f/F t/T

  { "crusj/bookmarks.nvim", branch = "main" }, -- 书签, 存储在 ~/.local/share/nvim/bookmarks 中
  "tyru/open-browser.vim", -- 使用 gx 打开链接, TODO 这个插件可以替换下
  {
    "keaising/im-select.nvim",
    config = function()
      require("im_select").setup()
    end,
    enabled = true
  }, -- 自动切换输入法
  { "olimorris/persisted.nvim", opts = { autoload = true } }, -- 打开 vim 的时候，自动恢复为上一次关闭的状态
  "anuvyklack/hydra.nvim", -- 消除重复快捷键，可以用于调整 window 大小等
  "azabiong/vim-highlighter", -- 高亮多个搜索内容
  "dstein64/vim-startuptime", -- 分析 nvim 启动时间
  "voldikss/vim-translator", -- 翻译
  "nacro90/numb.nvim",
  { "andrewferrier/debugprint.nvim", version = "*" }, -- 快速插入 print 来调试
  {
    "m4xshen/hardtime.nvim",
    opts = { enabled = false },
  }, -- 训练自己的 vim 习惯，默认没有开启
  {
    "allaman/emoji.nvim",
    ft = "markdown",
    opts = { enable_cmp_integration = true },
  }, -- emoji 支持
  {
    -- "martins3/rsync.nvim",
    dir = "/home/martins3/core/rsync.nvim/",
    lazy = true,
    enabled = is_martins3(),
    cmd = { "TransferInit", "TransferToggle" },
    opts = {},
  },
  "carbon-steel/detour.nvim",
  {
    "NStefan002/2048.nvim",
    cmd = "Play2048",
    config = true,
  },
  'ojroques/nvim-osc52',
  {
    "liubianshi/cmp-lsp-rimels",
    dir = "/home/martins3/core/cmp-lsp-rimels",
    -- 这个插件让正常的补全很卡
    enabled = false,
    config = function()
      local compare = require("cmp.config.compare")
      local cmp = require("cmp")
      cmp.setup({
        -- 设置排序顺序
        sorting = {
          comparators = {
            compare.sort_text,
            compare.offset,
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.kind,
            compare.length,
            compare.order,
          },
        },
      })

      require("rimels").setup({
        keys = { start = "jk", stop = "jh", esc = ";j", undo = ";u" },
        cmd = { "/home/martins3/.cargo/bin/rime_ls" },
        rime_user_dir = "/home/martins3/.local/share/rime-ls",
        shared_data_dir = "/home/martins3/.local/share/fcitx5/rime",
        filetypes = { "NO_DEFAULT_FILETYPES" },
        single_file_support = true,
        settings = {},
        docs = {
          description = [[https://www.github.com/wlh320/rime-ls, A language server for librime]],
        },
        max_candidates = 9,
        trigger_characters = {},
        schema_trigger_character = "&", -- [since v0.2.0] 当输入此字符串时请求补全会触发 “方案选单”
        probes = {
          ignore = {},
          using = {},
          add = {},
        },
        detectors = {
          with_treesitter = {},
          with_syntax = {},
        },
        cmp_keymaps = {
          disable = {
            space = false,
            numbers = false,
            enter = false,
            brackets = false,
            backspace = false,
          },
        },
      })
    end,
  },
}, {})
