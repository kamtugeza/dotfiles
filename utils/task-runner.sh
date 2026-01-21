#!/usr/bin/env bash

source "${DOTFILES_HOME}/utils/logger.sh"

run_task() {
    local task_name="$1"

    log_info "${task_name}: executing..."

    TASK_PATH="${DOTFILES_HOME}/tasks/${task_name}"

    if (cd "${TASK_PATH}" && TASK_PATH="${TASK_PATH}" bash "install.sh"); then
        log_success "${task_name}: finished"
    else
        log_err "run_task: installation failed"
	exit 1
    fi
}
