source "$DOTFILES_HOME/utils/logger.sh"

has_command() {
  local cmd="${1:-}"

  if [[ -z "${cmd}" ]]; then
    log_err "has_command: no command name provided"
    return 1
  fi
  
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    log_warn "has_command: ${cmd}: command not found"
    return 1
  fi

  return 0
}

install_git_deps() {
  local -n deps=$1
  local entry url target_basename target_dir

  for entry in "${deps[@]}"; do
    IFS='|' read -r url target_basename <<< "$entry"
    target_dir="${REPOS_HOME}/${target_basename}"

    if [[ -d "${target_dir}/.git" ]]; then
      log_info "git: pull ${url}"
      git -C "${target_dir}" pull --ff-only

    elif [[ -e "${target_dir}" ]]; then
      log_err "${target_dir} is not a git repo"
      return 1

    else
      log_info "git: clone ${url}"
      git clone "${url}" "${target_dir}"
    fi
  done
}

read_args() {
  DEBUG=false
  INSTALL_DEPS=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --debug)
        DEBUG=true
        shift
        ;;
      -I|--install)
        INSTALL_DEPS=true
        shift
        ;;
      *)
        shift
        ;;
    esac
  done
}

run_task() {
  local task_name="${1:-}"
  local task_action="${2:-}"
  local TASK_DIR task_path

  if [[ -z "${task_name}" || -z "${task_action}" ]]; then
    log_err "run_task: task name and action are required"
  fi

  if [[ ! "${task_name}" =~ ^[a-zA-Z0-9_-]+$ || ! "${task_action}" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    log_err "run_task: invalid task name or action"
  fi

  TASK_DIR="${MODULE_DIR}/tasks/${task_name}"
  task_path="${TASK_DIR}/${task_action}.sh"

  if [[ ! -f "${task_path}" ]]; then
    log_err "run_task: task not found: ${task_name}/${task_action}"
  fi

  log_task_start "${task_name}"
  source "${task_path}"
  log_task_finish "${task_name}"
}

