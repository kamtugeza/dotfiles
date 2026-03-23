#!/usr/bin/env bash

SOURCE_DIR="${DOTFILES_HOME}/configs/local/share/fonts" 

if [[ "${SYSTEM_NAME}" == "arch" ]]; then
  link "${SOURCE_DIR}" "${XDG_DATA_HOME}/fonts"

  log_info "fonts: refreshing cache..."
  fc-cache -fv

elif [[ "${SYSTEM_NAME}" == "mac" ]]; then
  TARGET_DIR="${HOME}/Library/Fonts"

  for font_path in "${SOURCE_DIR}"/*.ttf; do
    font_name=$(basename "${font_path}")
    cp "${font_path}" "${TARGET_DIR}/${font_name}"
    log_info "cp: ${font_path/#$HOME/~} -> ${TARGET_DIR/#$HOME/~}/${font_name}"
  done

fi

