#!/usr/bin/env bash

SOURCE_DIR="${DOTFILES_HOME}/configs/local/share/fonts" 

if [[ "${SYSTEM_NAME}" == "arch" ]]; then
  link "${SOURCE_DIR}" "${XDG_DATA_HOME}/fonts"

  # The following command should retur: apple-color-emoji.ttf: "Apple Color Emoji" "Regular"
  # fc-match "sans:charset=1f600"
  link "${DOTFILES_HOME}/configs/config/fontconfig/conf.d/01-emoji.conf" "${XDG_CONFIG_HOME}/fontconfig/conf.d/01-emoji.conf"

  log_info "fonts: refreshing cache..."
  fc-cache -fv

  TARGET_EMOJI_FONT="Apple Color Emoji"
  CURRENT_EMOJI_FONT=$(fc-match -f "%{family}" "emoji:charset=1f600")

  if [[ "${CURRENT_EMOJI_FONT}" == "${TARGET_EMOJI_FONT}" ]]; then
    log_info "emoji: default ${TARGET_EMOJI_FONT}"
  else
    log_warn "emoji: not default ${TARGET_EMOJI_FONT}"
  fi

elif [[ "${SYSTEM_NAME}" == "mac" ]]; then
  TARGET_DIR="${HOME}/Library/Fonts"

  for font_path in "${SOURCE_DIR}"/*.ttf; do
    font_name=$(basename "${font_path}")
    cp "${font_path}" "${TARGET_DIR}/${font_name}"
    log_info "cp: ${font_path/#$HOME/~} -> ${TARGET_DIR/#$HOME/~}/${font_name}"
  done

fi

