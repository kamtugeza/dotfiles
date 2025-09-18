if [[ -f "$HOME/.config/zsh/env.sh" ]]; then
  source "$HOME/.config/zsh/env.sh"
fi

if [[ -f "$XDG_CONFIG_HOME/zsh/conf.sh" ]]; then
  source "$XDG_CONFIG_HOME/zsh/conf.sh"
fi
