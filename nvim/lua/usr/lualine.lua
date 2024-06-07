vim.b.rime_enabled = false
local toggle_rime = function(client_id)
  vim.lsp.buf_request(0, "workspace/executeCommand", { command = "rime-ls.toggle-rime" }, function(_, result, ctx, _)
    if ctx.client_id == client_id then
      vim.b.rime_enabled = result
    end
  end)
end

-- update lualine
local function rime_status()
  if vim.b.rime_enabled then
    return "ㄓ"
  else
    return ""
  end
end

require("lualine").setup({
  extensions = { "nvim-tree", "fugitive" },
  sections = {
    lualine_x = { rime_status, "encoding", "fileformat", "filetype" },
  },
})
