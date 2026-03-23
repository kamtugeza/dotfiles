#!/usr/bin/env bash

set -euo pipefail

# Assume the repository is cloned to `~/.dotfiles`
source "${HOME}/.dotfiles/configs/exports"
source "${DOTFILES_HOME}/utils/logger.sh"
source "${DOTFILES_HOME}/utils/file-system.sh"
source "${DOTFILES_HOME}/utils/misc.sh"
source "${DOTFILES_HOME}/utils/prompt.sh"
source "${DOTFILES_HOME}/utils/task-runner.sh"

export COMMAND_NAME=""
export COMMAND_PATH=""
export DEBUG=0
export SYSTEM_NAME=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    boot)
      COMMAND_NAME="$1"
      COMMAND_PATH="${DOTFILES_HOME}/commands/${1}"
      shift
      ;;
    --debug)
      DEBUG=1
      shift
      ;;
    -*)
      log_err "dotfiles: unknown option: $1"
      ;;
    *)
      shift
      ;;
  esac
done

if [[ $DEBUG == 1 ]]; then
  set -x
fi

if [[ -z "${COMMAND_NAME}" ]]; then
  log_err "dotfiles: missed command name"
fi

case "$(uname -s)" in
  Darwin)
    SYSTEM_NAME="mac"
    ;;
  Linux*)
    SYSTEM_NAME="arch"
    ;;
  *)
    log_err "dotfiles: unsupported operating system" 
    ;;
esac

log_info "dotfiles: starting ${COMMAND_NAME}..."

source "${COMMAND_PATH}/run.sh"

log_success "dotfiles: ${COMMAND_NAME} finished successfully!"

