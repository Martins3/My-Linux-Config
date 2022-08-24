local colors = require("tokyonight.colors").setup({})

require('bufferline').setup {
  options = {
    numbers = function(opts)
      return string.format('%s', opts.ordinal)
    end,
    diagnostics = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    separator_style = "thin",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 80,
  },
  highlights = {
    fill = {
      bg = colors.bg_dark,
    },
  }
}
