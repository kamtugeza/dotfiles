#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils.sh"

ARCH="$(uname -m)"
OS="$(uname -s)"

info "Configurations:"
info " - System: $OS ($ARCH)"

if ! is_ubuntu && ! is_mac; then 
  err "Setup only supports Linux (x86_64) and macOS (arm64)!" false 
  exit 1
fi

modules=("big-bang" "zsh")

for module_name in "${modules[@]}"; do
  MODULE_NAME="$module_name"
  MODULE_DIR="$SCRIPT_DIR/$MODULE_NAME"

  info "Start: $MODULE_NAME"

  source "$MODULE_DIR/install.sh"

  info "Finished: $MODULE_NAME"
done 

info "Environment ready!"

exit 0
