FROM archlinux/base

RUN pacman -Syu --needed --noconfirm \
  base-devel \
  # We use git to install yay; it's also a dependency of yay.
  git \
  # makepkg does not run as root
  sudo \
  zsh \
  go  \
  fzf \
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
  the_silver_searcher


# makepkg user and workdir
ARG user=martin
RUN useradd -m $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

# Install Oh my Zsh
RUN bash -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN sed -i -- 's/robbyrussell/sonicradish/g' /martin/.zshrc

# Install yay
RUN git clone https://aur.archlinux.org/yay.git \
  && cd yay \
  && makepkg -sri --needed --noconfirm \
  && cd \
  # Clean up
  && rm -rf .cache yay
