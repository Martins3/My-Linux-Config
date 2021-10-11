" 这里是 lua 的一些配置，当前完全需要 lua 的配置有 telescope.nvim
" 预计未来几年，vim 的配置将会全面转为 lua 的，暂时这种方式来过渡一下。

lua << EOF
-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup {
  defaults = {
    layout_strategy = "vertical",
    layout_config = {
      vertical = {
        height = 0.9,
        preview_cutoff = 0,
        width = 0.9
      }
      -- other layout configuration here
    },
    -- other defaults configuration here
  },

  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  },
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
EOF
