#!/usr/bin/env bash

set -euo pipefail

source "${DOTFILES_HOME}/utils/misc.sh"

# Bash doesn't know about NVM
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"

if ! has_command nvm; then
  if [[ ! -d "${NVM_DIR}" ]]; then
    git clone https://github.com/nvm-sh/nvm.git "${NVM_DIR}"
  else 
    git -C "${NVM_DIR}" fetch --tags --quiet
  fi
  
  latest_tag="$(git -C "${NVM_DIR}" describe --abbrev=0 --tags --match 'v[0-9]*' "$(git -C "${NVM_DIR}" rev-list --tags --max-count=1)")"
  git -C "${NVM_DIR}" -c advice.detachedHead=false checkout "${latest_tag}"

  \. "${NVM_DIR}/nvm.sh"

  nvm install --lts
fi

if ! has_command pnpm; then
  npm install -g pnpm
  pnpm config set global-bin-dir "${NVM_BIN}"
  pnpm config set global-dir "$(dirname "${NVM_BIN}")/pnpm-global"
fi

has_command bash-language-server || pnpm add -g bash-language-server
has_command tsc || pnpm add -g typescript @vtsls/language-server
has_command vscode-html-language-server || pnpm add -g vscode-langservers-extracted
