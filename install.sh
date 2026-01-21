#!/usr/bin/env bash

export DOTFILES_HOME="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source "${DOTFILES_HOME}/shared/.exports"
source "${DOTFILES_HOME}/utils/file-system.sh"
source "${DOTFILES_HOME}/utils/logger.sh"
source "${DOTFILES_HOME}/utils/misc.sh"
source "${DOTFILES_HOME}/utils/task-runner.sh"

TASK_NAME="all"
export UPDATE_PKG=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -H|--help)
      show_help
      exit 0
      ;;
    -U|--update)
      UPDATE_PKG=true
      shift
      ;;
    -*)
      log_err "unknown option: $1"
      exit 1
      ;;
    *)
      TASK_NAME="$1"
      shift
      ;;
  esac
done

if [[ "${TASK_NAME}" != "all" ]]; then
    run_task "${TASK_NAME}"
    exit 0
fi

run_task "core"
run_task "keyboard"
run_task "git"
run_task "ssh"
run_task "zsh"
run_task "ghostty"
run_task "lua" 
run_task "node"
run_task "zig"
run_task "tmux"
run_task "opencode"
run_task "nvim"
run_task "vscode"
run_task "zed"

log_success "environment configured successfully! ^^"
