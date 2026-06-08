#!/usr/bin/env bash

source "${DOTFILES_HOME}/utils/logger.sh"

backup() {
  local source_path="${1}"

  if [[ ! -f "${source_path}" || -L "${source_path}" ]]; then
    return 0
  fi

  if ! mv "${source_path}" "${source_path}.$(date +%Y-%m-%dT%H-%M-%S)"; then
    log_err "failed to backup: ${source_path}"
  fi
}

link_dir() {
  local base_path="${1}"
  local source_path="${2}"
  local file_path
  local relative_path
  local target_path

  for file_path in "${source_path}"/*; do
    if [[ -d "${file_path}" ]]; then
      link_dir "${base_path}" "${file_path}"
      continue
    fi

    if [[ -f "${file_path}" ]]; then
      relative_path="${file_path#${base_path}/}"
      target_path="${HOME}/${relative_path}"
      link_file "${file_path}" "${target_path}"
      continue
    fi

    log_warn "skipping unsupported path: ${file_path}"
  done
}

link_file() {
  local source_path="${1}"
  local target_path="${2}"
  local target_dir="$(dirname -- "${target_path}")"

  if [[ -d "${source_path}" ]]; then
    log_err "source is a directory: ${source_path}"
  fi

  if [[ -d "${target_path}" ]]; then
    log_err "target is a directory: ${target_path}"
  fi

  if ! mkdir -p "${target_dir}"; then
    log_err "failed to create directory: ${target_dir}"
  fi

  backup "$target_path"

  if ! ln -sf "${source_path}" "${target_path}"; then
    log_err "failed to link: ${target_path}"
  fi

  log_info "linked: ${target_path}"
}
