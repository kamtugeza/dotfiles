#!/usr/bin/env bash

if ! has_command zig; then
  ZIG_VERSION="0.16.0-dev.577+c50aa2b95"
  ZIG_FILENAME="zig-${ARCH}-${OS,,}-${ZIG_VERSION}"
  ZIG_TAR="$ZIG_FILENAME.tar.xz"
  ZIG_SOURCE="$XDG_CACHE_HOME/zig/$ZIG_TAR"
  ZIG_HOME="$HOME/.local/opt/zig"

  make_dir "$(dirname "$ZIG_SOURCE")"
  make_dir "$ZIG_HOME"

  if [[ ! -f "$ZIG_SOURCE" ]]; then
    if ! curl -L -f -o "$ZIG_SOURCE" "https://ziglang.org/builds/$ZIG_TAR"; then
      err "Failed to download $ZIG_TAR"
      exit 1
    fi
  fi

  rm -fr "$ZIG_HOME/$ZIG_FILENAME" "$ZIG_HOME/$ZIG_VERSION"
  tar -xf "$ZIG_SOURCE" -C "$ZIG_HOME"
  mv "$ZIG_HOME/$ZIG_FILENAME" "$ZIG_HOME/$ZIG_VERSION"
  ln -sf "$ZIG_HOME/$ZIG_VERSION/zig" "$XDG_BIN_HOME/zig"
fi
