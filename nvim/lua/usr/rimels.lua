require("rimels").setup({
  keys = { start = "jk", stop = "jh", esc = ";j", undo = ";u" },
  cmd = { "/home/martins3/.cargo/bin/rime_ls" },
  rime_user_dir = "/home/martins3/.local/share/rime-ls",
  shared_data_dir = "/home/martins3/.local/share/fcitx5/rime",
  filetypes = { "NO_DEFAULT_FILETYPES" },
  single_file_support = true,
  settings = {},
  docs = {
    description = [[https://www.github.com/wlh320/rime-ls, A language server for librime]],
  },
  max_candidates = 9,
  trigger_characters = {},
  schema_trigger_character = "&", -- [since v0.2.0] 当输入此字符串时请求补全会触发 “方案选单”
  probes = {
    ignore = {},
    using = {},
    add = {},
  },
  detectors = {
    with_treesitter = {},
    with_syntax = {},
  },
  cmp_keymaps = {
    disable = {
      space = false,
      numbers = false,
      enter = false,
      brackets = false,
      backspace = false,
    },
  },
})
