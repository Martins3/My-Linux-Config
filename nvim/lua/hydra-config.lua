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
  body = 'ca',
  heads = {
    { 'k', '5<C-w>+' },
    { 'j', '5<C-w>-', { desc = 'j/k height' } },
    { 'h', '5<C-w>>', },
    { 'l', '5<C-w><', { desc = ' h/l width' } },
  }
})

-- 当想要修改一块代码的缩进的时候，使用 < 或者 > ，然后使用 . 来重复，这是 vim 的默认行为。
