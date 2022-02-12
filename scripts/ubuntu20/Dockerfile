# https://github.com/koalaman/shellcheck
# sudo apt install shellcheck
# # https://github.com/mvdan/sh
# GO111MODULE=on go get mvdan.cc/sh/v3/cmd/shfmt
# # https://github.com/languagetool-org/languagetool
# curl -L https://raw.githubusercontent.com/languagetool-org/languagetool/master/install.sh | sudo bash <options>

# https://github.com/sharkdp/bat/issues/938
# sudo apt install -o Dpkg::Options::="--force-overwrite" bat ripgrep
FROM ubuntu:20.04
RUN apt-get update
RUN apt install -y ca-certificates

# https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list
RUN echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt update

RUN apt -y install sudo
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN apt install -y software-properties-common gcc
RUN apt install -y zsh
RUN apt install -y wget
RUN apt install -y iputils-ping
RUN apt install -y python3-pip
RUN apt install -y git
RUN apt install -y cmake
RUN apt install -y bear tig
# https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites
RUN apt -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

# TMP_TODO : 如何安装正确的 nodejs 啊
RUN apt install -y nodejs
RUN apt install -y npm
RUN npm install --global yarn

WORKDIR /home/docker
USER docker

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

RUN git config --global http.proxy http://127.0.0.1:8889
RUN git config --global https.proxy https://127.0.0.1:8889

# 清华 pip 源
# https://mirrors.tuna.tsinghua.edu.cn/help/pypi/
RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip3 install neovim
RUN pip3 install cppman

# export http_proxy=http://127.0.0.1:8889 && export https_proxy=http://127.0.0.1:8889
ENV http_proxy=http://127.0.0.1:8889
ENV https_proxy=http://127.0.0.1:8889
RUN wget www.google.com

RUN git clone --depth=1 https://github.com/neovim/neovim
WORKDIR /home/docker/neovim
# cd neovim
RUN make CMAKE_BUILD_TYPE=Release -j8
# sudo make install
RUN echo docker | sudo -S make install
RUN mkdir -p /home/docker/.config/nvim

RUN git clone --depth=1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/opt/packer.nvim

RUN mv ~/.config/nvim ~/.config/nvim.bak # 保存原有配置
WORKDIR /home/docker
RUN git clone https://github.com/Martins3/My-Linux-config .dotfiles # 随便什么名字
RUN ln -s ~/.dotfiles ~/.config/nvim # 创建一个软链接指向此处
# RUN nvim -c "PackerSync"

RUN npm config set registry https://registry.npm.taobao.org/  # 设置npm镜像源为淘宝镜像
RUN yarn config set registry https://registry.npm.taobao.org/  # 设置yarn镜像源为淘宝镜像

