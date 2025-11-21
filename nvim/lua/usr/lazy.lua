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
  { "j-hui/fidget.nvim", tag = "legacy" }, -- 右下角展示索引状态
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({
        lightbulb = {
          enable = false,
        },
        outline = {
          win_position = "left",
          win_width = 20,
          auto_preview = false,
          detail = true,
          auto_close = false,
          close_after_jump = true,
          keys = {
            toggle_or_jump = "o",
            quit = "q",
            jump = "<cr>",
          },
        },
      })
    end,
  }, -- lsp 增强，例如提供 winbar 的功能
  -- 配置文件在 https://github.com/nvimdev/lspsaga.nvim/blob/main/lua/lspsaga/init.lua
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        markdown = { "deno_fmt" },
      },
      formatters = {
        deno_fmt = {
          command = "deno",
          args = { "fmt", "--ext", "md", "-" },
          stdin = true,
        },
      },
    },
  }, -- 格式化支持

  --treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
  },
  -- "RRethy/nvim-treesitter-textsubjects",
  { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
  -- ui
  "kyazdani42/nvim-tree.lua", -- 文件树
  "akinsho/bufferline.nvim", -- buffer
  "nvim-lualine/lualine.nvim", -- 状态栏
  {
    "axkirillov/hbac.nvim",
    event = "SessionLoadPost",
    opts = {
      close_command = function(bufnr)
        if vim.bo[bufnr].buftype ~= "terminal" then
          vim.api.nvim_buf_delete(bufnr, {})
        end
      end,
    },
  }, -- 自动删除长期不用的 buffer
  "romgrk/fzy-lua-native", -- wilder.nvim 的依赖
  "xiyaowong/nvim-transparent", -- 可以移除掉背景色，让 vim 透明
  -- 颜色主题
  "folke/tokyonight.nvim",
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- git 管理
  "rhysd/git-messenger.vim", -- 利用 git blame 显示当前行的 commit message
  "tpope/vim-fugitive", -- 实现一些基本操作的快捷执行
  "lewis6991/gitsigns.nvim", -- 显示改动的信息
  {'akinsho/git-conflict.nvim', version = "*", config = true}, -- 解决 git 冲突
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
  "akinsho/toggleterm.nvim",                -- nvim 中打开终端
  "CRAG666/code_runner.nvim", -- 一键运行代码
  "samjwill/nvim-unception", -- 在 nvim 的 termianl 打开 nvim 自动 offload
  -- markdown
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  -- 如果发现插件有问题， 可以进入到 ~/.local/share/nvim/lazy/markdown-preview.nvim/app && npm install
  "mzlogin/vim-markdown-toc", -- 自动目录生成
  "dhruvasagar/vim-table-mode", -- 快速编辑 markdown 的表格
  -- 高效编辑
  "tpope/vim-commentary", -- 快速注释代码
  "kylechui/nvim-surround", -- 快速编辑单词两侧的符号
  "windwp/nvim-autopairs", -- 自动括号匹配
  "mbbill/undotree", -- 显示编辑的历史记录
  "windwp/nvim-spectre", -- 媲美 vscode 的多文件替换
  -- 高亮
  "norcalli/nvim-colorizer.lua", -- 显示 #ABCBCB
  -- 时间管理
  "nvim-orgmode/orgmode", -- orgmode 日程管理

  -- lsp 增强
  "jackguo380/vim-lsp-cxx-highlight", -- ccls 高亮
  "mattn/efm-langserver", -- 支持 bash
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
  "tyru/open-browser.vim", -- 使用 gx 打开链接
  {
    "keaising/im-select.nvim",
    config = function()
      require("im_select").setup()
    end,
    enabled = false,
  }, -- 自动切换输入法
  {
    "olimorris/persisted.nvim",
  }, -- 自动保存关闭时候的会话
  "nvimtools/hydra.nvim", -- 消除重复快捷键，可以用于调整 window 大小等
  { "andrewferrier/debugprint.nvim", version = "*" }, -- 快速插入 print 来调试
  { "xiyaowong/telescope-emoji.nvim" },
  {
    "Martins3/rsync.nvim",
    lazy = true,
    cmd = { "TransferInit", "TransferToggle" },
    opts = {},
  },

  {
    "stevearc/aerial.nvim",
    config = function()
      vim.keymap.set("n", "cn", "<cmd>AerialToggle!<CR>", { desc = "Toggle Outline" })
      require("aerial").setup({
        backends = { "markdown", "man", "lsp", "treesitter" },
        layout = {
          max_width = { 30, 0.15 },
          placement = "edge",
          default_direction = "left",
        },
        attach_mode = "global",
        disable_max_lines = 20000,
      })
    end,
  },

  {
    "mcauley-penney/visual-whitespace.nvim",
    config = true,
  }, -- 在 visual mode 展示空白字符
  {
    "yetone/avante.nvim",
    enabled = false,
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = "deepseek",
      vendors = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-coder",
        },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      -- "stevearc/dressing.nvim",  -- 这个让 nvim-tree 的编辑有点不习惯
    },
  },
  -- cppman
  {
    "madskjeldgaard/cppman.nvim",
    config = function()
      local cppman = require("cppman")
      cppman.setup()

      -- Make a keymap to open the word under cursor in CPPman
      vim.keymap.set("n", "<leader>cm", function()
        cppman.open_cppman_for(vim.fn.expand("<cword>"))
      end)

      -- Open search box
      vim.keymap.set("n", "<leader>cc", function()
        cppman.input()
      end)
    end,
  },
  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = { "folke/snacks.nvim", lazy = true },
    keys = {},
    enabled = false, -- 升级到 0.11 的时候才可以使用
  },
  "pteroctopus/faster.nvim", -- 打开大文件的时候自动 disable 一些功能，例如高亮等
}, {})
