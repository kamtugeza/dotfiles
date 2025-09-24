#!/usr/bin/env zsh

source "$HOME/.exports"

ZINIT_HOME="$XDG_DATA_HOME/zinit"

if [[ ! -d "$ZINIT_HOME" ]]; then
  make_dir "$ZINIT_HOME"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# Fuzzy Finder
source <(fzf --zsh)
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
export FZF_COMPLETION_DIR_OPTS="--walker dir,follow,hidden"

source <(zoxide init zsh)
source "$ZSH_CONFIG_HOME/complition.sh"
source "$ZSH_CONFIG_HOME/history.sh"
source "$ZSH_CONFIG_HOME/prompt.sh"

# Node
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
