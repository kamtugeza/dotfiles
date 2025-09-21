#!/usr/bin/env zsh

ZINIT_HOME="$XDG_DATA_HOME/zinit"

if [[ ! -d "$ZINIT_HOME" ]]; then
  make_dir "$ZINIT_HOME"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"
