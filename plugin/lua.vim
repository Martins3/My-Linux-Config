lua << EOF
require('telescope').setup{
  defaults = {
  },
  extensions = {
    fzy_native = {
        override_generic_sorter = true,
        override_file_sorter = false,
    }
  },
}

require('telescope').load_extension('fzy_native')
EOF
