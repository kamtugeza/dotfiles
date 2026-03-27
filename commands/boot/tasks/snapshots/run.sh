#!/usr/bin/env bash

if [[ "${SYSTEM_NAME}" == "arch" ]]; then
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

  if [[ "$(sudo stat -c "%G" /.snapshots)" != "wheel" ]]; then
    log_info "snapshots: set snapshots ownership and rights"
    sudo chown -R :wheel /.snapshots
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

  if ! systemctl is-active grub-btrfsd.service; then
    log_info "snapshots: start grub-btrfs service"
    sudo systemctl enable --now grub-btrfsd.service
  fi
fi

