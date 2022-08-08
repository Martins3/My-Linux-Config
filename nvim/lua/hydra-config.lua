local Hydra = require('hydra')

Hydra({
  name = 'Side scroll',
  mode = 'n',
  body = 'z',
  heads = {
    { 'h', '5zh' },
    { 'l', '5zl', { desc = '←/→' } },
    { 'H', 'zH' },
    { 'L', 'zL', { desc = 'half screen ←/→' } },
  }
})

Hydra({
  name = 'Window size',
  mode = 'n',
  body = 'c',
  heads = {
    { '+', '5<C-w>+' },
    { '-', '5<C-w>-', { desc = '←/→ height' } },
    { '<', '5<C-w>>', },
    { '>', '5<C-w><', { desc = ' ←/→ width' } },
  }
})

-- TMP_TODO 我现在发现移动 block 缩进一次操作就结束了，是配置有问题还是需要 hydra 来解决
