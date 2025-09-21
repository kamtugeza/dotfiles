#!/usr/bin/env bash

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
