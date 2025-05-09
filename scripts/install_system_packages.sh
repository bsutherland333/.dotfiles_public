#!/bin/bash

# Check if running in a container

if [ ! -n "$container" ]; then
  echo "Not recommended to run this script outside of containerized (i.e. disposable) environments, are you sure you want to continue? [y/N]"
  read -r response
  if [ "$response" != "y" ] && [ "$response" != "Y" ]; then
    echo "Exiting script."
    exit 1
  fi
fi

# Detect current distribution
if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRIBUTION=$ID
elif [ -f /etc/lsb-release ]; then
  . /etc/lsb-release
  DISTRIBUTION=$DISTRIB_ID
else
  DISTRIBUTION="unknown"
fi

case $DISTRIBUTION in
ubuntu)
  echo "Detected Ubuntu."
  sudo apt-get update

  # Add ppa repos
  sudo apt-get install software-properties-common -y
  sudo add-apt-repository ppa:aos1/diff-so-fancy -y

  # Install apt packages
  sudo apt-get install \
    zsh \
    ripgrep \
    less \
    tree \
    diff-so-fancy \
    vim \
    -y

  # Install LazyVim dependencies
  sudo apt-get install \
    fd-find \
    python3-neovim \
    python3-pip \
    python3-venv \
    luarocks \
    fish \
    -y
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  sudo rm -rf lazygit.tar.gz lazygit

  # Install rust via rustup
  # Version in apt repositories is usually too old
  curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path

  # Install neovim from appimage
  # Version in apt repositories is usually too old
  sudo apt purge neovim -y
  sudo apt autoremove -y
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
  chmod u+x nvim-linux-x86_64.appimage
  sudo ./nvim-linux-x86_64.appimage --appimage-extract
  sudo mv squashfs-root /
  sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
  rm nvim-linux-x86_64.appimage
  sudo rm -rf squashfs-root

  # Install nvm and nodejs (for github copilot)
  # Version in apt repositories is usually too old
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
  export NVM_DIR="$HOME/.config/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install 20

  # Install fzt from binary
  # Version in apt repositories is too old
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --bin

  # Install packages for distrobox workflow
  sudo apt install wl-clipboard -y  # Enables copying/pasting from clipboard between host and guest
  ;;

fedora)
  echo "Detected Fedora."
  sudo dnf update -y

  # Add copr repos
  sudo dnf copr enable atim/lazygit -y

  # Install dnf packages
  sudo dnf install \
    zsh \
    fzf \
    ripgrep \
    less \
    tree \
    diff-so-fancy \
    vim \
    -y

  # Install LazyVim dependencies
  sudo dnf install \
    neovim \
    fd-find \
    python3-neovim \
    python3-pip \
    python3-virtualenv \
    luarocks \
    fish \
    lazygit \
    rust \
    cargo \
    nodejs \
    -y

  # Install packages for distrobox workflow
  sudo dnf install wl-clipboard -y
  ;;
*)
  echo "Unsupported distribution: $DISTRIBUTION. Install packages manually."
  exit 1
  ;;
esac

echo "Package installation complete."
