local runner = require("usr.runner")

require("code_runner").setup({
  term = {
    position = "belowright",
    size = 15,
  },
  project = {
    [vim.fs.normalize(vim.fn.expand("~/data/leetgpu-challenges"))] = {
      name = "leetgpu-challenges",
      command = "bash run.sh",
    },
  },
  filetype = {
    python = function()
      return require("usr.python").run_file_command()
    end,
    cuda = runner.cuda,
    c = runner.c,
    cpp = runner.cpp,
    sh = "bash $file",
    html = function()
      vim.ui.open(vim.api.nvim_buf_get_name(0))
    end,
    r = "Rscript $file",
    lua = "lua $file",
    nix = "nix eval -f $file",
    ps1 = "powershell -ExecutionPolicy Bypass -File $file",
  },
})
