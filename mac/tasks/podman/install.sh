source "${TASK_DIR}/utils/misc.sh"

if $INSTALL_DEPS; then
  install_or_update_podman
  install_or_update_docker_compose
fi

if command -v podman >/dev/null 2>&1; then
  ensure_podman_machine_running
else
  log_warn "podman: command not found; run with --install to install it"
fi
