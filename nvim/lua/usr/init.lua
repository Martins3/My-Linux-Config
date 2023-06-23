require 'usr.options'
require 'usr.packer'
require 'usr.lsp'
require 'usr.cmp'
require 'usr.bufferline'
require 'usr.code_runner'
require 'usr.hydra'
require 'usr.nvim-tree'
require 'usr.nvim-treesitter'
require 'usr.orgmode'
require 'usr.telescope'
require 'usr.version'
require 'usr.which-key'
require 'usr.colorscheme'
require 'usr.session'
require("colorizer").setup { 'css', 'javascript', 'vim', html = { mode = 'foreground', } }
require("nvim-surround").setup {}
require('gitsigns').setup { signcolumn = false, numhl = true }
require('leap').add_default_mappings()
require('nvim-autopairs').setup {}
require('spellsitter').setup {}
require("early-retirement").setup {}
require("symbols-outline").setup()
