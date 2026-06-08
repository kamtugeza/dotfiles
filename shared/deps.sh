#!/usr/bin/env bash

shared_shell_deps=(
  "https://github.com/zsh-users/zsh-autosuggestions.git|zsh-autosuggestions"
  "https://github.com/zsh-users/zsh-completions.git|zsh-completions"
)

shared_node_deps=(
  @astrojs/language-server
  @biomejs/biome
  @vtsls/language-server
  bash-language-server
  typescript
  vscode-langservers-extracted
)
