local tree_cb = require'nvim-tree.config'.nvim_tree_callback
-- default mappings
local list = {
  { key = {"<CR>", "o", "l", "<2-LeftMouse>"}, cb = tree_cb("edit") },
  { key = "P",                            cb = tree_cb("parent_node") },
  { key = "h",                            cb = tree_cb("close_node") },
  { key = "p",                            cb = tree_cb("preview") },
  { key = "<C-r>",                        cb = tree_cb("refresh") },
  { key = "R",                            cb = tree_cb("full_rename") },
  { key = "yn",                           cb = tree_cb("copy_name") },
  { key = "yp",                           cb = tree_cb("copy_path") },
  { key = "yy",                           cb = tree_cb("copy_absolute_path") },
}

require'nvim-tree'.setup {
  view = {
    side = 'right',
    mappings = {
      custom_only = false,
      list = list
    },
  },
}

vim.g.nvim_tree_disable_window_picker = 1
