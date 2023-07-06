require("catppuccin").setup({
  -- flavour = "macchiato",
  -- flavour = "latte",
  flavour = "frappe",
  -- flavour = "mocha",
  transparent_background = false,
  integrations = {},
})
vim.api.nvim_set_hl(0, "LeapBackdrop", { fg = "grey" }) -- leap.nvim
vim.cmd.colorscheme("catppuccin")

-- vim.cmd.colorscheme "tokyonight"
