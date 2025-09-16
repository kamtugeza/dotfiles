#!/usr/bin/env bash

export SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils/args.sh"
source "$SCRIPT_DIR/utils/log.sh"
source "$SCRIPT_DIR/utils/os.sh"

export ARCH="$(uname -m)"
export OS="$(uname -s)"
export FORCE=false

parse_args "$@"

if ! is_ubuntu && ! is_mac; then 
  err "Sorry, this setup only supports Linux (x86_64) and macOS (arm64). Detected: $OS ($ARCH)"
  exit 1
fi

info "Force: $FORCE"
info "System: $OS ($ARCH)"
info
info "Environment setup initialized."

tasks=()

for task_name in "${tasks[@]}"; do
  info "Started task: $task_name"


  info "Finished task: $task_name"
done 

info "Environment ready!"
