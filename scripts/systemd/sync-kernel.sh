#!/usr/bin/env bash
export PATH="$PATH:/run/wrappers/bin:/home/martins3/.nix-profile/bin"
export PATH="$PATH:/run/current-system/sw/bin/"
set -ex
function finish {
	if [[ $? != 0 ]]; then
		sleep infinity
	fi
}

trap finish EXIT

kcov=${ENABLE_KCOV-}

if cd /home/martins3/core/linux; then
	echo "kernel already setup"
else
	mkdir -p /home/martins3/core/
	cd /home/martins3/core
	git clone https://github.com/torvalds/linux
	cd linux
	ln -sf /home/martins3/.dotfiles/scripts/nix/env/linux.nix default.nix
fi

cores=$(getconf _NPROCESSORS_ONLN)
threads=$cores

# https://stackoverflow.com/questions/6245570/how-do-i-get-the-current-branch-name-in-git
branch=$(git rev-parse --abbrev-ref HEAD)
if [[ $branch != master ]]; then
	echo "checkout to master"
fi

# 1. 内核为了编译速度，使用 #include 直接包含 .c 文件
# 2. 为了消除重复代码，使用 #include 多次包含文件
# 这些情况都让代码非常难以跳转
special_files=(
	kernel/sched/build_policy.c
	kernel/sched/build_utility.c
	arch/x86/kvm/mmu/mmu.c
	kernel/rcu/tree.c
)
for i in "${special_files[@]}"; do
	echo "$i"
	git restore --staged "$i"
	git checkout -- "$i"
done

git pull

cp /home/martins3/.dotfiles/scripts/systemd/martins3.config kernel/configs/martins3.config
cp /home/martins3/.dotfiles/scripts/systemd/kconv.config kernel/configs/kconv.config

SECONDS=0
if [[ ${kcov} ]]; then
	nix-shell --command "make mrproper"
	nix-shell --command "make defconfig kvm_guest.config martins3.config kconv.config -j O=kcov"
	nix-shell --command "nice -n 19 make -j$threads O=kcov"
else
	# make clean
	nix-shell --command "make clean"
	nix-shell --command "make defconfig kvm_guest.config martins3.config -j"
	# nix-shell --command "chrt -i 0 make CC='ccache gcc' -j$threads"
	nix-shell --command "chrt -i 0 make -j$threads"
	# python3 /home/martins3/.dotfiles/scripts/systemd/revert-build-fast.py
	# scripts/systemd/expand-paging_tmpl.sh
	for i in "${special_files[@]}"; do
		git add "$i"
	done
fi

# 系统的 perf 不能用了，暂时靠这个维持生活吧
# 好家伙，这我整个这个报错
# Makefile.config:451: *** No gnu/libc-version.h found, please install glibc-dev[el].  Stop.
# nix-shell --command "chrt -i 0 make -C tools/perf -j$(($(getconf _NPROCESSORS_ONLN) - 1))"

if [[ ! ${kcov} ]]; then
	# curl -d "martins3,tag=13900K kernel=$SECONDS" -X POST 'http://127.0.0.1:8428/write' || true
  echo "$(date): $SECONDS" >>/home/martins3/core/cl.txt
fi

# 编译文档的速度太慢了，不想每次都等那么久
if [[ ! -d /home/martins3/core/linux/Documentation/output ]]; then
	nix-shell --command "make htmldocs -j$(($(getconf _NPROCESSORS_ONLN) - 1))"
fi
nix-shell --command "./scripts/clang-tools/gen_compile_commands.py"

# nix-shell --command "make binrpm-pkg -j$(($(getconf _NPROCESSORS_ONLN) - 1))"

# Documentation/conf.py 中修改主题 html_theme = 'sphinx_rtd_theme'

# 1. 启动虚拟机，让 Guest 安装对应的内核
# 2. nixos 中无法成功运行 make -C tools/testing/selftests TARGETS=vm run_testsq
# 3. 应该关注 linux-next 分支 : https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

# 等 ccls 的 bug 被修复再说吧
# nvim "+let g:auto_session_enabled = v:false" -c ":e mm/gup.c" -c "lua vim.loop.new_timer():start(1000 * 60 * 30, 0, vim.schedule_wrap(function() vim.api.nvim_command(\"exit\") end))"
