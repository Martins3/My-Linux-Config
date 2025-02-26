-- 由 deepseek 协助完成
-- 拷贝， <leader> a ，然后粘贴
-- 会调用脚本，将 clipboard 中的 gdb backtrace 简化之后再粘贴出来
function ProcessClipboard()
  -- 获取剪贴板内容
  local clipboard_content = vim.fn.getreg('+')
  -- 检查剪贴板内容是否为空
  if clipboard_content == "" then
    print("Clipboard is empty!")
    return
  end

  -- 打开文件并写入剪贴板内容
  local tmp = '/tmp/martins3/trim.txt'
  local file = io.open(tmp, "w+")
  if file then
    local success, err = file:write(clipboard_content)
    if not success then
      print("Failed to write to file: " .. err)
      return
    end
    file:close()
  else
    print("Failed to open file: " .. tmp)
    return
  end

  local project = '/home/martins3/core/vn'
  vim.fn.system(project .. '/code/qemu/trim.sh')

  file = io.open(tmp, "r")
  if file then
    local file_content = file:read("*a") -- 读取整个文件内容
    -- 将文件内容写入剪贴板
    vim.fn.setreg('+', file_content)
    print(file_content)
    file:close()
  else
    print("Failed to read file: " .. tmp)
  end
  print("trim finished !")
end

-- 映射快捷键
vim.api.nvim_set_keymap('n', '<leader>a', ':lua ProcessClipboard()<CR>', { noremap = true, silent = true })
