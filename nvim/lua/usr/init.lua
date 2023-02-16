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
-- require 'usr.toggleterm' -- toggleterm 还是没有 floaterm 好用
require("colorizer").setup { 'css'; 'javascript'; 'vim'; html = { mode = 'foreground'; } }
require("nvim-surround").setup {}
require('gitsigns').setup {}
require('leap').add_default_mappings()
require('nvim-autopairs').setup {}
require('spellsitter').setup {}
