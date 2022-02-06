local wk = require("which-key")

wk.register({
  -- search
  ["<leader>"] = {
    f = { "<cmd>Telescope find_files<cr>", "search File" },
    a = { "<cmd>Telescope coc code_actions<cr>", "search coc code action"},
    c = { "<cmd>Telescope colorscheme<cr>", "search colorscheme" },
    b = { "<cmd>Telescope buffers<cr>", "search buffers" },
    d = { "<cmd>Telescope coc workspace_diagnostics<cr>", "show coc diagnostics" },
    g = { "<cmd>Telescope live_grep<cr>", "live grep" },
    G = { "<cmd>Telescope grep_string<cr>", "live grep cursor word" },
    h = { "<cmd>Telescope help_tags<cr>", "search vim manual" },
    i = { "<cmd>Octo issue list<cr>", "list github issue" },
    o = { "<cmd>Telescope coc document_symbols<cr>", "search symbols in file" },
    s = { "<cmd>Telescope coc workspace_symbols<cr>", "search symbols in project" },
    m = { "<cmd>Telescope bookmarks<cr>", "searcher browser bookmarks" },

    -- " 使用 <leader> [number] 切换到第 [number] 个 buffer
    ["1"] = { "<cmd>BufferLineGoToBuffer 1<CR>",  "jump to buffer 1"},
    ["2"] = { "<cmd>BufferLineGoToBuffer 2<CR>",  "jump to buffer 2"},
    ["3"] = { "<cmd>BufferLineGoToBuffer 3<CR>",  "jump to buffer 3"},
    ["4"] = { "<cmd>BufferLineGoToBuffer 4<CR>",  "jump to buffer 4"},
    ["5"] = { "<cmd>BufferLineGoToBuffer 5<CR>",  "jump to buffer 5"},
    ["6"] = { "<cmd>BufferLineGoToBuffer 6<CR>",  "jump to buffer 6"},
    ["7"] = { "<cmd>BufferLineGoToBuffer 7<CR>",  "jump to buffer 7"},
    ["8"] = { "<cmd>BufferLineGoToBuffer 8<CR>",  "jump to buffer 8"},
    ["9"] = { "<cmd>BufferLineGoToBuffer 9<CR>",  "jump to buffer 9"},
    ["0"] = { "<cmd>BufferLineGoToBuffer 10<CR>", "jump to buffer 10"},
  },

  -- " 使用 space [number] 切换到第 [number] 个 window
  ['<space>'] = {
    ["1"] = { "<cmd>1wincmd   w <cr>", "jump to window 1"},
    ["2"] = { "<cmd>2wincmd   w <cr>", "jump to window 2"},
    ["3"] = { "<cmd>3wincmd   w <cr>", "jump to window 3"},
    ["4"] = { "<cmd>4wincmd   w <cr>", "jump to window 4"},
    ["5"] = { "<cmd>5wincmd   w <cr>", "jump to window 5"},
    ["6"] = { "<cmd>6wincmd   w <cr>", "jump to window 6"},
    ["7"] = { "<cmd>7wincmd   w <cr>", "jump to window 7"},
    ["8"] = { "<cmd>8wincmd   w <cr>", "jump to window 8"},
    ["9"] = { "<cmd>9wincmd   w <cr>", "jump to window 9"},
    ["0"] = { "<cmd>10wincmd  w <cr>", "jump to window 0"},

    ['b'] = {
      name = "+buffer",
      ["c"] = { "<cmd>BWipeout other<cr>", "clear other buffers"},
    },
    ["c"] = { "<cmd>Commentary<cr>", "comment code"},
    ["q"] = { "<cmd>xa<cr>", "save all buffer and close vim"},
    ["x"] = { "<Cmd>FloatermNew ipython<CR>", "calculated"},
    ['g'] = {
      name = "+git",
      m = { "<cmd>GitMessenger<cr>", "show git blame of current line"},
      s = { "<cmd>FloatermNew tig status<cr>", ""},
      b = { "<cmd>Git blame<cr>", ""},
      c = { "<cmd>Git commit<cr>", ""},
      l = { "<cmd>FloatermNew tig %<cr>", ""},
      L = { "<cmd>FloatermNew tig<cr>", ""},
      p = { "<cmd>Git push<cr>", ""},
    },
    ['s'] = {
      name = "+search",
      P = {"<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "search cursor word in project"},
      p = {"<cmd>lua require('spectre').open()<CR>", "search in project"}
    },
    ['f'] = {
      name = "+file",
      o = {"<cmd>NvimTreeFindFile<cr>", "open file in dir"},
      s = {"<cmd>w<cr>", "save file"},
      t = {"<cmd>NvimTreeToggle<cr>", "toggle file tree"}
    }
  },
  q = { "<cmd>q<cr>", "close window"},
  ["c"] = {
    g = { "<Cmd>vsp<CR>", "vertical split window"},
    v = { "<Cmd>sp<CR>", "horizontal split window"},
    m = { "<C-W>o", "maximize current window"},
  },
  ["<tab>"] = {":wincmd w<cr>", "switch window"}
})

wk.register({
  ['<space>'] = {
    ["c"] = { ":Commentary<cr>", "comment code"},
    ["s"] = { ":lua require('spectre').open_visual()<cr>", "search"}
  }
}, { mode = "v"})
