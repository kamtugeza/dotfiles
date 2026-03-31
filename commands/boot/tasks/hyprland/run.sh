#!/usr/bin/env bash

link "${DOTFILES_HOME}/configs/local/share/wallpapers" "${XDG_DATA_HOME}/wallpapers"

link "${DOTFILES_HOME}/configs/config/hypr/modules/autostart.conf" "${XDG_CONFIG_HOME}/hypr/modules/autostart.conf"
link "${DOTFILES_HOME}/configs/config/hypr/modules/input.conf" "${XDG_CONFIG_HOME}/hypr/modules/input.conf"
link "${DOTFILES_HOME}/configs/config/hypr/modules/keybindings.conf" "${XDG_CONFIG_HOME}/hypr/modules/keybindings.conf"
link "${DOTFILES_HOME}/configs/config/hypr/modules/monitors.conf" "${XDG_CONFIG_HOME}/hypr/modules/monitors.conf"

