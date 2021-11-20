" defx 将会自动忽略如下的文件
" 实际上根据 .gitignore 自动忽视这些文件是更好的方案，但是 defx 没有实现
let ignored_files='.*,*.bin,*.raw,*.class,*.out,*.o,*.bc,*.a,
  \ compile_commands.json,*.d,*.mod*,*.cmd,.tmp_versions/,modules.order,
  \ Module.symvers,Mkfile.old,dkms.conf,*.ko,*.elf,*.img,*.so,*.qcow2,*.iso'

call defx#custom#option('_', {
    \ 'ignored_files': ignored_files,
    \ })
