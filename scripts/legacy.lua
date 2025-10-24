local function get_term_in_window()
  local terminal_windows = {}
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    local bufnr = vim.api.nvim_win_get_buf(winid)
    if vim.bo[bufnr].buftype == "terminal" then
      table.insert(terminal_windows, winid)
    end
  end
  return terminal_windows
end

-- 如果当前 window 已经存在 terminal ，那么就选择第一个进入
local term_buffers_in_opened = get_term_in_window()
if #term_buffers_in_opened > 0 then
  vim.api.nvim_set_current_win(term_buffers_in_opened[1])
  return
end

-- TODO 通过 session restore ，无法记录到 last buffer 是什么
-- local buf_name = vim.api.nvim_buf_get_name(last_non_terminal_buf)
-- print("Current buffer: " .. buf_name)
