#!/usr/bin/env bash

source "${DOTFILES_HOME}/utils/logger.sh"
source "${DOTFILES_HOME}/utils/path.sh"

backup() {
  local source_path="${1}"
  local backup_path="${source_path}.$(date +%Y-%m-%dT%H-%M-%S)"

  [[ ! -e "${source_path}" || -L "${source_path}" ]] && return 0

  if mv "${source_path}" "${backup_path}"; then
    log_info "backed up: ${source_path} → ${backup_path}"
  else
    log_err "failed to backup: ${source_path}"
  fi
}

link_dir() {
  local source_path="${1}"
  local target_path="${2}"
  local target_dir="$(dirname -- "${target_path}")"

  [[ ! -d "${source_path}" ]] && log_err "source is not a directory: ${source_path}"
  [[ -f "${source_path}" ]] && log_err "source is a file: ${source_path}"
  [[ "${source_path}" == "${target_path}" ]] && log_err "source and target are the same: ${source_path}"

  if ! mkdir -p "${target_dir}"; then
    log_err "failed to create directory: ${target_dir}"
  fi


  # Existing symlink, including broken symlink
  if [[ -L "${target_path}" ]]; then
    local existing_link="$(readlink "${target_path}")"

    if [[ "${existing_link}" == "${source_path}" ]]; then
      log_info "already linked directory: ${target_path} -> ${source_path}"
      return 0
    fi

    if ! rm "${target_path}"; then
      log_err "failed to remove existing symlink: ${target_path}"
    fi
  fi

  backup "${target_path}"
  
  # Achtung: do not use ln -sfn here.
  # Plain ln -s fails safely if something still exists at target_path.
  if ! ln -s "${source_path}" "${target_path}"; then
    log_err "failed to link directory: ${target_path}"
  fi

  log_info "linked: $(home_relative "${target_path}") → $(home_relative "${source_path}")"
}

link_files() {
  local base_path="${1}"
  local source_path="${2}"
  local file_path
  local relative_path
  local target_path

  for file_path in "${source_path}"/*; do
    if [[ "$(basename -- "${file_path}")" == ".DS_Store" ]]; then
      continue
    fi

    if [[ -d "${file_path}" ]]; then
      link_files "${base_path}" "${file_path}"
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

  [[ -d "${source_path}" ]] && log_err "source is a directory: ${source_path}"
  [[ -d "${target_path}" ]] && log_err "target is a directory: ${target_path}"

  if ! mkdir -p "${target_dir}"; then
    log_err "failed to create directory: ${target_dir}"
  fi

  backup "${target_path}"

  if ! ln -sf "${source_path}" "${target_path}"; then
    log_err "failed to link: ${target_path}"
  fi

  log_info "linked: $(home_relative "${target_path}") → $(home_relative "${source_path}")"
}
