require("nvim-treesitter.configs").setup({
  -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    disable = { "org", "c", "cpp" },
    additional_vim_regex_highlighting = { "org" },
  },
  -- ensure_installed = "maintained", 安装目前维护的所有语言 treesitter 插件。
  ensure_installed = {
    "org",
    "lua",
    "java",
    "rust",
    "c",
    "nix",
    "bash",
    "go",
    "diff",
    "scala",
    "cpp",
    "python",
    "markdown",
    "markdown_inline", -- 让 markdown 里面的代码段可以高亮
    -- 'comment' -- 更好的高亮 TODO XXX NOTE FIXME ，但是其让 url 的高亮过于明显
    "rst",
  },
})

-- 从 https://github.com/nvim-treesitter/nvim-treesitter-textobjects 拷贝过来的配置
require("nvim-treesitter.configs").setup({
  textsubjects = {
    enable = true,
    prev_selection = ",", -- (Optional) keymap to select the previous selection
    keymaps = {
      ["."] = "textsubjects-smart",
      [";"] = "textsubjects-container-outer",
      ["i;"] = "textsubjects-container-inner",
    },
  },
})

require("nvim-treesitter.configs").setup({
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
      },
      -- You can choose the select mode (default is charwise 'v')
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V",  -- linewise
        ["@class.outer"] = "<c-v>", -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding xor succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      include_surrounding_whitespace = true,
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["xl"] = "@function.outer",
        ["xL"] = "@class.outer",
      },
      goto_next_end = {
        ["xk"] = "@function.outer",
        ["xK"] = "@class.outer",
      },
      goto_previous_start = {
        ["xh"] = "@function.outer",
        ["xH"] = "@class.outer",
      },
      goto_previous_end = {
        ["xj"] = "@function.outer",
        ["xJ"] = "@class.outer",
      },
    },
  },
})
