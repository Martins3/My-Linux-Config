require('orgmode').setup_ts_grammar()

require('orgmode').setup({
  org_agenda_files = { '~/core/org-mode/*' },
  org_default_notes_file = '~/core/org-mode/refile.org',
  mappings = {
    global = {
      org_agenda = '<space>oa',
      org_capture = '<space>oc'
    },
    agenda = {
      org_agenda_todo = 't'
    },
    org = {
      org_todo = 't',
      -- org_cycle use `Tab` which making window switch unusble
      org_cycle = 'x',
      org_insert_todo_heading = '<leader>a'
    }
  },
})
