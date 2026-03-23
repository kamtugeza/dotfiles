#!/usr/bin/env bash

CACHE_DIR="${XDG_CACHE_HOME}/dotfiles/prompts"

mkdir -p "${CACHE_DIR}"

ask_plain() {
  local id="${1:-}"
  local question="${2:-}"
  local init_val="${3:-}"
  local is_strict="${4:-0}"

  if [[ -z "${id}" || -z "${question}" ]]; then
    log_err "ask_plain: invalid arguments"
  fi

  log_info "${question}"

  local cache_val=$(read_cache "${id}")
  value=$(gum input --value "${cache_val:-"${init_val}"}")

  if [[ "${is_strict}" -eq 1 && -z "${value}" ]]; then
    log_err "ask_plain: value cannot be empty"
  fi

  log_info "${value}"

  if [[ ! -z "${value}" ]]; then
    save_cache "${id}" "${value}"
  fi

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
