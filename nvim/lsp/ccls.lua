local opts = {
  init_options = {
    index = {
      threads = 0,
    },
    clang = {
      excludeArgs = { "-Wall" },
    },

    highlight = {
      lsRanges = true,
    },

    client = {
      snippetSupport = true,
    },
  },
}

return opts
