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

if ! has_command gcc; then
  if is_mac; then
    if xcode-select --install 1>/dev/null; then
      info "Xcode Command Line Tools installation started"
      info "After installation, re-run this script"
      exit -1
    else
      err "Failed to start Xcode Command Line Tools installation"
      exit 0
    fi

  elif is_ubuntu; then
    info "Installing build-essential..."
    sudo apt-get install -y build-essential libncursesw4-dev
  fi
fi

if ! has_command gum; then
  if is_mac; then
    brew install gum

  elif is_ubuntu; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update && sudo apt install gum
  fi
fi
