local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- 通过 https://patorjk.com/software/taag 来生成
dashboard.section.header.val = {
  "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
  "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
  "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
  "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
  "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
  "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
  "                                                  ",
  "        ██╗   ██╗██╗   ██╗██████╗ ███████╗        ",
  "        ╚██╗ ██╔╝╚██╗ ██╔╝██╔══██╗██╔════╝        ",
  "         ╚████╔╝  ╚████╔╝ ██║  ██║███████╗        ",
  "          ╚██╔╝    ╚██╔╝  ██║  ██║╚════██║        ",
  "           ██║      ██║   ██████╔╝███████║        ",
}

-- Set menu
dashboard.section.buttons.val = {}

dashboard.section.buttons.val = {
  dashboard.button("       ,f", "  > Find file", ":Telescope find_files<CR>"),
  dashboard.button("<Space>ft", "  > FileTree", ":NvimTreeOpen<CR>"),
}

-- Send config to alpha
alpha.setup(dashboard.opts)
