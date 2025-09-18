install_gcc() {
  # This setup assumes that either GCC or Clang (on macOS) is already installed.
  # Installing a compiler is the only step here that require root privileges.
  if ! has_command gcc; then 
    if is_mac; then
      if xcode-select --install 2>/dev/null; then
        info "Xcode Command Line Tools installation started"
        info "After installation, re-run this script"
        exit 0
      else
        err "Failed to start Xcode Command Line Tools installation"
        exit 1
      fi

    elif is_ubuntu; then
      info "Installing build-essential..."
      sudo apt-get update
      sudo apt-get install -y build-essential libncursesw5-dev
    fi
  fi
}

install_zsh() {
  if has_command zsh; then
    return 0
  fi

  local version="5.9"

  info "Installing zsh v$version..."

  local output_dir="$XDG_CACHE_HOME/zsh-build/$version"
  local tarball="zsh-$version.tar.xz"
  local tarball_path="$output_dir/$tarball"
  local source_url="https://sourceforge.net/projects/zsh/files/zsh/$version/$tarball/download"
  local source_path="$output_dir/$(basename "${tarball%%.tar.*}")"
  local prefix="$XDG_OPT_HOME/zsh/$version"

  download "$source_url" "$tarball_path"
  extract "$tarball_path" "$output_dir"
  compile "$source_path" "$prefix" --enable-multibyte

  ln -sf "$prefix/bin/zsh" "$XDG_BIN_HOME/zsh"

  info "zsh v$version installed"
}