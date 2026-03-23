#!/usr/bin/env bash

if [[ "${SYSTEM_NAME}" == "arch" ]]; then
  sudo pacman -Syu --needed --noconfirm \
    codebook-lsp \
    fzf \
    git \
    ghostty \
    gum \
    inetutils \
    less \
    lua \
    lua-language-server \
    neovim \
    opencode \
    openssh \
    ripgrep \
    ufw \
    zig \
    zls \
    zoxide \
    zsh \
    which 

elif [[ "${SYSTEM_NAME}" == "mac" ]]; then
  if ! has_command brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brew install --cask \
    betterdisplay \
    discord \
    ghostty \
    google-chrome \
    lua \
    lua-language-server \
    karabiner-elements \
    obsidian \
    todoist-app

  brew install \
    anomalyco/tap/opencode \
    codebook-lsp \
    fzf \
    gum \
    neovim \
    ripgrep \
    zig \
    zls \
    zoxide
fi
