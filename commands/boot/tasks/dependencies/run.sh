#!/usr/bin/env bash

if [[ "${SYSTEM_NAME}" == "arch" ]]; then
  sudo pacman -S --needed --noconfirm \
    base-devel \
    cliphist \
    codebook-lsp \
    fzf \
    git \
    ghostty \
    grub-btrfs \
    gum \
    inetutils \
    less \
    lua \
    lua-language-server \
    neovim \
    opencode \
    openssh \
    sed \
    snapper \
    snap-pac \
    ripgrep \
    tar \
    ufw \
    zig \
    zls \
    zoxide \
    zsh \
    which \
    wofi

  if ! has_command yay; then
    log_info "dependencies: start yay installation..."
    YAY_PATH="${HOME}/Downloads/yay"
    git clone https://aur.archlinux.org/yay.git "${YAY_PATH}"
    makepkg -sir --dir "${YAY_PATH}" --needed --noconfirm
    rm -rf "${YAY_PATH}"
    yay -Y --gendb
    log_success "dependencies: installed yay"
  fi

  yay -S --needed --noconfirm \
    google-chrome \
    zen-browser-bin

elif [[ "${SYSTEM_NAME}" == "mac" ]]; then
  if ! has_command brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brew install \
    anomalyco/tap/opencode \
    codebook-lsp \
    fzf \
    gum \
    lua \
    lua-language-server \
    neovim \
    ripgrep \
    zig \
    zls \
    zoxide

  brew install --cask \
    betterdisplay \
    discord \
    ghostty \
    google-chrome \
    karabiner-elements \
    obsidian \
    todoist-app
fi

