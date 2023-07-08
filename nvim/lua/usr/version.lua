-- 检查 neovim 版本
local actual_ver = vim.version()
local nvim_ver = string.format("%d.%d.%d", actual_ver.major, actual_ver.minor, actual_ver.patch)

if actual_ver.major == 0 then
  if actual_ver.minor < 9 then
    local msg = string.format("Please upgrade neovim version : at least %s, but got %s instead!\n", "0.8.0", nvim_ver)
    vim.api.nvim_err_writeln(msg)
  end
end
