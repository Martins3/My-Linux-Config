local colors = require("tokyonight.colors").setup({})

require('bufferline').setup {
  options = {
    numbers = function(opts)
      return string.format('%s', opts.ordinal)
    end,
    diagnostics = "coc",
    show_buffer_close_icons = false,
    show_close_icon = false,
    separator_style = "slant",
    left_trunc_marker = "",
    right_trunc_marker = "",
    tab_size = 10,
    },
    highlights = {
      fill= {
        guibg = colors.bg_dark,
      },
    }
}
