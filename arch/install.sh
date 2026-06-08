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
  "${REPOS_HOME}"
)

for dir in "${dirs[@]}"; do
  mkdir -p "${dir}"
done





if $INSTALL_DEPS; then
  log_task_start "dependencies"

  sudo pacman -S --needed --noconfirm "${pacman_deps[@]}"

  if ! has_command yay; then
    log_info "dependencies: start yay installation..."
    YAY_PATH="${HOME}/Downloads/yay"
    git clone https://aur.archlinux.org/yay.git "${YAY_PATH}"
    makepkg -sir --dir "${YAY_PATH}" --needed --noconfirm
    rm -rf "${YAY_PATH}"
    yay -Y --gendb
    log_success "dependencies: installed yay"
  fi

  yay -S --needed --noconfirm "${yay_deps[@]}"

  log_task_finish "dependencies"
fi





log_task_start "dotfiles"

shopt -s dotglob nullglob
link_dir "${DOTFILES_HOME}/shared/src" "${DOTFILES_HOME}/shared/src"
link_dir "${MODULE_DIR}/src" "${MODULE_DIR}/src"
shopt -u dotglob nullglob

log_task_finish "dotfiles"





log_task_start "snapshots"

if [[ ! -f /etc/snapper/configs/root ]]; then
  log_info "snapshots: create snapper config"
  sudo snapper -c root create-config /
fi

log_info "snapshots: configure snapper"
sudo sed -i \
  -e "s/^ALLOW_USERS=.*/ALLOW_USERS=\"${USER}\"/" \
  -e 's/^BACKGROUND_COMPARISON=.*/BACKGROUND_COMPARISON="yes"/' \
  -e 's/^EMPTY_PRE_POST_CLEANUP=.*/EMPTY_PRE_POST_CLEANUP="yes"/' \
  -e 's/^EMPTY_PRE_MIN_AGE=.*/EMPTY_PRE_MIN_AGE="3600"/' \
  -e 's/^NUMBER_CLEANUP=.*/NUMBER_CLEANUP="yes"/' \
  -e 's/^NUMBER_MIN_AGE=.*/NUMBER_MIN_AGE="3600"/' \
  -e 's/^NUMBER_LIMIT=.*/NUMBER_LIMIT="50"/' \
  -e 's/^NUMBER_LIMIT_IMPORTANT=.*/NUMBER_LIMIT_IMPORTANT="10"/' \
  -e 's/^SYNC_ACL=.*/SYNC_ACL="no"/' \
  -e 's/^TIMELINE_CLEANUP=.*/TIMELINE_CLEANUP="yes"/' \
  -e 's/^TIMELINE_CREATE=.*/TIMELINE_CREATE="yes"/' \
  -e 's/^TIMELINE_MIN_AGE=.*/TIMELINE_MIN_AGE="3600"/' \
  -e 's/^TIMELINE_LIMIT_HOURLY=.*/TIMELINE_LIMIT_HOURLY="5"/' \
  -e 's/^TIMELINE_LIMIT_DAILY=.*/TIMELINE_LIMIT_DAILY="7"/' \
  -e 's/^TIMELINE_LIMIT_WEEKLY=.*/TIMELINE_LIMIT_WEEKLY="4"/' \
  -e 's/^TIMELINE_LIMIT_MONTHLY=.*/TIMELINE_LIMIT_MONTHLY="0"/' \
  -e 's/^TIMELINE_LIMIT_QUARTERLY=.*/TIMELINE_LIMIT_QUARTERLY="0"/' \
  -e 's/^TIMELINE_LIMIT_YEARLY=.*/TIMELINE_LIMIT_YEARLY="0"/' \
  /etc/snapper/configs/root

if [[ "$(stat -c "%G" /.snapshots)" != "wheel" || "$(stat -c "%a" /.snapshots)" != "750" ]]; then
  log_info "snapshots: set snapshots ownership and rights"
  sudo chown root:wheel /.snapshots
  sudo chmod 750 /.snapshots
fi

if ! systemctl is-active --quiet snapper-cleanup.timer; then
  log_info "snapshots: start cleanup timer"
  sudo systemctl enable --now snapper-cleanup.timer
fi

if ! systemctl is-active --quiet snapper-timeline.timer; then
  log_info "snapshots: start timeline timer"
  sudo systemctl enable --now snapper-timeline.timer
fi

log_info "snapshots: create grub-btrfs config"
sudo grub-mkconfig -o /boot/grub/grub.cfg

if ! systemctl is-active --quiet grub-btrfsd.service; then
  log_info "snapshots: start grub-btrfs service"
  sudo systemctl enable --now grub-btrfsd.service
fi

log_task_finish "snapshots"





log_task_start "network"

HOSTNAME=$(hostnamectl --static)
HOSTNAME_INPUT=$(ask_plain "hostname" "What is your host name?" "${HOSTNAME}" 1)
if [[ "${HOSTNAME_INPUT}" != "${HOSTNAME}" ]]; then
  sudo hostnamectl set-hostname "${HOSTNAME_INPUT}" --static
fi

DEVICE_NAME=$(hostnamectl --pretty)
DEVICE_NAME_INPUT=$(ask_plain "device_name" "What is your device name?" "${DEVICE_NAME}" 1)
if [[ "${DEVICE_NAME_INPUT}" != "${DEVICE_NAME}" ]]; then
  sudo hostnamectl set-hostname "${DEVICE_NAME_INPUT}" --pretty
fi

log_info "network: setting firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo systemctl enable --now ufw
sudo ufw enable

log_task_finish "network"





log_task_start "fonts"

log_info "fonts: refreshing cache..."
fc-cache -fv

CURRENT_EMOJI_FONT=$(fc-match -f "%{family}" "emoji:charset=1f600")
TARGET_EMOJI_FONT="Apple Color Emoji"

if [[ "${CURRENT_EMOJI_FONT}" == "${TARGET_EMOJI_FONT}" ]]; then
  log_info "emoji: default ${TARGET_EMOJI_FONT}"
else
  log_warn "emoji: not default ${TARGET_EMOJI_FONT}"
fi

log_task_finish "fonts"





log_task_start "shells"

if $INSTALL_DEPS; then
  install_git_deps shared_shell_deps
fi

get_default_shell() {
  basename -- "$(getent passwd "$(id -un)" | cut -d: -f7)"
}

if [[ "$(get_default_shell)" != "zsh" ]]; then
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
  pnpm add -g "${shared_node_deps[@]}"
fi

log_task_finish "nodejs"





log_success "done"
