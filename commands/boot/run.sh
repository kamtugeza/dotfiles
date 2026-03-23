#!/usr/bin/env bash

# Core
run_task "dependencies"
run_task "directories"
run_task "network"

# Desktop Env
run_task "fonts"
run_task "keyboard"

# Dev Env
run_task "shell"
run_task "ssh"
run_task "tmux"
run_task "vcs"
run_task "ghostty"
run_task "nodejs"
run_task "opencode"
run_task "neovim"

log_warn "boot: reboot required to apply changes"

