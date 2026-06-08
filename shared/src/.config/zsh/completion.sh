#!/usr/bin/env zsh

fpath=("${REPOS_HOME}/zsh-completions/src" $fpath)
source "${REPOS_HOME}/zsh-autosuggestions/zsh-autosuggestions.zsh"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

autoload -Uz compinit
compinit
