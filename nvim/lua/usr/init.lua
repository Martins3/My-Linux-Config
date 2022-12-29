require 'usr.packer'
require 'usr.bufferline'
require 'usr.code_runner'
require 'usr.hydra'
require 'usr.nvim-tree'
require 'usr.nvim-treesitter'
require 'usr.orgmode'
require 'usr.telescope'
require 'usr.version'
require 'usr.which-key'
require("colorizer").setup { 'css'; 'javascript'; 'vim'; html = { mode = 'foreground'; } }
require("nvim-surround").setup {}
require('gitsigns').setup {}
require('leap').add_default_mappings()
require('nvim-autopairs').setup {}
require('spellsitter').setup {}
-- @todo 如果可以让打开的 terminal 是透明的，那是极好的
require("toggleterm").setup {
  winbar = {
    enabled = true,
    name_formatter = function(term) --  term: Terminal
      return term.name
    end
  },
  shade_terminals = true,
}
