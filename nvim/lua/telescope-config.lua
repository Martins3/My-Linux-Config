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
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "respect_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    bookmarks = {
      -- Available: 'brave', 'buku', 'chrome', 'edge', 'safari', 'firefox'
      selected_browser = 'edge',
    },
  }
}

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
require('telescope').load_extension('bookmarks')
require('telescope').load_extension('heading')
require("telescope").load_extension("emoji")
require('telescope').load_extension('neoclip')
