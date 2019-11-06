" I hope we can ignore files with .gitignore
call defx#custom#option('_', {
    \ 'ignored_files': ".*,*.class,*.out,*.o",
    \ })
