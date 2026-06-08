#!/usr/bin/env bash

source "${DOTFILES_HOME}/shared/deps.sh"

brew_formula_deps=(
  anomalyco/tap/opencode
  bash
  codebook-lsp
  fzf
  gum
  lua
  lua-language-server
  neovim
  ripgrep
  zig
  zls
  zoxide
)

brew_cask_deps=(
  betterdisplay
  discord
  ghostty
  google-chrome
  karabiner-elements
  obsidian
  todoist-app
)
