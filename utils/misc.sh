source "$DOTFILES_HOME/utils/logger.sh"

has_cask() {
  local cask_name="${1:-}"

  if [[ -z "${cask_name}" ]]; then
    log_err "has_cask: no cask name provided"
    return 1
  fi
  
  if ! brew list --cask "${cask_name}" >/dev/null 2>&1; then
    log_warn "has_cask: ${cask_name}: cask not found"
    return 1
  fi

  return 0
}

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

show_help() {
  cat << EOF
Usage: $(basename "$0") [task_name] [options]

A dotfiles installation script.

Tasks:
  [task_name]      Run a specific task from tasks/ folder
  all              Default; runs all available tasks

Options:
  -U, --update     Update the package manager before running tasks
  -H, --help       Show this help message and exit

Examples:
  ./install                     # Run all tasks
  ./install zsh -U              # Update packages and run zsh task
  ./install vim                 # Run only the vim task
EOF
}
