local function get_transfer_status()
  -- lazy load
  if package.loaded["transfer"] == nil then
    return nil
  end

  local ok, transfer = pcall(require, "transfer")
  if not ok then
    return nil
  end

  local status = transfer.get_status()

  local icons = {
    idle = "🌕",
    syncing = "󰇚",
    success = "󰄬",
    error = "󰅚",
  }
  return icons[status] or nil
end

local function get_break_reminder_status()
  if package.loaded["break-reminder"] == nil then
    return nil
  end

  local ok, break_reminder = pcall(require, "break-reminder")
  if not ok or type(break_reminder.get_statusline_indicator) ~= "function" then
    return nil
  end

  return break_reminder.get_statusline_indicator()
end

local function has_toggleterm_buffer()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype == "toggleterm" then
      return true
    end
  end
  return false
end

local function get_toggleterm_indicator()
  return "🏃"
end

require("lualine").setup({
  extensions = { "nvim-tree", "fugitive" },
  sections = {
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_c = {
      {
        function()
          return get_break_reminder_status() or ""
        end,
        cond = function()
          return get_break_reminder_status() ~= nil
        end,
      },
      {
        function()
          return get_toggleterm_indicator()
        end,
        cond = function()
          return has_toggleterm_buffer()
        end,
      },
      {
        function()
          return get_transfer_status() or ""
        end,
        cond = function()
          return get_transfer_status() ~= nil
        end,
      },
    }
  },
})
