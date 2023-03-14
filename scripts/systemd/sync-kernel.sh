#!/usr/bin/env bash
set -ex
export PATH="$PATH:/run/wrappers/bin:/home/martins3/.nix-profile/bin"
export PATH="$PATH:/run/current-system/sw/bin/"
function finish {
  if [[ $? == 0 ]]; then
    sleep 600
    exit 0
  fi
  sleep infinity
}

trap finish EXIT

if cd /home/martins3/core/linux; then
  echo "kernel already setup"
else
  mkdir -p /home/martins3/core/
  cd /home/martins3/core
  git clone https://github.com/torvalds/linux
  cd linux
fi

# https://stackoverflow.com/questions/6245570/how-do-i-get-the-current-branch-name-in-git
branch=$(git rev-parse --abbrev-ref HEAD)
if [[ $branch != master ]]; then
  echo "checkout to master"
fi

# 内核为了编译速度，使用 #include 直接包含 .c 文件，
# 将这些文件展开，从而可以正确跳转
git restore --staged kernel/sched/build_utility.c
git restore --staged kernel/sched/build_policy.c
git checkout -- kernel/sched/build_utility.c
git checkout -- kernel/sched/build_policy.c

git pull

python3 /home/martins3/.dotfiles/scripts/systemd/revert-build-fast.py
git add kernel/sched/build_utility.c
git add kernel/sched/build_policy.c

cp /home/martins3/.dotfiles/scripts/systemd/martins3.config kernel/configs/martins3.config

RECORD_TIME=false

nix-shell --command "make defconfig kvm_guest.config martins3.config"
if [[ $RECORD_TIME == true ]]; then
  nix-shell --command "make clean"
  SECONDS=0
fi
nix-shell --command "nice -n 19 make -j$(($(getconf _NPROCESSORS_ONLN) - 1))"

if [[ $RECORD_TIME == true ]]; then
  duration=$SECONDS
  echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
  echo "$(date) : $duration : " >>/home/martins3/core/compile-linux/database
  cat /proc/cmdline >>/home/martins3/core/compile-linux/database
fi

# 编译的速度太慢了，不想每次都等那么久
if [[ ! -d /home/martins3/core/linux/Documentation/output ]]; then
  nix-shell --command "make htmldocs -j$(($(getconf _NPROCESSORS_ONLN) - 1))"
fi
# nix-shell --command "rm -r .cache"
nix-shell --command "./scripts/clang-tools/gen_compile_commands.py"
# nix-shell --command "make binrpm-pkg -j$(($(getconf _NPROCESSORS_ONLN) - 1))"
#
# Documentation/conf.py 中修改主题 html_theme = 'sphinx_rtd_theme'

# 1. 启动虚拟机，让 Guest 安装对应的内核
# 2. nixos 中无法成功运行 make -C tools/testing/selftests TARGETS=vm run_testsq
# 3. 应该关注 linux-next 分支 : https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

# @todo 等 ccls 的 bug 被修复再说吧
# nvim "+let g:auto_session_enabled = v:false" -c ":e mm/gup.c" -c "lua vim.loop.new_timer():start(1000 * 60 * 30, 0, vim.schedule_wrap(function() vim.api.nvim_command(\"exit\") end))"
