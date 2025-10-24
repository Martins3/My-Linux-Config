return {
  cmd = { 'clangd', '--background-index' },
  root_markers = { 'compile_commands.json' },
  filetypes = { 'c', 'cpp' },
}
