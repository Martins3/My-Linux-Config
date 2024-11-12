require("orgmode").setup({
  org_agenda_files = { "~/core/org-mode/*" },
  org_default_notes_file = "~/core/org-mode/refile.org",
  mappings = {
    global = {
      org_agenda = "<space>oa",
      org_capture = "<space>oc",
    },
    agenda = {
      org_agenda_todo = "t",
    },
    org = {
      -- 修改 TODO 的状态
      org_todo = "t",
      -- 打开或者折叠，默认映射为 tab ，但是 tab 用于在 window 直接的移动，所以重新映射为 x
      org_cycle = "x",
      -- 插入新的代办
      org_insert_todo_heading = "<leader>a",
    },
  },
  org_capture_templates = {
    j = {
      description = 'Journal',
      template = "\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?",
      target = "~/core/org-mode/journal.org",
    },
    t= "TODO",
    tw = {
      description = "Work Task",
      template = "* TODO %?\n SCHEDULED: %t",
      target = "~/core/org-mode/work.org",
    },
    ts = {
      description = "Study Task",
      template = "* TODO %?\n SCHEDULED: %t",
      target = "~/core/org-mode/study.org",
    },
  },
})
