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
    { '<', '5<C-w><', },
    { '>', '5<C-w>>', { desc = ' ←/→ width' } },
  }
})
