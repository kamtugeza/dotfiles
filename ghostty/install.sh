#!/usr/bin/env bash

if ! has_command ghostty; then
  if is_mac; then
    brew install --cask ghostty

  elif is_ubuntu; then
    GHOSTTY_DEB_URL="https://github.com/mkasberg/ghostty-ubuntu/releases/download/1.2.0-0-ppa2/ghostty_1.2.0-0.ppa2_amd64_24.04.deb"
    GHOSTTY_DEB_FILE="$XDG_CACHE_HOME/ghostty_1.2.0-0.ppa2_amd64_24.04.deb"

    if [ ! -f "$GHOSTTY_DEB_FILE" ]; then
      curl -L "$GHOSTTY_DEB_URL" -o "$GHOSTTY_DEB_FILE"
    fi

    sudo apt-get install "$GHOSTTY_DEB_FILE"
  fi
fi

link "$MODULE_DIR/config" "$XDG_CONFIG_HOME/ghostty/config"
