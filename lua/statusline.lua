-- 这两个函数从这里超过来的,在 statusline 中检查 space tab 混用和尾部空格
-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets
local function indent()
  local space_pat = [[\v^ +]]
  local tab_pat = [[\v^\t+]]
  local space_indent = vim.fn.search(space_pat, 'nwc')
  local tab_indent = vim.fn.search(tab_pat, 'nwc')
  local mixed = (space_indent > 0 and tab_indent > 0)
  local mixed_same_line
  if not mixed then
    mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], 'nwc')
    mixed = mixed_same_line > 0
  end
  if not mixed then return '' end
  if mixed_same_line ~= nil and mixed_same_line > 0 then
    return 'MI:' .. mixed_same_line
  end
  local space_indent_cnt = vim.fn.searchcount({ pattern = space_pat, max_count = 1e3 }).total
  local tab_indent_cnt = vim.fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total
  if space_indent_cnt > tab_indent_cnt then
    return 'MI:' .. tab_indent
  else
    return 'MI:' .. space_indent
  end
end

local function trailing_space()
  local space = vim.fn.search([[\s\+$]], 'nwc')
  return space ~= 0 and "TS:" .. space or ""
end

require('lualine').setup({
  options = {
    globalstatus = true
  },
  extensions = { 'nvim-tree' },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename', 'g:coc_status' },
    lualine_x = { 'progress' },
    lualine_y = { 'location' },
    lualine_z = { trailing_space, indent }
  }
})
