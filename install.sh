#!/usr/bin/env bash

set -euo pipefail

export SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils/log.sh"
source "$SCRIPT_DIR/utils/os.sh"

export ARCH="$(uname -m)"
export OS="$(uname -s)"
export FORCE=false

while [[ $# -gt 0 ]]; do
  case $1 in

    --force|-f)
      FORCE=true
      shift
      ;;

    --help|-h)
      echo "Usage: $(basename "$0") [OPTIONS]"
      echo ""
      echo "Options:"
      echo "--force, -f     Overwrite existing files without backup."
      echo "--help, -h      Show help message."
      exit 0
      ;;

    *)
      err "Unknown option: $1"
      exit 1
      ;;

  esac
done

info "Configurations:"
info " - Force:  $FORCE"
info " - System: $OS ($ARCH)"

if ! is_ubuntu && ! is_mac; then 
  err "Setup only supports Linux (x86_64) and macOS (arm64)!" false 
  exit 1
fi

info "Environment setup initialized."

tasks=("big-bang")

for i in "${!tasks[@]}"; do
  export TASK_NAME="${tasks[$i]}"
  export TASK_DIR="$SCRIPT_DIR/tasks/$TASK_NAME"

  info "Started task: $TASK_NAME"

  if [[ i -eq 0 && -f "$TASK_DIR/.zshrc" ]]; then
    source "$TASK_DIR/.zshrc"
  fi

  if [[ -f "$TASK_DIR/zsh/env.sh" ]]; then
    source "$TASK_DIR/zsh/env.sh"
  fi

  bash "$TASK_DIR/run.sh"

  info "Finished task: $TASK_NAME"
done 

info "Environment ready!"
