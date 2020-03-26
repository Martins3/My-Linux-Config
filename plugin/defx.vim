" defx 将会自动忽略如下的文件
call defx#custom#option('_', {
    \ 'ignored_files': ".*,*.class,*.out,*.o,*.bc,*.a,compile_commands.json,*.d,*.mod*,*.cmd,.tmp_versions/,modules.order,Module.symvers,Mkfile.old,dkms.conf,*.ko",
    \ })
