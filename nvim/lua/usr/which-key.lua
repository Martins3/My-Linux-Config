-- whichkey configuration
local wk = require("which-key")
wk.setup({
  plugins = {
    marks = false,    -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mo
  },
})

wk.add({
  -- " 使用 <leader> [number] 切换到第 [number] 个 buffer
  { "<leader>0", "<cmd>BufferLineGoToBuffer 10<cr>",                  desc = "jump to buffer 10" },
  { "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>",                   desc = "jump to buffer 1" },
  { "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>",                   desc = "jump to buffer 2" },
  { "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>",                   desc = "jump to buffer 3" },
  { "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>",                   desc = "jump to buffer 4" },
  { "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>",                   desc = "jump to buffer 5" },
  { "<leader>6", "<cmd>BufferLineGoToBuffer 6<cr>",                   desc = "jump to buffer 6" },
  { "<leader>7", "<cmd>BufferLineGoToBuffer 7<cr>",                   desc = "jump to buffer 7" },
  { "<leader>8", "<cmd>BufferLineGoToBuffer 8<cr>",                   desc = "jump to buffer 8" },
  { "<leader>9", "<cmd>BufferLineGoToBuffer 9<cr>",                   desc = "jump to buffer 9" },
  { "<leader>F", "<cmd>Telescope git_files<cr>",                      desc = "search files (exclude submodules)" },
  { "<leader>G", "<cmd>Telescope grep_string<cr>",                    desc = "live grep cursor word" },
  { "<leader>b", "<cmd>Telescope buffers<cr>",                        desc = "searcher buffers" },
  { "<leader>c", "<cmd>Telescope frecency workspace=CWD<cr>",         desc = "search files sort with edit history" },
  { "<leader>f", "<cmd>Telescope find_files<cr>",                     desc = "search files (include submodules)" },
  { "<leader>g", "<cmd>Telescope live_grep<cr>",                      desc = "live grep" },
  { "<leader>h", "<cmd>Telescope help_tags<cr>",                      desc = "search vim manual" },
  { "<leader>i", "<cmd>Telescope jumplist<cr>",                       desc = "search jumplist" },
  { "<leader>j", "<cmd>Telescope emoji<cr>",                          desc = "search emoji" },
  { "<leader>k", "<cmd>Telescope colorscheme<cr>",                    desc = "colorscheme" },
  { "<leader>m", "<cmd>Telescope bookmarks<cr>",                      desc = "search bookmarks" },
  { "<leader>o", "<cmd>Telescope lsp_document_symbols<cr>",           desc = "search symbols in file" },
  -- leader p used for paste from system clipboard
  { "<leader>s", "<cmd>Telescope lsp_dynamic_workspace_symbols <cr>", desc = "search symbols in project" },
  -- leader t : markdown table mode
  -- leader x used for map language specific function
  -- " 使用 <leader> [number] 切换到第 [number] 个 window
  { "<space>0",  "<cmd>10wincmd w <cr>",                              desc = "jump to window 0" },
  { "<space>1",  "<cmd>1wincmd w <cr>",                               desc = "jump to window 1" },
  { "<space>2",  "<cmd>2wincmd w <cr>",                               desc = "jump to window 2" },
  { "<space>3",  "<cmd>3wincmd w <cr>",                               desc = "jump to window 3" },
  { "<space>4",  "<cmd>4wincmd w <cr>",                               desc = "jump to window 4" },
  { "<space>5",  "<cmd>5wincmd w <cr>",                               desc = "jump to window 5" },
  { "<space>6",  "<cmd>6wincmd w <cr>",                               desc = "jump to window 6" },
  { "<space>7",  "<cmd>7wincmd w <cr>",                               desc = "jump to window 7" },
  { "<space>8",  "<cmd>8wincmd w <cr>",                               desc = "jump to window 8" },
  { "<space>9",  "<cmd>9wincmd w <cr>",                               desc = "jump to window 9" },
  { "<space>a",  group = "misc" },
  { "<space>aa", "<cmd>InsertUUID<cr>",                               desc = "remove trailing space" },
  { "<space>ad", "<cmd>call TrimWhitespace()<cr>",                    desc = "remove trailing space" },
  { "<space>b",  group = "buffer" },
  { "<space>bd", "<cmd>bdelete %<cr>",                                desc = "close current buffers" },
  -- only works in a c/cpp file
  { "<space>c",  group = "ouroboros" },
  { "<space>cc", "<cmd>Ouroboros<cr>",                                desc = "open file in current window" },
  { "<space>ch", "<cmd>split | Ouroboros<cr>",                        desc = "open file in a horizontal split" },
  { "<space>cv", "<cmd>vsplit | Ouroboros<cr>",                       desc = "open file in a vertical split" },
  { "<space>f",  group = "file" },
  { "<space>fo", "<cmd>NvimTreeFindFile<cr>",                         desc = "open file in dir" },
  { "<space>fs", "<cmd>w<cr>",                                        desc = "save file" },
  { "<space>ft", "<cmd>NvimTreeToggle<cr>",                           desc = "toggle file tree" },
  { "<space>g",  group = "git" },
  { "<space>ga", "<cmd>Git add -A<cr>",                                desc = "git stage all changes" },
  { "<space>gb", "<cmd>Gitsigns blame <cr>",                           desc = "git blame" },
  { "<space>gB", "<cmd>Git blame <cr>",                                desc = "git blame" },
  { "<space>gc", "<cmd>Git commit --signoff<cr>",                      desc = "git commit" },
  { "<space>gg", "<cmd>GitConflictListQf<cr>",                         desc = "git conflict quick fix" },
  { "<space>gh", "<cmd>lua require('gitsigns').setqflist('all') <cr>", desc = "git show hook" },
  { "<space>gm", "<cmd>GitMessenger<cr>",                              desc = "git blame of current line" },
  { "<space>gx", "<cmd>Gitsigns toggle_current_line_blame<cr>",        desc = "git toggle blame of current line" },
  { "<space>gp", "<cmd>Git push<cr>",                                  desc = "git push" },
  -- 因为 ctrl-i 实际上等同于 tab
  { "<space>i",  "<c-i>",                                             desc = "go to newer jumplist" },
  { "<space>j",  "<cmd>ToggleTerm size=30 direction=horizontal <cr>", desc = "open toggle term" },
  { "<space>l",  group = "language" },
  { "<space>la", "<cmd>lua vim.lsp.buf.code_action()<cr>",            desc = "code action" },
  { "<space>lc", "<cmd>Commentary<cr>",                               desc = "comment code" },
  -- <space>lf 格式化代码
  { "<space>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", desc = "lsp goto next" },
  { "<space>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", desc = "lsp goto prev" },
  { "<space>ln", "<cmd>lua vim.lsp.buf.rename()<cr>",                 desc = "rename" },
  { "<space>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>",          desc = "" },
  { "<space>lr", "<cmd>RunCode<cr>",                                  desc = "run code" },
  { "<space>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>",         desc = "signature help" },
  -- <space> o 被 orgmode 使用
  --
  -- 为什么是 qa 而不是 wqa ，发现如果 nvim 打开了 terminal ，如果执行 wqa 会有这个错误
  -- E948: Job still running
  -- E676: No matching autocommands for buftype= buffer
  { "<space>q",  "<cmd>qa<cr>",                                      desc = "close vim" },

  { "<space>s",  group = "search" },
  {
    "<space>sP",
    "<cmd>lua require('spectre').open_visual({select_word=true})<cr>",
    desc = "search cursor word in project",
  },
  { "<space>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>",          desc = "search in current buffer" },
  { "<space>sg", "<cmd>Telescope git_status<cr>",                         desc = "search git status" },
  { "<space>sp", "<cmd>lua require('spectre').open()<cr>",                desc = "search in project" },

  { "<space>t",  group = "toggle" },
  { "<space>t7", "<cmd>let &cc = &cc == '' ? '75' : ''<cr>",              desc = "highlight 75 line" },
  { "<space>t8", "<cmd>let &cc = &cc == '' ? '81' : ''<cr>",              desc = "highlight 80 line" },
  { "<space>tb", "<cmd>let &tw = &tw == '0' ? '80' : '0'<cr>",            desc = "automaticall break line at 80" },
  { "<space>th", "<cmd>noh<cr>",                                          desc = "Stop the highlighting" },
  { "<space>tm", "<cmd>TableModeToggle<cr>",                              desc = "markdown table edit mode" },
  { "<space>tr", "<cmd>TransferToggle<cr>",                               desc = "toggle rsync on save" },
  { "<space>ts", "<cmd>set spell!<cr>",                                   desc = "spell check" },
  { "<space>tt", "<cmd>set nocursorline<cr> <cmd>TransparentToggle<cr>",  desc = "make background transparent" },
  { "<space>tw", "<cmd>set wrap!<cr>",                                    desc = "wrap line" },
  { "<space>y",  "<cmd>Yazi<cr>",                                         desc = "open file in dir" },
  { "<tab>",     "<cmd>wincmd w<cr>",                                     desc = "switch window" },
  { "K",         "<cmd>lua vim.lsp.buf.hover()<cr>",                      desc = "document" },
  { "c",         group = "window" },
  -- i f a t 被 textobject 所使用
  { "cg",        "<cmd>vsp<cr>",                                          desc = "vertical split window" },
  { "ch",        "<C-w>h",                                                desc = "go to the window left" },
  { "cj",        "<C-w>j",                                                desc = "go to the window below" },
  { "ck",        "<C-w>k",                                                desc = "go to the window up" },
  { "cl",        "<C-w>l",                                                desc = "go to the window right" },
  { "cm",        "<cmd>only<cr>",                                         desc = "delete other window" },
  { "cn",        "<cmd>AerialToggle!<cr>",                                      desc = "toggle navigator" },
  { "cs",        "<cmd>sp<cr>",                                           desc = "horizontal split window" },
  { "cu",        "<cmd>UndotreeToggle<cr>",                               desc = "open undo tree" },
  { "gD",        "<cmd>lua vim.lsp.buf.declaration()<cr>",                desc = "go to declaration" },
  { "gd",        "<cmd>Telescope lsp_definitions<cr>",                 desc = "go to definition" },
  { "gi",        "<cmd>lua vim.lsp.buf.implementation()<cr>",             desc = "go to implementation" },
  { "gr",        "<cmd>Telescope lsp_references<cr>",                     desc = "go to reference" },
  { "gw",        "<cmd>Telescope diagnostics<cr>",                        desc = "diagnostics" },
  { "gn",        "<cmd>lua vim.diagnostic.goto_next()<cr>",               desc = "go to next error" },
  { "gN",        "<cmd>lua vim.diagnostic.goto_prev()<cr>",               desc = "go to prev error" },
  { "m",         group = "bookmarks" },
  { "ma",        "<cmd>Telescope bookmarks<cr>",                          desc = "search bookmarks" },
  { "md",        "<cmd>lua require'bookmarks.list'.delete_on_virt()<cr>", desc = "delete bookmark at virt text line" },
  { "md",        "<cmd>lua require'bookmarks.list'.delete_on_virt()<cr>", desc = "delete bookmark at virt text line" },
  { "mm",        "<cmd>lua require'bookmarks'.add_bookmarks()<cr>",       desc = "add bookmarks" },
  { "mn",        "<cmd>lua require'bookmarks.list'.show_desc() <cr>",     desc = "show bookmark note" },
  { "q",         "<cmd>q<cr>",                                           desc = "close current window" },
})

wk.add({
  {
    mode = { "v" },
    { "<space>lc", ":Commentary<cr>",                               desc = "comment code" },
    { "<space>s",  group = "search" },
    { "<space>sp", "<cmd>lua require('spectre').open_visual()<cr>", desc = "search" },
    { "q",         "<cmd>q<cr>",                                    desc = "close window" },
  },
})

vim.api.nvim_set_keymap("i", "<c-g>", "<cmd>!ibus engine rime<cr>", { noremap = true })

-- 添加自适应的命令
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sh",
  callback = function()
    vim.keymap.set("n", "<leader>x", ":!chmod +x %<CR>", { buffer = true, silent = true })
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<leader>x", ":MarkdownPreview<CR>", { buffer = true, silent = false })
  end
})

vim.cmd("autocmd FileType rust lua RunRust()")
function RunRust()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.keymap.set("n", "<leader>a", function()
    vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end, { silent = true, buffer = bufnr })

  vim.keymap.set("n", "<leader>r", function()
    vim.cmd.RustLsp("run")
  end, { silent = true, buffer = bufnr })

  vim.keymap.set("n", "<leader>R", function()
    vim.cmd.RustLsp("runnables")
  end, { silent = true, buffer = bufnr })
end
