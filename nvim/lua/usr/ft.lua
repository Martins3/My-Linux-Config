local function ft(key_specific_args)
  require("leap").leap(vim.tbl_deep_extend("keep", key_specific_args, {
    inputlen = 1,
    inclusive = true,
    opts = {
      -- Force autojump.
      labels = "",
      -- Match the modes where you don't need labels (`:h mode()`).
      safe_labels = vim.fn.mode(1):match("o") and "" or nil,
    },
  }))
end

-- A helper function making it easier to set "clever-f" behavior
-- (using f/F or t/T instead of ;/, - see the plugin clever-f.vim).
local clever = require("leap.user").with_traversal_keys
local clever_f, clever_t = clever("f", "F"), clever("t", "T")

vim.keymap.set({ "n", "x", "o" }, "f", function()
  ft({ opts = clever_f })
end)
vim.keymap.set({ "n", "x", "o" }, "F", function()
  ft({ backward = true, opts = clever_f })
end)
vim.keymap.set({ "n", "x", "o" }, "t", function()
  ft({ offset = -1, opts = clever_t })
end)
vim.keymap.set({ "n", "x", "o" }, "T", function()
  ft({ backward = true, offset = 1, opts = clever_t })
end)
