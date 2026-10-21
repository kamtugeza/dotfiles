get_latest_podman_version() {
  local release_url version

  release_url="$(curl -fsSLI \
    -o /dev/null \
    -w '%{url_effective}' \
    https://github.com/podman-container-tools/podman/releases/latest)"
  version="${release_url##*/v}"

  if [[ ! "${version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    log_err "podman: failed to determine the latest release version"
  fi

  printf '%s\n' "${version}"
}

get_installed_podman_version() {
  local version

  if ! command -v podman >/dev/null 2>&1; then
    return 1
  fi

  version="$(podman --version 2>/dev/null)" || return 1
  version="${version##* }"

  if [[ ! "${version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    return 1
  fi

  printf '%s\n' "${version}"
}

is_version_lower() {
  local installed_version=$1
  local release_version=$2
  local -a installed_parts release_parts
  local i

  IFS='.' read -r -a installed_parts <<< "${installed_version}"
  IFS='.' read -r -a release_parts <<< "${release_version}"

  for i in 0 1 2; do
    if (( 10#${installed_parts[$i]} < 10#${release_parts[$i]} )); then
      return 0
    fi

    if (( 10#${installed_parts[$i]} > 10#${release_parts[$i]} )); then
      return 1
    fi
  done

  return 1
}

stop_podman_machine() {
  local machine_state

  machine_state="$(podman machine inspect --format '{{.State}}' 2>/dev/null)" || return 0

  if [[ "${machine_state}" == "running" ]]; then
    log_info "podman: stopping machine before installation"
    podman machine stop
  fi
}

install_podman() {
  local version=$1
  local asset_name="podman-installer-macos-arm64.pkg"
  local installer_dir installer_path shasums_path expected_checksum actual_checksum signature_info

  if command -v podman >/dev/null 2>&1; then
    stop_podman_machine
  fi

  installer_dir="$(mktemp -d "${TMPDIR:-/tmp}/podman.XXXXXX")"
  installer_path="${installer_dir}/${asset_name}"
  shasums_path="${installer_dir}/shasums"

  if ! curl -fL \
    -o "${installer_path}" \
    "https://github.com/podman-container-tools/podman/releases/download/v${version}/${asset_name}"; then
    rm -rf "${installer_dir}"
    log_err "podman: failed to download v${version}"
  fi

  if ! curl -fsSL \
    -o "${shasums_path}" \
    "https://github.com/podman-container-tools/podman/releases/download/v${version}/shasums"; then
    rm -rf "${installer_dir}"
    log_err "podman: failed to download the v${version} checksums"
  fi

  expected_checksum="$(awk -v asset="${asset_name}" '$2 == asset { print $1; exit }' "${shasums_path}")"
  actual_checksum="$(shasum -a 256 "${installer_path}" | awk '{ print $1 }')"

  if [[ ! "${expected_checksum}" =~ ^[[:xdigit:]]{64}$ || "${actual_checksum}" != "${expected_checksum}" ]]; then
    rm -rf "${installer_dir}"
    log_err "podman: checksum verification failed"
  fi

  log_info "podman: checksum verified"

  if ! signature_info="$(/usr/sbin/pkgutil --check-signature "${installer_path}" 2>&1)"; then
    printf '%s\n' "${signature_info}" >&2
    rm -rf "${installer_dir}"
    log_err "podman: package signature verification failed"
  fi

  if [[ "${signature_info}" != *"Developer ID Installer: Red Hat, Inc. (HYSCB8KRL2)"* ]]; then
    printf '%s\n' "${signature_info}" >&2
    rm -rf "${installer_dir}"
    log_err "podman: package was not signed by the expected publisher"
  fi

  log_info "podman: package signature verified"

  if ! sudo /usr/sbin/installer -pkg "${installer_path}" -target /; then
    rm -rf "${installer_dir}"
    log_err "podman: failed to install v${version}"
  fi

  export PATH="/opt/podman/bin:${PATH}"
  hash -r

  rm -rf "${installer_dir}"
}

get_latest_docker_compose_version() {
  local release_url version

  release_url="$(curl -fsSLI \
    -o /dev/null \
    -w '%{url_effective}' \
    https://github.com/docker/compose/releases/latest)"
  version="${release_url##*/v}"

  if [[ ! "${version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    log_err "docker-compose: failed to determine the latest release version"
  fi

  printf '%s\n' "${version}"
}

get_installed_docker_compose_version() {
  local compose_path=$1
  local version

  version="$("${compose_path}" version --short 2>/dev/null)" || return 1
  version="${version#v}"

  if [[ ! "${version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    return 1
  fi

  printf '%s\n' "${version}"
}

install_docker_compose() {
  local version=$1
  local asset_name="docker-compose-darwin-aarch64"
  local installer_dir

  installer_dir="$(mktemp -d "${TMPDIR:-/tmp}/docker-compose.XXXXXX")"

  if ! curl -fL \
    -o "${installer_dir}/${asset_name}" \
    "https://github.com/docker/compose/releases/download/v${version}/${asset_name}"; then
    rm -rf "${installer_dir}"
    log_err "docker-compose: failed to download v${version}"
  fi

  if ! curl -fsSL \
    -o "${installer_dir}/${asset_name}.sha256" \
    "https://github.com/docker/compose/releases/download/v${version}/${asset_name}.sha256"; then
    rm -rf "${installer_dir}"
    log_err "docker-compose: failed to download the v${version} checksum"
  fi

  if ! (cd "${installer_dir}" && shasum -a 256 -c "${asset_name}.sha256"); then
    rm -rf "${installer_dir}"
    log_err "docker-compose: checksum verification failed"
  fi

  mkdir -p "${XDG_BIN_HOME}"
  install -m 0755 "${installer_dir}/${asset_name}" "${XDG_BIN_HOME}/docker-compose"
  rm -rf "${installer_dir}"
}

install_or_update_docker_compose() {
  local compose_path installed_version release_version

  compose_path="$(command -v docker-compose 2>/dev/null || true)"

  if [[ -n "${compose_path}" && "${compose_path}" != "${XDG_BIN_HOME}/docker-compose" ]]; then
    log_info "docker-compose: using external installation at ${compose_path}"
    return 0
  fi

  release_version="$(get_latest_docker_compose_version)"
  log_info "docker-compose: latest release is v${release_version}"

  if [[ -n "${compose_path}" ]] && installed_version="$(get_installed_docker_compose_version "${compose_path}")"; then
    if [[ "${installed_version}" == "${release_version}" ]]; then
      log_info "docker-compose: v${installed_version} is already installed"
    elif is_version_lower "${installed_version}" "${release_version}"; then
      log_info "docker-compose: updating v${installed_version} to v${release_version}"
      install_docker_compose "${release_version}"
    else
      log_info "docker-compose: installed v${installed_version} is newer than v${release_version}"
    fi
  else
    log_info "docker-compose: installing v${release_version}"
    install_docker_compose "${release_version}"
  fi
}

ensure_podman_machine_running() {
  local machine_state

  if ! podman machine inspect >/dev/null 2>&1; then
    log_info "podman: initializing machine"
    podman machine init
  fi

  machine_state="$(podman machine inspect --format '{{.State}}')"

  if [[ "${machine_state}" != "running" ]]; then
    log_info "podman: starting machine"
    podman machine start
  else
    log_info "podman: machine is already running"
  fi
}

install_or_update_podman() {
  local release_version installed_version

  release_version="$(get_latest_podman_version)"
  log_info "podman: latest release is v${release_version}"

  if installed_version="$(get_installed_podman_version)"; then
    if [[ "${installed_version}" == "${release_version}" ]]; then
      log_info "podman: v${installed_version} is already installed"
    elif is_version_lower "${installed_version}" "${release_version}"; then
      log_info "podman: updating v${installed_version} to v${release_version}"
      install_podman "${release_version}"
    else
      log_info "podman: installed v${installed_version} is newer than v${release_version}"
    fi
  else
    log_info "podman: installing v${release_version}"
    install_podman "${release_version}"
  fi
}
