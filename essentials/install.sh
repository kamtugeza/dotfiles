#!/usr/bin/env bash

source "$MODULE_DIR/.exports"

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

link "$MODULE_DIR/.exports" "$HOME/.exports"

# apt-get sometimes does not provide the latest versions (e.g., fzf),
# which is why we install Homebrew on Ubuntu as well.
if ! has_command brew; then
  info "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update
brew upgrade
  
if is_ubuntu; then
  info "Refreshing package lists: sudo apt-get update"
  sudo apt-get update
  sudo apt-get upgrade
fi

source "$MODULE_DIR/gcc/install.sh"
source "$MODULE_DIR/fonts/install.sh"
