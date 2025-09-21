#!/usr/bin/env zsh

alias ls='ls --color'

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

autoload -U compinit && compinit
