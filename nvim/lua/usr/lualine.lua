local function get_transfer_status()
  local ok, transfer = pcall(require, "transfer")
  if not ok then
    return nil
  end
  local status = transfer.get_status()
  local icons = {
    disabled = "",
    idle = "🌕",
  }
  return icons[status] or nil
end

require("lualine").setup({
  extensions = { "nvim-tree", "fugitive" },
  sections = {
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_c = {
      {
        function()
          return get_transfer_status() or ""
        end,
        cond = function()
          return get_transfer_status() ~= nil
        end,
      },
    }
  },
})
