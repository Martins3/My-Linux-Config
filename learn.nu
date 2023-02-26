
# function t() {
#   while getopts "rh" opt; do
#     case $opt in
#       r)
#         sudo bpftrace -e "kretprobe:${@: -1} { printf(\"returned: %lx\\n\", retval); }"
#         return
#         ;;
#       h)
#         ;;
#       *)
#         exit 1
#         ;;
#     esac # --- end of case ---
#   done
#   sudo bpftrace -e "kprobe:${@: -1} {  @[kstack] = count(); }"
# }

# def t [
#   function: string
#   --return (-r): bool
# ] {
#     if  ( $return == true ) {
#         sudo bpftrace -e $"kretprobe:($function) { printf\(\"returned: %lx\\n\", retval\); }"
#     } else {
#         sudo bpftrace -e $"kprobe:($function) { @[kstack] = count\(\);}"
#     }
# }

# make -j $(get)

def m [ ] {
  let tmp = (getconf _NPROCESSORS_ONLN | into int) - 1
  make -j$"($tmp)"
}
