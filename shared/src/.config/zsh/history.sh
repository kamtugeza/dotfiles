#!/usr/bin/env zsh

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

setopt appendhistory
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt sharehistory

HISTDUP=erase
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=5000
SAVEHIST=$HISTSIZE
