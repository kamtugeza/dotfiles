#!/usr/bin/env bash

FONTS_DIR="$XDG_DATA_HOME/fonts"

if is_mac; then
  FONTS_DIR="$HOME/Library/Fonts"
fi

for font_path in "$MODULE_DIR"/*.ttf; do
  link "$font_path" "$FONTS_DIR/$(basename "$font_path")"
done
