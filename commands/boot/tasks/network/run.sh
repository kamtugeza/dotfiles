#!/usr/bin/env bash

if [[ "${SYSTEM_NAME}" == "arch" ]]; then
  HOSTNAME=$(hostnamectl --static)
  HOSTNAME_INPUT=$(ask_plain "hostname" "What is your host name?" "${HOSTNAME}")
  if [[ ! -z "${HOSTNAME_INPUT}" && "${HOSTNAME_INPUT}" != "${HOSTNAME}" ]]; then
    sudo hostnamectl set-hostname "${HOSTNAME_INPUT}" --static
  fi

  DEVICE_NAME=$(hostnamectl --pretty)
  DEVICE_NAME_INPUT=$(ask_plain "device_name" "What is your device name?" "${DEVICE_NAME}")
  if [[ ! -z "${DEVICE_NAME_INPUT}" && "${DEVICE_NAME_INPUT}" != "${DEVICE_NAME}" ]]; then
    sudo hostnamectl set-hostname "${DEVICE_NAME_INPUT}" --pretty
  fi

  log_info "network: setting firewall..."
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo systemctl enable --now ufw
  sudo ufw enable

elif [[ "${SYSTEM_NAME}" == "mac" ]]; then
  COMPUTER_NAME=$(ask_plain "device-name" "What is your device name?")
  if [[ ${COMPUTER_NAME} != $(scutil --get ComputerName) ]]; then
    sudo scutil --set ComputerName "${COMPUTER_NAME}"
  fi

  HOST_NAME=$(ask_plain "host-name" "What is your host name?")
  if [[ ${HOST_NAME} != $(scutil --get HostName) ]]; then
    sudo scutil --set LocalHostName "${HOST_NAME}"
    sudo scutil --set HostName "${HOST_NAME}"
  fi
fi

