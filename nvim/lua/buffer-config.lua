local colors = require("tokyonight.colors").setup({})

require('bufferline').setup {
  options = {
    numbers = function(opts)
      return string.format('%s', opts.ordinal)
    end,
    diagnostics = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    indicator_icon = '',
    separator_style = "thin",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 80,
  },
  highlights = {
    fill = {
      guibg = colors.bg_dark,
    },
  }
}
