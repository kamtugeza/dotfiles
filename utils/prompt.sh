#!/usr/bin/env bash

source "${DOTFILES_HOME}/utils/logger.sh"

CACHE_DIR="${XDG_CACHE_HOME}/dotfiles/prompts"

mkdir -p "${CACHE_DIR}"

ask_plain() {
  local id="$1"
  local question="$2"

  log_info "${question}"
  local value=$(gum input --value "$(read_cache "${id}")")

  if [[ -z "${value}" ]]; then
    log_err "input_text: value cannot be empty"
    return 1
  fi

  log_info "${value}"

  save_cache "${id}" "${value}"

  echo "${value}"
}

read_cache() {
  local id="$1"

  if [[ -f "${CACHE_DIR}/${id}" ]]; then
    cat "${CACHE_DIR}/${id}"
  fi
}

save_cache() {
  local id="$1"
  local value="$2"

  echo "${value}" > "${CACHE_DIR}/${id}" 
}
