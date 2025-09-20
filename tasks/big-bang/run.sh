#!/usr/bin/env bash

set -euo pipefail

source "$SCRIPT_DIR/utils/fs.sh"
source "$SCRIPT_DIR/utils/http.sh"
source "$SCRIPT_DIR/utils/log.sh"
source "$SCRIPT_DIR/utils/misc.sh"
source "$SCRIPT_DIR/utils/os.sh"

install_fonts() {
  local fonts_dir="$XDG_DATA_HOME/fonts"

  if is_mac; then
    fonts_dir="$HOME/Library/Fonts"
  fi

  for font in "$TASK_DIR"/fonts/*; do
    copy "$font" "$fonts_dir/$(basename "$font")"
  done

  if is_ubuntu; then 
    if has_command fc-cache; then
      fc-cache -fv >/dev/null
      info "Font cache updated!"
    else 
      warn "No \`fc-cache\`; fonts may not appear until cache refresh"
    fi
  fi
}

install_gcc() {
  # This setup assumes that either GCC or Clang (on macOS) is already installed.
  # Installing a compiler is the only step here that require root privileges.
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
      sudo apt-get update
      sudo apt-get install -y build-essential libncursesw4-dev
    fi
  fi
}

install_zsh() {
  if has_command zsh; then
    return -1
  fi

  local version="5.9"
  local output_dir="$XDG_CACHE_HOME/zsh-build/$version"
  local tarball_name="zsh-$version"
  local tarball="$tarball_name.tar.xz"
  local tarball_path="$output_dir/$tarball"
  local source_url="https://sourceforge.net/projects/zsh/files/zsh/$version/$tarball/download"
  local source_path="$output_dir/$tarball_name"
  local prefix="$XDG_OPT_HOME/zsh/$version"

  info "Installing zsh v$version..."
  download "$source_url" "$tarball_path"
  extract "$tarball_path" "$output_dir"
  compile "$source_path" "$prefix" --enable-multibyte
  ln -sf "$prefix/bin/zsh" "$XDG_BIN_HOME/zsh"
  info "zsh v$version installed"
}

# Task
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
copy "$TASK_DIR/zsh/conf.sh" "$ZSH_CONF"
copy "$TASK_DIR/zsh/env.sh" "$ZSH_ENV"

install_gcc
install_zsh
install_fonts
