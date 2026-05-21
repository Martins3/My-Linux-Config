local M = {}

local function exists(path)
  return vim.uv.fs_stat(path) ~= nil
end

local function has(root, relpath)
  return root and exists(root .. "/" .. relpath)
end

function M.is_linux_kernel_root(root)
  return has(root, "Makefile")
      and has(root, "Kbuild")
      and has(root, "Kconfig")
      and has(root, "MAINTAINERS")
      and has(root, "include/linux/kernel.h")
      and has(root, "arch")
end

function M.find_c_root(bufnr)
  return vim.fs.root(bufnr, {
    "compile_commands.json",
    "compile_flags.txt",
    ".ccls",
    ".clangd",
    ".git",
  })
end

function M.find_clangd_root(bufnr)
  return vim.fs.root(bufnr, {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    ".git",
  })
end

return M
