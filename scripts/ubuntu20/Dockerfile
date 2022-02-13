# https://github.com/sharkdp/bat/issues/938
# sudo apt install -o Dpkg::Options::="--force-overwrite" bat ripgrep
FROM ubuntu:20.04
ENV TERM=screen-256color
ENV COLORTERM=truecolor
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

# tzdata 的地区选择会让 docker build 暂停，随便设置一个地区
# https://serverfault.com/questions/949991/how-to-install-tzdata-on-a-ubuntu-docker-image
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow
RUN apt-get install -y tzdata

RUN apt install -y gcc wget iputils-ping python3-pip git bear tig shellcheck ripgrep

# 安装 ccls 的依赖 https://github.com/MaskRay/ccls/wiki/Build
RUN apt install -y libclang-10-dev clang llvm

# 安装 neovim 的各种依赖 https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites
RUN apt install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
RUN apt install -y npm
RUN npm install --global yarn
RUN apt install -y xclip fontconfig

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
RUN make CMAKE_BUILD_TYPE=Release -j8
RUN echo docker | sudo -S make install
RUN mkdir -p /home/docker/.config/nvim

RUN git clone --depth=1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/opt/packer.nvim

RUN mv ~/.config/nvim ~/.config/nvim.bak # 保存原有配置
WORKDIR /home/docker
RUN git clone https://github.com/Martins3/My-Linux-config mylc # 随便取个什么名字
WORKDIR /home/docker/mylc
RUN git checkout remove-spacevim
RUN ln -s ~/mylc ~/.config/nvim # 创建一个软链接指向此处

RUN npm config set registry https://registry.npm.taobao.org/  # 设置npm镜像源为淘宝镜像
RUN yarn config set registry https://registry.npm.taobao.org/  # 设置yarn镜像源为淘宝镜像

# 手动编译 ccls
WORKDIR /home/docker
RUN git clone --depth=1 --recursive https://github.com/MaskRay/ccls
WORKDIR /home/docker/ccls
RUN cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release
RUN cmake --build Release
WORKDIR /home/docker/ccls/Release
RUN echo docker | sudo -S make install

# 使用 musl 作为测试
WORKDIR /home/docker
RUN git clone https://github.com/bminor/musl
WORKDIR /home/docker/musl
RUN ./configure
RUN bear make -j

# 安装字体，之后在 terminal 的设置中设置字体为 nerdfont
WORKDIR /home/docker
RUN wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hasklig.zip
RUN unzip Hasklig.zip -d ~/.fonts
RUN fc-cache -fv

# 使用 nvm 安装 nodejs 16
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN echo 'export NVM_DIR="$HOME/.nvm"'                                       >> "$HOME/.bashrc"
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> "$HOME/.bashrc"
RUN echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >> "$HOME/.bashrc"
RUN bash -c 'source $HOME/.nvm/nvm.sh   && nvm install v16'

RUN echo 'alias v=nvim' >> "$HOME/.bashrc"
RUN git clone https://github.com/NvChad/NvChad --depth 1
RUN echo 'alias nv="rm ~/.config/nvim && ln -sf ~/NvChad ~/.config/nvim && nvim"' >> "$HOME/.bashrc"
RUN echo 'alias sp="rm ~/.config/nvim && ln -sf ~/mylc ~/.config/nvim && nvim"' >> "$HOME/.bashrc"

# 安装新版本的 golang, github cli 和 shfmt 需要
RUN wget https://go.dev/dl/go1.17.7.linux-amd64.tar.gz
RUN echo docker | sudo -S rm -rf /usr/local/go
RUN echo docker | sudo -S tar -C /usr/local -xzf go1.17.7.linux-amd64.tar.gz
RUN echo "export PATH=$PATH:/usr/local/go/bin" >> "$HOME/.bashrc"
ENV PATH="$PATH:/usr/local/go/bin"
RUN go version

# https://github.com/mvdan/sh
RUN go get mvdan.cc/sh/v3/cmd/shfmt

# 安装 github cli
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
# RUN echo docker | sudo -S ln /usr/local/go/bin/go /bin/go
RUN git clone https://github.com/cli/cli.git gh-cli
WORKDIR /home/docker/gh-cli
# https://stackoverflow.com/questions/65328413/make-go-command-not-found-although-go-binary-is-in-path
RUN echo docker | sudo -S -E env "PATH=$PATH" make install
