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
  "echasnovski/mini.icons", -- which-key healthcheck prefers it when available
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

  -- AI 行内补全 (本地 vLLM / OpenAI-compatible)
  -- 服务不在线时仅请求超时，不会报 Lua 错误
  {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
    enabled = false,
    config = function()
      require("minuet").setup({
        -- 使用 OpenAI-compatible chat completions 端点对接 vLLM
        provider = "openai_compatible",
        -- 本地模型响应较慢，适当放宽超时和节流
        request_timeout = 5,
        throttle = 1000,
        debounce = 400,
        -- 初始上下文窗口，可根据本地 GPU 性能调大
        context_window = 1024,
        n_completions = 1, -- 本地模型建议只请求 1 个结果，节省资源
        provider_options = {
          openai_compatible = {
            end_point = "http://127.0.0.1:8000/v1/chat/completions",
            model = "qwen3-0.6b",
            -- 本地部署无需认证，但必须返回非空字符串；
            -- 用函数返回可避免被当作环境变量名去查而导致 nil 报错
            api_key = function()
              return "EMPTY"
            end,
            name = "LocalLLM",
            stream = true,
            optional = {
              max_tokens = 1280,
              temperature = 0.2,
              top_p = 0.9,
            },
          },
        },
        virtualtext = {
          -- 自动触发的文件类型，"*" 表示全部
          auto_trigger_ft = { "*" },
          keymap = {
            accept = "<A-f>", -- Alt+f 接受整个建议
            accept_line = "<A-l>", -- Alt+l 接受整行
            accept_n_lines = nil, -- 不绑定
            next = "<A-n>", -- Alt+n 下一条建议
            prev = "<A-p>", -- Alt+p 上一条建议
            dismiss = "<A-e>", -- Alt+e 关闭建议
          },
        },
        notify = "warn",
      })
    end,
  },

  -- AI 行内补全 (GitHub Copilot) -- 保留备用，已禁用
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = { enabled = false },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<A-f>",
            accept_word = "<A-w>",
            accept_line = "<A-l>",
            next = "<A-n>",
            prev = "<A-p>",
            dismiss = "<A-e>",
          },
        },
        filetypes = { ["c"] = true },
        copilot_node_command = "node",
        server_opts_overrides = {},
      })
    end,
  },

  -- 代码段
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  -- lsp
  { "neovim/nvim-lspconfig" }, -- enable LSP
  { "williamboman/mason.nvim" }, -- simple to use language server installer
  { "williamboman/mason-lspconfig.nvim" },
  {
    "j-hui/fidget.nvim",
    version = "1.6.1",
    lazy = false,
    opts = {
      notification = {
        override_vim_notify = false,
      },
    },
  }, -- 右下角展示索引状态
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
        python = { "ruff_organize_imports", "ruff_fix", "black" },
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
    commit = "f8bbc3177d929dc86e272c41cc15219f0a7aa1ac", -- newer main drops Nvim 0.11 support
    lazy = false,
    build = ":TSUpdate",
  },
  -- "RRethy/nvim-treesitter-textsubjects",
  { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
  -- ui
  "kyazdani42/nvim-tree.lua", -- 文件树
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    config = function()
      require("usr.bufferline")
    end,
  }, -- buffer
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("usr.lualine")
    end,
  }, -- 状态栏
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
  { "akinsho/git-conflict.nvim", version = "*", config = true }, -- 解决 git 冲突
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
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermSelect" },
    keys = {
      "<c-t>",
      "<space>gs",
      "<space>gl",
      "<space>x",
      { "<space>lt", desc = "pytest current file" },
      { "<space>lT", desc = "pytest nearest test" },
      { "<space>lp", desc = "pytest project" },
      "<space>e",
      "<c-s>",
    },
    config = function()
      require("usr.toggleterm")
    end,
  }, -- nvim 中打开终端
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
  "mzlogin/vim-markdown-toc", -- 自动生成 markdown 文章的目录
  "dhruvasagar/vim-table-mode", -- 快速编辑 markdown 的表格
  -- 高效编辑
  "tpope/vim-commentary", -- 快速注释代码
  "kylechui/nvim-surround", -- 快速编辑单词两侧的符号
  "windwp/nvim-autopairs", -- 自动括号匹配
  "mbbill/undotree", -- 显示编辑的历史记录
  "windwp/nvim-spectre", -- 媲美 vscode 的多文件替换
  -- 高亮
  {
    "norcalli/nvim-colorizer.lua",
    ft = { "css", "javascript", "lua", "html" },
    config = function()
      require("colorizer").setup({ "css", "javascript", "lua", html = { mode = "foreground" } })
    end,
  }, -- 显示 #ABCBCB
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
  {
    url = "https://codeberg.org/andyg/leap.nvim", -- 快速移动
  },

  {
    "crusj/bookmarks.nvim",
    branch = "main",
    event = "VeryLazy",
    config = function()
      require("bookmarks").setup({
        mappings_enabled = true,
        keymap = {
          toggle = "mc",
          delete = "dd",
        },
        virt_pattern = { "*.lua", "*.md", "*.c", "*.h", "*.sh", "*.py" },
      })
      require("telescope").load_extension("bookmarks")
    end,
  }, -- 书签, 存储在 ~/.local/share/nvim/bookmarks 中
  "tyru/open-browser.vim", -- 使用 gx 打开链接
  {
    -- TODO 似乎这个容易导致安装问题，应该让只有 linux 图形界面的时候再去安装
    -- 用起来还是有点问题的，会做一些奇怪的自动切换
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
  {
    "andrewferrier/debugprint.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
  }, -- 快速插入 print 来调试，默认快捷键 g?p
  { "xiyaowong/telescope-emoji.nvim" },
  {
    -- dir = "/home/martins3/data/rsync.nvim/",
    "Martins3/rsync.nvim",
    lazy = true,
    cmd = { "TransferInit", "TransferToggle", "TransferShow" },
    opts = {},
  },
  {
    -- dir = "/home/martins3/data/vim-translator",
    "Martins3/translator.nvim",
    config = function()
      require("translator").setup()
    end,
    cmd = { "Translate" },
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
        filter_kind = {
          typst = {
            "Namespace", -- codex 给 typst 修复，不然，这个不会显示结果
          },
        },
      })
    end,
  },

  {
    "mcauley-penney/visual-whitespace.nvim",
    config = true,
  }, -- 在 visual mode 展示空白字符
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      -- dashboard = { enabled = true },
      -- explorer = { enabled = true },
      -- indent = { enabled = true },
      input = { enabled = true },
      -- picker = { enabled = true },
      -- notifier = { enabled = true },
      -- quickfile = { enabled = true },
      -- scope = { enabled = true },
      -- scroll = { enabled = true },
      -- statuscolumn = { enabled = true },
      -- words = { enabled = true },
    },
  },
  {
    "yetone/avante.nvim",
    enabled = true,
    build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- 使用 kimi-cli 的 ACP 模式
      -- provider = "kimi-cli",
      provider = "codex",
      -- ACP 模式配置：覆盖默认配置，修复 --acp 参数已被废弃的问题
      acp_providers = {
        ["kimi-cli"] = {
          command = "kimi",
          args = { "acp" },
        },
        ["codex"] = {
          command = "codex-acp",
          env = {
            NODE_NO_WARNINGS = "1",
            INITIAL_AGENT_MODE = "agent-full-access",
            HOME = os.getenv("HOME"),
            PATH = os.getenv("PATH"),
            CODEX_PATH = "/home/martins3/.bun/bin/codex",
            http_proxy = os.getenv("http_proxy") or "http://127.0.0.1:7890",
            https_proxy = os.getenv("https_proxy") or "http://127.0.0.1:7890",
            ftp_proxy = os.getenv("ftp_proxy") or "http://127.0.0.1:7890",
            WS_PROXY = os.getenv("WS_PROXY") or "http://127.0.0.1:7890",
            WSS_PROXY = os.getenv("WSS_PROXY") or "http://127.0.0.1:7890",
            HTTP_PROXY = os.getenv("HTTP_PROXY") or "http://127.0.0.1:7890",
            HTTPS_PROXY = os.getenv("HTTPS_PROXY") or "http://127.0.0.1:7890",
            FTP_PROXY = os.getenv("FTP_PROXY") or "http://127.0.0.1:7890",
          },
        },
      },
      -- 保留 API 直连模式配置（备用）
      providers = {},
    },
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

      -- Make a keymap to open the word under cursor in cppman
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
    keys = {},
    enabled = true,
  },
  {
    "chomosuke/typst-preview.nvim",
    lazy = false, -- or ft = 'typst'
    version = "1.*",
    opts = {
      -- host = "172.17.127.73", -- 这个总是需要修改，就有点烦
      port = 8001,
    }, -- lazy.nvim will implicitly calls `setup {}`
  },
}, {})
