source "${DOTFILES_HOME}/utils/logger.sh"

backup() {
  local src="${1%/}"
  local src_short="${1/#$HOME/~}"

  if [[ ! -e "${src}" && ! -L "${src}" ]]; then
    return 0
  fi

  if [[ -L "${src}" ]]; then
    rm "${src}"
    return 0
  fi

  local src_rel="${src#$HOME/}"
  local dst_dir="${XDG_CACHE_HOME}/dotfiles/backups"
  local dst="${dst_dir}/${src_rel//\//_}.bak.$(date +%Y%m%d_%H%M%S)"
  local dst_short="${dst/#$HOME/~}"

  make_dir "${dst_dir}"

  if cp -a "${src}" "${dst}"; then   
    log_info "cp: ${src_short} -> ${dst_short}"
  else
    log_err "cp: ${src_short}: failed to backup"
    return 1
  fi

  rm -rf "${src}"
}

link() {
  local src="$1"
  local dst="$2"

  local src_short="${src/#$HOME/~}"
  local dst_short="${dst/#$HOME/~}"

  if [[ ! -e "${src}" ]]; then
    log_err "link_file: ${src_short}: source not found"
    return 1
  fi

  backup "${dst}"
  make_dir "$(dirname "${dst}")"

  if ln -sf "${src}" "${dst}"; then
    log_info "ln: ${dst_short} -> ${src_short}"
  else
    log_err "ln: ${dst_short}: failed to link"
    return 1
  fi
}

make_dir() {
  for dir in "$@"; do
    if ! mkdir -p "${dir}"; then
      log_err "make_dir: ${dir}: failed to create directory"
      return 1
    fi
  done
}
