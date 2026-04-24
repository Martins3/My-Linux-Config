local dict = vim.fn.expand("$HOME/.dotfiles/nvim/10k.txt")

local prose_filetypes = {
  gitcommit = true,
  markdown = true,
  org = true,
  text = true,
  typst = true,
}

local function in_treesitter_capture(names)
  local ok, captures = pcall(function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    return vim.treesitter.get_captures_at_pos(0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
  end)
  if not ok then
    return false
  end

  for _, capture in ipairs(captures) do
    for _, name in ipairs(names) do
      if capture.capture:find(name, 1, true) then
        return true
      end
    end
  end

  return false
end

local function dictionary_enabled()
  if prose_filetypes[vim.bo.filetype] then
    return true
  end

  return in_treesitter_capture({ "comment", "spell" })
end

local ok_luasnip = pcall(require, "luasnip")
if ok_luasnip then
  require("luasnip.loaders.from_vscode").lazy_load()
end

return {
  keymap = { },

  snippets = {
    preset = "luasnip",
  },

  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 300,
      window = {
        border = "rounded",
      },
    },
    list = {
      selection = {
        preselect = false,
        auto_insert = false,
      },
    },
    menu = {
      border = "rounded",
      draw = {
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind" },
          { "source_name" },
        },
      },
    },
    ghost_text = {
      enabled = false,
    },
  },

  cmdline = {
    enabled = true,
    keymap = {
      preset = "cmdline",
      ["<Right>"] = false,
      ["<Left>"] = false,
    },
    sources = function()
      local cmdtype = vim.fn.getcmdtype()
      if cmdtype == "/" or cmdtype == "?" then
        return { "buffer" }
      end
      if cmdtype == ":" or cmdtype == "@" then
        return { "path", "cmdline" }
      end
      return {}
    end,
    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      menu = {
        auto_show = function(ctx)
          return ctx.mode == "cmdwin" or vim.fn.getcmdtype() == ":"
        end,
      },
      ghost_text = {
        enabled = true,
      },
    },
  },

  sources = {
    default = function()
      local sources = { "lsp", "path", "snippets", "buffer" }
      if dictionary_enabled() then
        table.insert(sources, "dictionary")
      end
      return sources
    end,
    providers = {
      lsp = {
        fallbacks = {},
      },
      buffer = {
        score_offset = -5,
        opts = {
          get_bufnrs = function()
            return vim.api.nvim_list_bufs()
          end,
        },
      },
      dictionary = {
        name = "Dict",
        module = "blink-cmp-dictionary",
        min_keyword_length = 3,
        score_offset = -4,
        opts = {
          dictionary_files = { dict },
          force_fallback = true,
          get_documentation = function()
            return nil
          end,
        },
      },
      orgmode = {
        name = "Org",
        module = "orgmode.org.autocompletion.blink",
      },
    },
    per_filetype = {
      org = { inherit_defaults = true, "orgmode" },
    },
  },

  signature = {
    enabled = true,
    window = {
      border = "rounded",
    },
  },

  fuzzy = {
    implementation = "prefer_rust_with_warning",
  },
}
