if vim.fn.has("win32") == 1 and vim.fn.executable("gcc") == 1 then
  -- tree-sitter defaults to cl.exe on Windows, but the Scoop toolchain uses MinGW GCC.
  vim.env.CC = "gcc"
  vim.env.CXX = "g++"
end

require("nvim-treesitter").setup({})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "c", "sh", "python" },
  callback = function()
    vim.treesitter.start()
  end,
})

require("nvim-treesitter").install({
  "lua",
  "java",
  "rust",
  "nix",
  "bash",
  "go",
  "diff",
  "scala",
  "awk",
  "python",
  "markdown",
  "markdown_inline", -- 让 markdown 里面的代码段可以高亮
  -- 'comment' -- 更好的高亮 TODO XXX NOTE FIXME ，但是其让 url 的高亮过于明显
  "rst",
  "llvm",
  "gitcommit",
  "gitignore",
  "git_rebase",
  "html",
  "perl", -- 内核的一些脚本是 perl
  "make",
  "kconfig",
  "toml",
  "cuda",
})

-- configuration
require("nvim-treesitter-textobjects").setup({
  move = {
    -- whether to set jumps in the jumplist
    set_jumps = true,
  },
})

vim.keymap.set({ "n", "x", "o" }, "gj", function()
  require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end, { desc = "Go to start of current/previous function" })
