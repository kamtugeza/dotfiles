#!/usr/bin/env bash

set -euo pipefail

source "$SCRIPT_DIR/utils/fs.sh"
source "$SCRIPT_DIR/utils/log.sh"

dirs=(
	"$XDG_BIN_HOME"
	"$XDG_CACHE_HOME"
	"$XDG_CONFIG_HOME"
	"$XDG_DATA_HOME"
	"$XDG_LIB_HOME"
	"$XDG_OPT_HOME"
	"$XDG_STATE_HOME"
	"$ZSH_CONFIG_HOME"
)

make_dir "${dirs[@]}"

copy "$TASK_DIR/.zshrc" "$HOME/.zshrc"
copy "$TASK_DIR/zsh" "$ZSH_CONFIG_HOME"
