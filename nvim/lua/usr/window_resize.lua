-- 每个按键都在临时模式中处理。把命令写成字符串，方便直接看出调整方向和步长。
local resize = {
  h = "vertical resize +10",
  l = "vertical resize -10",
  j = "resize +5",
  k = "resize -5",
}

-- getcharstr() 会暂时接管后续按键，因此不需要额外插件就能实现临时模式。
-- 提示放在命令行上，比 notify 更适合持续显示当前状态。
local function show_mode()
  vim.api.nvim_echo({
    { " 调整窗口 ", "ModeMsg" },
    { " h/l 宽度  j/k 高度  Esc/q 退出", "MoreMsg" },
  }, false, {})
  vim.cmd.redraw()
end

local function clear_mode()
  vim.api.nvim_echo({}, false, {})
  vim.cmd.redraw()
end

vim.keymap.set("n", "ca", function()
  -- `ca` 是完整映射。执行后由 getcharstr() 等待下一个按键，编辑器仍保持普通模式。
  show_mode()

  while true do
    -- pcall 可以处理被中断的 getcharstr()，避免提示残留在命令行上。
    local ok, key = pcall(vim.fn.getcharstr)
    if not ok or key == "\027" or key == "\r" or key == "\n" or key == "\003" or key == "q" then
      clear_mode()
      return
    end

    local command = resize[key]
    if command then
      vim.cmd(command)
      show_mode()
      vim.cmd.redraw()
    else
      -- h/j/k/l 会留在循环中继续调整。其他按键退出临时模式后立即回放，
      -- 因此输入 `cahi` 仍然会正常进入插入模式。
      clear_mode()
      -- "i" 将按键插回输入队列前端，"m" 允许它继续走用户已有的映射。
      vim.api.nvim_feedkeys(key, "im", false)
      return
    end
  end
end, { desc = "resize window" })
