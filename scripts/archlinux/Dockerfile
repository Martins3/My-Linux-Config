FROM archlinux/base


# 使用清华软件源
# https://mirrors.tuna.tsinghua.edu.cn/help/archlinux/
RUN sed -i '1 i\Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
RUN sudo pacman -Syy

RUN pacman -Syu --needed --noconfirm \
  base-devel \
  # We use git to install yay; it's also a dependency of yay.
  git \
  # makepkg does not run as root
  wget \
  sudo \
  zsh \
  go  \
  llvm \
  clang \
  lsd \
  ccls \
  curl \
  nodejs \
  yarn \
  npm \
  python-pip \
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
  the_silver_searcher \
  neovim  \
  lua

# makepkg user and workdir
ARG user=martin
RUN useradd -m $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

# Install yay
RUN git clone https://aur.archlinux.org/yay.git \
  && cd yay \
  && makepkg -sri --needed --noconfirm \
  && cd \
  # Clean up
  && rm -rf .cache yay
