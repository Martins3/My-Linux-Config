#!/usr/bin/env bash
# @todo 不知道为什么，是不可以使用 #!/usr/bin/env bash，会被报错的
# 如果使用 bash 启动之后, nix-shell 还是需要如此写
set -ex
function finish {
  sleep infinity
}
trap finish EXIT
nix="/run/current-system/sw/bin/nix-shell"

# https://stackoverflow.com/questions/6245570/how-do-i-get-the-current-branch-name-in-git
branch=$(git rev-parse --abbrev-ref HEAD)
if [[ $branch != master ]]; then
  echo "checkout to master"
fi

cur_commit_id=$(git rev-parse --short HEAD)
git pull
latest_commit_id=$(git rev-parse --short HEAD)

if [[ $cur_commit_id == "$latest_commit_id" ]]; then
  echo "No update"
fi

echo "#!/usr/bin/env bash" >news.sh
echo "#$(date)" >>news.sh
echo "tig $cur_commit_id..$latest_commit_id" >>news.sh
chmod +x news.sh

cat <<_EOF_ >kernel/configs/martins3.config
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y

CONFIG_XFS_FS=y
CONFIG_MEMCG=y # TODO
CONFIG_BPF_SYSCALL=y # TODO
_EOF_

$nix --command "make defconfig kvm_guest.config martins3.config"
$nix --command "make -j32"
./scripts/clang-tools/gen_compile_commands.py

# @todo 还是因为环境变量的问题，这里的操作有问题
# $nix --command 'nvim "+let g:auto_session_enabled = v:false" -c ":e mm/gup.c" -c "lua vim.loop.new_timer():start(1000 * 60 * 60, 0, vim.schedule_wrap(function() vim.api.nvim_command(\"exit\") end))"'
