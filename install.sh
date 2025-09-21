#!/usr/bin/env bash

set -euo pipefail

export SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils.sh"

export ARCH="$(uname -m)"
export OS="$(uname -s)"

info "Configurations:"
info " - System: $OS ($ARCH)"

if ! is_ubuntu && ! is_mac; then 
  err "Setup only supports Linux (x86_64) and macOS (arm64)!" false 
  exit 1
fi

modules=("big-bang")

for module_name in "${modules[@]}"; do
  export MODULE_NAME="$module_name"
  export MODULE_DIR="$SCRIPT_DIR/$MODULE_NAME"

  info "Start: $MODULE_NAME"

  source "$MODULE_DIR/run.sh"

  info "Finished: $MODULE_NAME"
done 

info "Environment ready!"

exit 0
