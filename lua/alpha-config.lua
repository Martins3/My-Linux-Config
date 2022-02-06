local alpha = require("alpha")
local dashboard = require("alpha.themes.startify")

-- TMP_TODO 需要深入理解一下
-- dashboard.section.mru_cwd.val = { { type = "padding", val = 1 } }
dashboard.section.mru.val = { { type = "padding", val = 1 } }

-- local fortune = require("alpha.fortune")
-- dashboard.section.footer.val = fortune()

-- Send config to alpha
alpha.setup(dashboard.opts)
