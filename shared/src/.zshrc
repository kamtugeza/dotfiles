#!/usr/bin/env zsh

source "${HOME}/.exports"

# General
source "${ZSH_CONFIG_HOME}/aliases.sh"
source "${ZSH_CONFIG_HOME}/completion.sh"
source "${ZSH_CONFIG_HOME}/history.sh"
source "${ZSH_CONFIG_HOME}/prompt.sh"

# Fuzzy Finder
source <(fzf --zsh)
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
export FZF_COMPLETION_DIR_OPTS="--walker dir,follow,hidden"

# Zoxide
source <(zoxide init zsh --cmd cd)

# Node
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"
[ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"
