#!/usr/bin/env bash

set -euo pipefail

MODULE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_HOME="$(cd -- "${MODULE_DIR}/.." && pwd -P)"

source "${DOTFILES_HOME}/shared/src/.exports"
source "${DOTFILES_HOME}/utils/fs.sh"
source "${DOTFILES_HOME}/utils/logger.sh"
source "${DOTFILES_HOME}/utils/misc.sh"
source "${DOTFILES_HOME}/utils/prompt.sh"

source "${MODULE_DIR}/deps.sh"

read_args "$@"

if $DEBUG; then
  set -x
fi





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
  "${CODECRAFT_HOME}"
  "${REPOS_HOME}"
)

for dir in "${dirs[@]}"; do
  mkdir -p "${dir}"
done





log_info "configuring environment"





if $INSTALL_DEPS; then
  log_task_start "dependencies"

  if ! has_command brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ -x "/opt/homebrew/bin/brew" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else 
      log_err "Homebrew is not available in PATH"
    fi
  fi

  brew install "${brew_formula_deps[@]}"
  brew install --cask "${brew_cask_deps[@]}"

  log_task_finish "dependencies"
fi





log_task_start "dotfiles"

shopt -s dotglob nullglob
link_dir "${DOTFILES_HOME}/shared/src" "${DOTFILES_HOME}/shared/src"
link_dir "${MODULE_DIR}/src" "${MODULE_DIR}/src"
shopt -u dotglob nullglob

log_task_finish "dotfiles"





log_task_start "network"

COMPUTER_NAME="$(scutil --get ComputerName)"
COMPUTER_NAME_INPUT=$(ask_plain "device-name" "What is your device name?" "${COMPUTER_NAME}" 1)
if [[ "${COMPUTER_NAME_INPUT}" != "${COMPUTER_NAME}" ]]; then
  sudo scutil --set ComputerName "${COMPUTER_NAME_INPUT}"
fi

# On a clean macOS installation, HostName is not set by default, so we use LocalHostName instead.
LOCAL_HOST_NAME="$(scutil --get LocalHostName)"
LOCAL_HOST_NAME_INPUT=$(ask_plain "local-host-name" "What is your local host name?" "${LOCAL_HOST_NAME}" 1)
if [[ "${LOCAL_HOST_NAME_INPUT}" != "${LOCAL_HOST_NAME}" ]]; then
  sudo scutil --set LocalHostName "${LOCAL_HOST_NAME_INPUT}"
  sudo scutil --set HostName "${LOCAL_HOST_NAME_INPUT}.local"
fi

log_task_finish "network"





log_task_start "fonts"

SOURCE_DIR="${DOTFILES_HOME}/shared/src/.local/share/fonts"
TARGET_DIR="${HOME}/Library/Fonts"

shopt -s nullglob
for font_path in "${SOURCE_DIR}"/*.{otf,ttf}; do
  font_name=$(basename "${font_path}")
  cp "${font_path}" "${TARGET_DIR}/${font_name}"
  log_info "copied: ${TARGET_DIR/#$HOME/~}/${font_name}"
done
shopt -u nullglob

log_task_finish "fonts"





log_task_start "shells"

if $INSTALL_DEPS; then
  install_git_deps shared_shell_deps
fi

get_default_shell() {
  dscl . -read "/Users/$(id -un)" UserShell | awk '{print $2}'
}

if [[ "$(get_default_shell)" != "$(command -v zsh)" ]]; then
  if chsh -s "$(command -v zsh)" < /dev/tty; then
    log_success "configured ZSH as default shell"
  else
    log_warn "chsh: failed to change shell"
  fi
fi

log_task_finish "shells"





log_task_start "ssh"

SSH_HOME="${HOME}/.ssh"
SSH_KEY="${SSH_HOME}/id_ed25519"

if [[ ! -f "${SSH_KEY}" ]]; then
  log_warn "ssh: ${SSH_KEY} not found"

  if ssh-keygen -t ed25519 -a 100 -f "${SSH_KEY}" -C "$(whoami)@$(hostname)" < /dev/tty; then
    log_success "ssh-keygen: add this public key to providers:"
    gum style --foreground 212 --border normal --padding "0 1" < "${SSH_KEY}.pub"
  else
    log_error "ssh-keygen: failed or was interrupted."
  fi
fi

log_task_finish "ssh"




log_task_start "vcs"

# Forces XDG confi f
if [[ -f "${HOME}/.gitconfig" ]]; then
  backup "${HOME}/.gitconfig"
fi

PERSONAL_PATH="${XDG_CONFIG_HOME}/git/personal"
backup "${PERSONAL_PATH}"
> "${PERSONAL_PATH}"

USER_NAME=$(ask_plain "git-user-name" "What is your full name?" "" 1)
USER_EMAIL=$(ask_plain "git-user-email" "What is your email?" "" 1)

git config --file "${PERSONAL_PATH}" user.name "${USER_NAME}"
git config --file "${PERSONAL_PATH}" user.email "${USER_EMAIL}"

log_task_finish "vcs"





log_task_start "nodejs"

# Bash doesn't know about NVM
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"

if ! has_command nvm; then
  log_info "installing nvm"
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
  log_info "installing pnpm"
  npm install -g pnpm
  pnpm config set global-bin-dir "${NVM_BIN}"
  pnpm config set global-dir "$(dirname "${NVM_BIN}")/pnpm-global"
fi

if $INSTALL_DEPS; then
  pnpm add -g --ignore-scripts "${shared_node_deps[@]}"
fi

log_task_finish "nodejs"





log_success "done"
