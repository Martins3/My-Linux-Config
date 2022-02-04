-- vim.opt.termguicolors = true

require('bufferline').setup {
  options = {
    numbers = function(opts)
      return string.format('%s', opts.ordinal)
    end,
    diagnostics = "coc",
    show_buffer_close_icons = false,
    separator_style = "slant",
    tab_size = 10,
  }
}
