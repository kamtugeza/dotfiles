#!/usr/bin/env bash

run_task() {
  local task_name="${1}"

  log_info "run_task: starting ${task_name}..."

  TASK_PATH="${COMMAND_PATH}/tasks/${task_name}"

  (
    set -euo pipefail

    if [[ $DEBUG == 1 ]]; then
      set -x
    fi

    TASK_PATH="${TASK_PATH}" \
    source "${TASK_PATH}/run.sh"
  )

  if [[ $? == 0 ]]; then
    log_success "run_task: finished ${task_name}"
  else
    log_err "run_task: ${task_name} failed"
    exit 1
  fi
}
