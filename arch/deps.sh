#!/usr/bin/env bash

source "${DOTFILES_HOME}/shared/deps.sh"

pacman_deps=(
  base-devel
  btop
  cliphist
  codebook-lsp
  fzf
  git
  ghostty
  grub-btrfs
  gum
  inetutils
  less
  libnotify
  lua
  lua-language-server
  neovim
  noto-fonts-emoji
  opencode
  openssh
  rclone
  sed
  snapper
  snap-pac
  swaybg
  swaync
  ripgrep
  tar
  ufw
  zig
  zls
  zoxide
  zsh
  which
  wofi
)

yay_deps=(
  google-chrome
  hypremoji
  ttf-apple-emoji
  zen-browser-bin
)
