local wk = require("which-key")

wk.setup({
  plugins = {
    marks = false, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mo
  }
})

wk.register({
  -- search
  ["<leader>"] = {
    a = { "<cmd>Telescope coc code_actions<cr>", "search coc code action" },
    b = { "<cmd>Telescope buffers<cr>", "search buffers" },
    c = {
      name = "+coc",
      x = { "<Plug>(coc-codeaction-selected)", "Applying codeAction to the selected region" },
      c = { "<Plug>(coc-codeaction)", "applying codeAction to the current buffer" },
      f = { "<Plug>(coc-fix-current)", "apply AutoFix to problem on the current line" },
      a = { "<Plug>(coc-codelens-action)", "run the Code Lens action on the current line" }
    },
    d = { "<cmd>Telescope coc workspace_diagnostics<cr>", "show coc diagnostics" },
    e = { "<cmd>Telescope bookmarks<cr>", "searcher browser bookmarks" },
    f = { "<cmd>Telescope find_files<cr>", "search files (include submodules)" },
    F = { "<cmd>Telescope git_files<cr>", "search files (exclude submodules)" },
    g = { "<cmd>Telescope live_grep<cr>", "live grep" },
    G = { "<cmd>Telescope grep_string<cr>", "live grep cursor word" },
    h = { "<cmd>Telescope help_tags<cr>", "search vim manual" },
    i = { "<cmd>Octo issue list<cr>", "list github issue" },
    j = { "<cmd>Telescope emoji<cr>", "search emoji" },
    k = { "<cmd>Telescope colorscheme<cr>", "colorscheme" },
    M = { "<cmd>Telescope vim_bookmarks all<cr>", "search bookmarks in project" },
    o = { "<cmd>call Outline()<cr>", "search symbols in file" },
    -- leader p used for paste from system clipboard
    s = { "<cmd>Telescope coc workspace_symbols<cr>", "search symbols in project" },

    -- " 使用 <leader> [number] 切换到第 [number] 个 buffer
    ["1"] = { "<cmd>BufferLineGoToBuffer 1<cr>", "jump to buffer 1" },
    ["2"] = { "<cmd>BufferLineGoToBuffer 2<cr>", "jump to buffer 2" },
    ["3"] = { "<cmd>BufferLineGoToBuffer 3<cr>", "jump to buffer 3" },
    ["4"] = { "<cmd>BufferLineGoToBuffer 4<cr>", "jump to buffer 4" },
    ["5"] = { "<cmd>BufferLineGoToBuffer 5<cr>", "jump to buffer 5" },
    ["6"] = { "<cmd>BufferLineGoToBuffer 6<cr>", "jump to buffer 6" },
    ["7"] = { "<cmd>BufferLineGoToBuffer 7<cr>", "jump to buffer 7" },
    ["8"] = { "<cmd>BufferLineGoToBuffer 8<cr>", "jump to buffer 8" },
    ["9"] = { "<cmd>BufferLineGoToBuffer 9<cr>", "jump to buffer 9" },
    ["0"] = { "<cmd>BufferLineGoToBuffer 10<cr>", "jump to buffer 10" },
  },

  -- " 使用 space [number] 切换到第 [number] 个 window
  ['<space>'] = {
    ["1"] = { "<cmd>1wincmd  w <cr>", "jump to window 1" },
    ["2"] = { "<cmd>2wincmd  w <cr>", "jump to window 2" },
    ["3"] = { "<cmd>3wincmd  w <cr>", "jump to window 3" },
    ["4"] = { "<cmd>4wincmd  w <cr>", "jump to window 4" },
    ["5"] = { "<cmd>5wincmd  w <cr>", "jump to window 5" },
    ["6"] = { "<cmd>6wincmd  w <cr>", "jump to window 6" },
    ["7"] = { "<cmd>7wincmd  w <cr>", "jump to window 7" },
    ["8"] = { "<cmd>8wincmd  w <cr>", "jump to window 8" },
    ["9"] = { "<cmd>9wincmd  w <cr>", "jump to window 9" },
    ["0"] = { "<cmd>10wincmd w <cr>", "jump to window 0" },

    ['a'] = {
      name = "+misc",
      a = { "<cmd>SourcetrailActivateToken<cr>", "activate sourcetrail server" },
      d = { "<cmd>call TrimWhitespace()<cr>", "remove trailing space" },
      r = { "<cmd>SourcetrailRefresh<cr>", "sourcetrail refresh" },
      s = { "<cmd>SourcetrailStartServer<cr>", "start sourcetrail server" },
      t = { "<Plug>(coc-translator-p)", "translate current word" },
    },
    ['b'] = {
      name = "+buffer",
      ["c"] = { "<cmd>BDelete hidden<cr>", "close invisible buffers" },
      ["d"] = { "<cmd>bdelete %<cr>", "close current buffers" },
    },
    ["f"] = {
      name = "+file",
      o = { "<cmd>NvimTreeFindFile<cr>", "open file in dir" },
      s = { "<cmd>w<cr>", "save file" },
      t = { "<cmd>NvimTreeToggle<cr>", "toggle file tree" }
    },
    ["g"] = {
      name = "+git",
      a = { "<cmd>Git add -A<cr>", "git stage all changes" },
      b = { "<cmd>Git blame<cr>", "git blame" },
      c = { "<cmd>Git commit<cr>", "git commit" },
      l = { "<cmd>FloatermNew tig %<cr>", "log of file" },
      L = { "<cmd>FloatermNew tig<cr>", "log of project" },
      m = { "<cmd>GitMessenger<cr>", "show git blame of current line" },
      p = { "<cmd>Git push<cr>", "git push" },
      s = { "<cmd>FloatermNew tig status<cr>", "git status" },
    },
    ['l'] = {
      name = "+language",
      c = { "<cmd>Commentary<cr>", "comment code" },
      f = { "<cmd>call CocActionAsync('format')<cr>", "format current buffer" },
      n = { "<Plug>(coc-rename)", "rename" },
      r = { "<cmd>call QuickRun()<cr>", "run code" },
      p = { "<cmd>call Preivew()<cr>", "preview" },
    },
    -- o 被 orgmode 使用
    ["q"] = { "<cmd>qa<cr>", "close vim" },
    ["s"] = {
      name = "+search",
      P = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>",
        "search cursor word in project" },
      p = { "<cmd>lua require('spectre').open()<cr>", "search in project" }
    },
    ["t"] = {
      name = "+toggle",
      ["8"] = { "<cmd>let &cc = &cc == '' ? '81' : ''<cr>", "highlight 80 line" },
      ["b"] = { "<cmd>let &tw = &tw == '0' ? '80' : '0'<cr>", "break line at 80" },
      ["s"] = { "<cmd>set spell!<cr>", "spell check" },
      ["w"] = { "<cmd>set wrap!<cr>", "wrap line" },
      ["h"] = { "<cmd>noh<cr>", "Stop the highlighting" },
      ["m"] = { "<cmd>TableModeToggle<cr>", "markdown table edit mode" },
      ["t"] = { "<cmd>set nocursorline<cr> <cmd>TransparentEnable<cr>", "make background transparent" },
    },
    ["x"] = { "<cmd>FloatermNew ipython<cr>", "calculated" },
  },
  q = { "<cmd>q<cr>", "close window" },
  ["c"] = {
    name = "+window",
    g = { "<cmd>vsp<cr>", "vertical split window" },
    f = { "<cmd>sp<cr>", "horizontal split window" },
    m = { "<cmd>only<cr>", "delete other window" },
    u = { "<cmd>UndotreeToggle<cr>", "open undo tree" },
    n = { "<cmd>Vista!!<cr>", "toggle vista navigator" },
    H = { "<C-w>h", "go to the window left" },
    J = { "<C-w>j", "go to the window below" },
    K = { "<C-w>k", "go to the window up" },
    L = { "<C-w>l", "go to the window right" },
  },
  ["m"] = {
    name = "+bookmarks",
    a = { "<cmd>Telescope vim_bookmarks all<cr>", "list marks in project" },
    m = { "<cmd>BookmarkToggle<cr>", "toggle bookmark" },
    x = { "<cmd>BookmarkClearAll<cr>", "remove all bookmarks in project" },
  },
  ["<tab>"] = { "<cmd>wincmd w<cr>", "switch window" },
})

wk.register({
  ["<space>"] = {
    ["l"] = {
      ["c"] = { ":Commentary<cr>", "comment code" },
      ["f"] = { "<Plug>(coc-format-selected)<cr>", "format selected code" },
    },
    ["s"] = { "<cmd>lua require('spectre').open_visual()<cr>", "search" }
  },
  q = { "<cmd>q<cr>", "close window" },
}, { mode = "v" })
