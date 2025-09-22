#!/usr/bin/env zsh

source "$HOME/.exports"

ZINIT_HOME="$XDG_DATA_HOME/zinit"

if [[ ! -d "$ZINIT_HOME" ]]; then
  make_dir "$ZINIT_HOME"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"
source <(fzf --zsh)
source <(zoxide init zsh)
source "$ZSH_CONFIG_HOME/complition.sh"
source "$ZSH_CONFIG_HOME/history.sh"
source "$ZSH_CONFIG_HOME/prompt.sh"
