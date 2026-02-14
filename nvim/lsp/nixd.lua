-- 配置方法，参考 https://github.com/NixOS/nixfmt ，也算是学到了
return {
  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
}
