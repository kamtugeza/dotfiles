compile() {
  local source_path="$1"
  local prefix="$2"

  if [[ -z "$source_path" || -z "$prefix" ]]; then
    err "Invalid arguments. Usage: compile <source_path> <prefix> [configure options]"
    exit 1
  fi

  if [[ ! -d "$source_path" ]]; then
    err "Source not found: $source_path"
    exit 1
  fi

  local log="$source_path/compile.log"
  local jobs=1

  if command -v nproc >/dev/null 2>&1; then
    jobs="$(nproc)"
  elif command -v sysctl >/dev/null 2>&1; then
    jobs="$(sysctl -n hw.ncpu 2>/dev/null || echo 1)"
  fi

  make_dir "$prefix"

  quiet_pushd "$source_path"
    info "Compiling: $source_path"
    info "Logs: $log"

    if ! ./configure --prefix="$prefix" "${@:3}" >"$log" 2>&1; then
      err "Configure failed. See $log for details."
      quiet_popd
      exit 1
    fi

    if ! make -j"$(jobs)" >>"$log" 2>&1; then
      err "Build failed. See $log for details."
      quiet_popd
      exit 1
    fi

    if ! make install >>"$log" 2>&1; then
      err "Install failed. See $log for details."
      quiet_popd
      exit 1
    fi

    info "Compiled into: $prefix"
  quiet_popd
}

extract() {
  if [[ $# -ne 2 ]]; then
    err "Invalid arguments. Usage: extract <tarball_path> <output_dir>"
    exit 1
  fi

  local tarball_path="$1"
  local output_dir="$2"

  info "Extracting: $tarball_path"
  tar -xf "$tarball_path" -C "$output_dir"
  info "Extracted into: $output_dir/$(basename "${tarball_path%%.tar.*}")"
}

has_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    warn "Command not found: $1"
    return 1
  fi

  return 0
}

quiet_pushd() {
  if ! pushd "$1" >/dev/null; then
    exit 1
  fi
}

quiet_popd() {
  if ! popd >/dev/null; then
    exit 1
  fi
}