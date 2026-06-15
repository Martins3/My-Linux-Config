---@type RustaceanOpts
vim.g.rustaceanvim = {
  tools = {
    executor = "toggleterm",
    test_executor = "toggleterm",
    crate_test_executor = "toggleterm",
    hover_actions = {
      replace_builtin_hover = true,
    },
    code_actions = {
      ui_select_fallback = true,
    },
    float_win_config = {
      border = "rounded",
      max_width = 120,
      auto_focus = false,
    },
  },
  server = {
    on_attach = function(_, bufnr)
      local map = function(lhs, rhs, desc, mode)
        vim.keymap.set(mode or "n", lhs, rhs, {
          buffer = bufnr,
          silent = true,
          desc = desc,
        })
      end

      map("K", function()
        vim.cmd.RustLsp({ "hover", "actions" })
      end, "Rust hover actions")

      map("<leader>a", function()
        vim.cmd.RustLsp("codeAction")
      end, "Rust code action")

      map("<leader>x", function()
        vim.cmd.RustLsp("run")
      end, "Rust run")

      map("<leader>R", function()
        vim.cmd.RustLsp("runnables")
      end, "Rust runnables")

      map("<leader>ce", function()
        vim.cmd.RustLsp({ "explainError", "current" })
      end, "Rust explain error")

      map("<leader>cd", function()
        vim.cmd.RustLsp("openDocs")
      end, "Rust docs")

      map("<leader>cm", function()
        vim.cmd.RustLsp("expandMacro")
      end, "Rust expand macro")

      map("<leader>cp", function()
        vim.cmd.RustLsp("parentModule")
      end, "Rust parent module")

      map("<leader>cr", function()
        vim.cmd.RustLsp("renderDiagnostic")
      end, "Rust render diagnostic")

      map("<leader>cs", function()
        vim.cmd.RustLsp("ssr")
      end, "Rust structural search replace")
    end,
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
        checkOnSave = true,
      },
    },
  },
}
