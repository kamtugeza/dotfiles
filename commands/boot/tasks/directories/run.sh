#!/usr/bin/env bash

dirs=(
    "${XDG_BIN_HOME}"
    "${XDG_CACHE_HOME}"
    "${XDG_CONFIG_HOME}"
    "${XDG_DATA_HOME}"
    "${XDG_LIB_HOME}"
    "${XDG_OPT_HOME}"
    "${XDG_STATE_HOME}"
    "${ZSH_CONFIG_HOME}"
    "${HOME}/Downloads"
)

log_info "directories: create missed directories"
make_dir "${dirs[@]}"

