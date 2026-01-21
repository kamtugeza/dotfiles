#!/usr/bin/env bash

RESTORE='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'

_msg() {
  local label=$1
  local color=$2
  local msg=$3

  # %-7s pads the label to 7 characters for perfect alignment
  printf "${color}%-7s${RESTORE} %s\n" "[$label]" "$msg" >&2
}

log_info() {
  _msg "INFO" "${BLUE}" "$1"
}

log_success() {
  _msg "DONE" "${GREEN}" "$1"
}

log_warn() {
  _msg "WARN" "${YELLOW}" "$1"
}

log_err() {
  _msg "ERR" "${RED}" "$1"
  exit 1
}
