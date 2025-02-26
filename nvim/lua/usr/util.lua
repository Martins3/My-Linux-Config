-- deepseek 协助编写，获取文件名
local function get_file_path()
  -- 获取当前文件的完整路径
  local file_path = vim.api.nvim_eval("expand('%:p')")

  -- 创建一个新的 buffer
  local buf = vim.api.nvim_create_buf(false, true) -- 非列表 buffer，可编辑

  -- 将 buffer 显示在一个新的窗口中
  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = 60,
    height = 1,
    row = 1,
    col = 1,
    style = 'minimal',
    border = 'single',
  })

  -- 将文件路径写入 buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { file_path })
end

-- 创建命令
vim.api.nvim_create_user_command('GetFilePath', get_file_path, {})
