#!/usr/bin/env bash

NEOVIM_VERSION=v0.11.4
NEOVIM_HOME="$XDG_CONFIG_HOME/nvim"

if ! has_command nvim || [[ "$NEOVIM_VERSION" != "$(nvim --version | head -n 1 | awk '{print $2}')" ]]; then
  output_dir="$XDG_OPT_HOME/nvim"
  release_url="https://github.com/neovim/neovim/releases/download"

  if is_mac; then
    tarball="nvim-macos-arm64.tar.gz"
    source_url="$release_url/$NEOVIM_VERSION/$tarball"
    tarball_dir="$XDG_CACHE_HOME/nvim/$NEOVIM_VERSION"

    make_dir "$output_dir" "$tarball_dir"
    curl -L -o "$tarball_dir/$tarball" "$source_url"
    tar xzf "$tarball_dir/$tarball" -C "$output_dir" --strip-components=1
    link "$output_dir/bin/nvim" "$XDG_BIN_HOME/nvim"
  fi

  if is_ubuntu; then
    source_url="$release_url/$NEOVIM_VERSION/nvim-linux-x86_64.appimage"

    make_dir "$output_dir"
    curl -L -o "$output_dir/nvim.appimage" "$source_url"
    chmod u+x "$output_dir/nvim.appimage"
    link "$output_dir/nvim.appimage" "$XDG_BIN_HOME/nvim"
  fi
fi

if ! has_command rg; then
  if is_mac; then
    brew install ripgrep
  fi

  if is_ubuntu; then
    sudo apt-get install ripgrep
  fi
fi

link "$MODULE_DIR/lua" "$NEOVIM_HOME/lua"
link "$MODULE_DIR/init.lua" "$NEOVIM_HOME/init.lua"

