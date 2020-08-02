
FROM archlinux 
# create a user


# 记得 docker 是可以共享 文件夹的啊 !

# https://stackoverflow.com/questions/28302178/how-can-i-add-a-volume-to-an-existing-docker-container

# 保证在 docker 内可以访问 kvm
# https://stackoverflow.com/questions/48422001/how-to-launch-qemu-kvm-from-inside-a-docker-container

# TODO

# 安装 autojump 的内容

sudo pacman -Syu --needed --noconfirm  \
zsh \
go  \
lsd \
ccls \
curl \
nodejs \
yarn \
npm \
python-pip \
bear \
make \
flex \
bison \
xmlto kmod inetutils bc libelf git \
gettext \
cmake \
coreutils \
htop \
xclip \
bash-language-server \
ripgrep \
the_silver_searcher

pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip install lazygit

yay -S --noconfirm bear



# 等待处理
autojump
